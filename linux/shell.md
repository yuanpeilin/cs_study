* **杂项**
    - [查看所有shell](#查看所有shell)
    - [Debug](#debug)
    - [option argument paramete](#选项)
* **变量类型**
    - [数组](#数组)
    - [Map](#map)
* **流程控制**
    - [if](#if)
    - [for](#for)
    - [while](#while)
    - [case](#case)
    - [select](#select)
* **字符串**
    - [字符串长度](#字符串长度)
    - [切割字符串](#切割字符串)
    - [字符串替换](#字符串替换)
* [切割参数](#切割参数)
* [模式匹配](#模式匹配)
* [引号](#引号)
* [整数进制](#整数进制)
* [整数运算](#整数运算)
* [特殊变量](#特殊变量)
* [变量存在性](#变量存在性)
* [条件测试](#条件测试)
    - [条件测试表达式](#条件测试表达式)
    - [整数值比较操作符含义](#整数值比较操作符含义)
    - [文件属性检查](#文件属性检查)
    - [字符串检查](#字符串检查)



<!-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = -->
<!-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = -->



# 查看所有shell
查看 */etc/shells* 文件

# Debug
```sh
$ bash -x <shell script>
```

# 选项
* **arguments** arguments也叫位置参数(positional parameters), 命令中的每个单词都是argument
* **options** 有长选项和短选项, 类似于`-l -v --long`
* **parameter** 既向命令提供信息也向他的option提供信息, 类似于`mysql -u root`中的`root`

```sh
$ ls -la /tmp /var/tmp
arg0 = ls
arg1 = -la
arg2 = /tmp
arg3 = /var/tmp

$ ls -la /tmp /var/tmp
option1= -l
option2= -a

$ ls -la /tmp /var/tmp
parameter1= /tmp
parameter2= /var/tmp

$ ls -l -- -a
option1 = -l
parameter1 = -a
```

# 数组
### 定义数组
```sh
declare -a array=(01 002 3 004)

declare -a array=([0]="01" [1]="002" [2]="3" [3]="004")

array=(01 002 3 004)

array[0]=9; array[1]=010; array[2]=11
```

### 访问数组
```sh
# 获取数组所有元素
declare -p array
echo ${array[*]}
echo "${array[*]}"
echo ${array[@]}
echo "${array[@]}"

# 获取所有索引
echo ${!array[*]}
echo ${!array[@]}

# 获取数组长度
echo ${#array[*]}
echo "${#array[*]}"
echo ${#array[@]}
echo "${#array[@]}"

# 获取数组最后一个元素
echo ${array[${#array[*]}-1]}
echo ${array[-1]}

# 数组遍历
for ((i=0; i<${#array[*]}; i++));do
    echo ${array[i]}
done

for i in ${!array[*]}; do
    echo ${array[i]}
done

for temp in ${array[*]}; do
    echo $temp
done
```

### 操作数组
```sh
# 字符串转数组
temp="a bb c"
array=(${temp// / })

# 往数组中添加元素
array+=(test)

# 删除数组的某个元素
unset array[2]

# 数组传递给函数
ff() {
    declare -n array_f="$1"
    echo "${array_f[*]}"
    declare +n array_f   # 取消引用
}
array=(1 er three dddd)
ff array   # 注意此处没有$符号
```

# Map
### 定义map
```sh
array=([one]=1 [six]=liu)
```

```sh
FLAGS=( --foo --bar='baz' )
```

```sh
declare -A array
array[one]=1
array[six]=wu
```

### 访问map
```sh
# 访问单个元素
${array[one]}

# 获取所有key
${!array[*]}
${!array[@]}
```

### 操作map
```sh
array+=(--greeting="Hello ${name}")
```

# if
`if`和`then`在同一行的话, 判断条件后要加一个分号

### 语法
```sh
if condition1; then
    command1
elif condition2; then
    command2
else
    commandN
fi
```

### 例子
```sh
#!/bin/bash
read -p "input number " input
if [ $input -lt 0 ]; then
    echo 'Positive number'
elif [ $input -gt 0 ]; then
    echo 'negative number'
else
    echo 'zero'
fi
```

# for
### 语法
```sh
for var in item1 item2 ... itemN; do
    command1
    command2
    ...
    commandN
done
```
```sh
for (( exp1; exp2; exp3 )); do
    command1
done
```

### 例子
```sh
#!/bin/bash
for TIME in "Morning" "Noon" "Evening"; do
    echo "The $TIME of the day."
done
```
```sh
for (( i=1,num=0;i<=100;i++ ));do
    [ $[i%2] -eq 1 ] && let sum+=i
done
echo sum=$sum
```

# while
### 语法
```sh
while condition; do
    command
done
```

### 例子
```sh
#!/bin/bash
num=1
while [ $num -lt 10 ]; do
    echo $num
    num=`expr $num + 1`
done
```

```sh
#!/bin/bash
# 批量增加20个用户并设置密码
declare –i num=1
while [ $num -le 20 ]; do
    useradd stu$num
    echo "123456" | passwd --stdin stu$num &> /dev/null
    num=`expr $num + 1`
done
```

```sh
while read -r line; do
    echo $line
done < ~/.todo
```

# case
### 语法
```sh
case variable in
    pattern1)
        command1
        command2
        ...
        commandN
        ;;
    pattern2)
        command1
        command2
        ...
        commandN
        ;;
    *)
        command
        ;;
esac
```

### 例子
```sh
#!/bin/bash
read -p "Press a character " KEY
case $KEY in
[a-z]|[A-Z])
    echo "It's a letter."
    ;;
[0-9])
    echo "It's a digit."
    ;;
*)
    echo "It's a symbol."
esac
```

# select
### 用法
* select会显示PS3提示符
* 用户输入被保存在内置变量`REPLY`中
* select是个无限循环, 因此要用`break`命令退出循环

### 语法
```sh
PS3="Please choose the menu: "
select variable in [list]; do
    command
done
```

### 例子
```sh
#!/bin/bash
PS3="Please choose the animal: "
select var in "dog" "cat" "bee"; do
    echo "you like $var"
    break
done
```

# 字符串长度
```sh
$ a=12345
$ echo ${#a}
5
```

# 切割字符串

表达式                  | 说明
----------------------- | ----
${string:offset}        | 初始位置为0, 从offset开始切割, 直至字符串结束
${string:offset:length} | 从offset开始, 长度为length

```sh
$ ilename=/etc/apache2
$ echo ${filename:5} # apache2
$ echo ${filename: -3} # he2   从尾部截取必须加空格
$ echo ${filename:(-3)} # he2   从尾部截取必须加空格
$ echo ${filename:1:3} # etc
```

# 字符串替换

表达式                    | 说明
------------------------- | ----
${string/pattern/string}  | 将`string`中的第一个`pattern`被替换为`string`
${string//pattern/string} | 将`string`中所有的`pattern`被替换为`string`
${string/#pattern/string} | `string`的开头完全匹配`pattern`的话, 将其替换为`string`
${string/%pattern/string} | `string`的结尾完全匹配`pattern`的话, 将其替换为`string`

```sh
$ a='aa1aa2aa3aa4aa'

$ echo ${a/aa/bb}
bb1aa2aa3aa4aa5

$ echo ${a//aa/bb}
bb1bb2bb3bb4bb5

$ echo ${a/%aa/bb}
aa1aa2aa3aa4aa5

$ echo ${a/#aa/bb}
bb1aa2aa3aa4aa5

$ a=aa1aa2aa3aa4aa

$ echo ${a/#aa/bb}
bb1aa2aa3aa4aa

$ echo ${a/%aa/bb}
aa1aa2aa3aa4bb
```

# 切割参数
* `${@:begin}` 从begin开始, 取后面所有的位置参数
* `${@:begin:count}` 从begin开始, 取后面count个的位置参数

```sh
test.sh v1 v2 v3 v4 v5
echo ${@:3}     # v3 v4 v5
echo ${@:3:2}   # v3 v4
```

# 模式匹配

表达式               | 说明
-------------------- | ----
${variable#pattern}  | 从变量头部开始, 删除最短的匹配部分, 并返回其余部分
${variable##pattern} | 从变量头部开始, 删除最长的匹配部分, 并返回其余部分
${variable%pattern}  | 从变量尾部开始, 删除最短的匹配部分, 并返回其余部分
${variable%%pattern} | 从变量尾部开始, 删除最长的匹配部分, 并返回其余部分

```sh
# 确保开启了globbing shopt -s extglob
$ a=00012300
$ echo ${a##+(0)}
12300
```

# 引号
* 使用 **单引号** 时, 将不允许在单引号的范围内引用其他变量的值, $符号或者其他任何符号将作为普通字符看待
* 使用 **双引号** 时, 允许在双引号的范围内使用$符号引用其他变量的值(变量引用)
* 使用 **反撇号** 时, 允许将执行特定命令的输出结果赋值给变量, 反撇号中的内容要求是可执行的命令, 需要嵌套使用时, 可以将反撇号改为`$(...)`的形式

```sh
$ echo "<<< echo \$x >>> displays the value of x, which is $x"
$ echo '<<< echo $x >>> displays the value of x, which is' $x
$ echo '<<< echo $x >>> displays the value of x, which is' "$x"
```

# 整数进制
* 数字以`0`开头的话就是**8进制数**
* 数字以`0x`开头的话那么就是**16进制数**
* 数字中间嵌入了`#`的话, 那么就被认为是**BASE#NUMBER**形式的标记法

```sh
$ a=011
$ echo $(( a + 1 ))
10

$ a=0x11
$ echo $(( a + 1 ))
18

$ a=2#1111
$ echo $(( a + 1 ))
16
```

# 整数运算
`**`表示幂运算, `5**3`等于125

Expression               | Example                              | increase                         | Comment
------------------------ | ------------------------------------ | -------------------------------- | -------
`$((算术式))`            | `r=$((2+5*8))` <br> `$((${j:-8}+2))` | `num=$((num+1))`                 | 最推荐使用, 括号中使用变量无需`$`
`declare -i 变量=算术式` | `declare -i r=8+16`                  | -                                | -
`expr 算术式`            | `r=$(expr 4 + 5)`                    | `num=$(expr $num + 1)`           | 切勿使用, 加号左右必须得有空格
`$[算术式]`              | `r=$[4+5]`                           | -                                | 切勿使用
`let 算术式`             | `let r=8+16`                         | `let num++` <br> `let num=num+1` | 切勿使用

# 特殊变量

变量   | 作用说明
------ | --------
`$0`   | 获取当前Shell脚本的文件名; 如果执行脚本包含了路径, 那么就包括脚本路径
`$n`   | 获取当前Shell脚本的第n个参数值, 从1开始; 如果n大于9, 则用大括号括起来, 例如`${10}`
`$#`   | 获取当前Shell脚本参数的总个数
`$*`   | 和`$@`相同, 将所有参数视为单个字符串, 再按照空格切割字符串, **勿用**
`$@`   | 和`$*`相同, 将所有参数视为单个字符串, 再按照空格切割字符串, **勿用**
`"$*"` | 将所有的参数视为**单个字符串** , 相当于`"$1 $2 $3"`
`"$@"` | 将所有的参数视为**不同的独立字符串**, 相当于`"$1" "$2" "$3" "…"`; 大多数时候**应该使用**这个, 除非知道为什么应该使用其他的
`$?`   | 上一条命令执行后返回的状态, 当返回状态值为0时表示执行正常, 非0值表示执行异常或出错
`$$`   | 当前所在进程的进程号
`$!`   | 后台运行的最后一个进程号
`$-`   | [set](command.md/#set)设置的选项, 一般为`himBHs`

# 变量存在性
带有`:`的表达式在 定义了变量但变量值为null时起作用

表达式        | x不存在               | x存在但为null         | x存在且非null | 意图
------------- | --------------------- | --------------------- | ------------- | ----
${x-value}    | 返回默认值value       | 返回x                 | 返回x         | 测存在性, 不测空值
${x:-value}   | 返回默认值value       | 返回默认值value       | 返回x         | 变量未定义或不存在, 则返回一个默认值
${x=value}    | 将x值置为value并返回  | 返回x                 | 返回x         | 变量未定义或不存在, 则为变量设置默认值
${x:=value}   | 将x值置为value并返回  | 将x值置为value并返回  | 返回x         | 变量未定义或不存在, 则为变量设置默认值
${x+value}    | 返回null              | 返回value             | 返回value     | 修改一个已存在变量的值
${x:+value}   | 返回null              | 返回null              | 返回value     | 修改一个已存在变量的值
${x?message}  | 返回message并退出脚本 | 返回x                 | 返回x         | 捕获未定义变量造成的异常
${x:?message} | 返回message并退出脚本 | 返回message并退出脚本 | 返回x         | 捕获未定义变量造成的异常

# 条件测试
测试特定的表达式是否成立, 当条件成立时, 命令执行后的返回值为0, 否则为其他数值

### 条件测试表达式
表达式 | 是否需要空格 | 逻辑操作符       | 整数比较操作符                                      | 字符串比较操作符 | 是否支持通配符 | 说明
------ | ------------ | ---------------- | --------------------------------------------------- | ---------------- | -------------- | ----
test   | 需要         | `!` `-a` `-o`    | `-eq` `-gt` `-lt` `-ge` `-le`                       | `=` `==` `!=`    | 不支持         | 
[ ]    | 需要         | `!` `-a` `-o`    | `-eq` `-gt` `-lt` `-ge` `-le `                      | `=` `==` `!=`    | 不支持         | 兼容性高
[[ ]]  | 需要         | `!` `&&` `\|\|`  | `-eq` `-gt` `-lt` `-ge` `-le` `=` `>` `<` `>=` `<=` | `=` `==` `!=`    | 支持           | 较新版本才支持
(( ))  | 不需要       | `!` `&&` `\|\|`  | `=` `>` `<` `>=` `<=`                               | `=` `==` `!=`    | 不支持         | 用于整数的比较

```sh
# [[ ]] 可以使用正则表达式
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
  echo "Match"
fi
```

```sh
# 整数比较最好使用 (( ))
# 使用 [[ ]] 来比较的话, 使用 -gt 来比较, 而不是 >
### 因为 [[ ]] 中的 < 执行的是字典比较
# 下面的例子不会有输出
a=33
if [[ $a > 4 ]]; then
    echo 'OK'
fi

# 下面的例子会输出OK
a=33
if [[ $a -gt 4 ]]; then
    echo 'OK'
fi
```

### 整数值比较操作符含义
* -eq: 等于(Equal)
* -ne: 不等于(Not Equal)
* -gt: 大于(Greater Than)
* -lt: 小于(Lesser Than)
* -le: 小于或等于(Lesser or Equal)
* -ge: 大于或等于(Greater or Equal)

### 文件属性检查
* `-b file` 文件是一个块文件
* `-c file` 文件是一个字符文件
* `-d file` 文件是一个目录
* `-h file` 文件是一个符号链接
* `-L file` 文件是一个符号链接
* `-p file` 文件是一个命名管道

<br>

* `-r file` 对file有读权限
* `-w file` 对file有写权限
* `-x file` 对file有可执行权限

<br>

* `-f file` file存在并且为正规文件(即不是一个目录或其他特殊类型文件)
* `-e file` file存在(空文本文件和空文件夹都算存在)
* `-a file` file存在(空文本文件和空文件夹都算存在), 已弃用
* `-s file` 文件存在且非空(空文件夹都算存在, 空文件不算返回false)

<br>

* `-O file` 你是file的所有者
* `-G file` 文件存在且属于有效组ID (如果你在多个组中, 则匹配其中一个)
* `file1 -nt file2` file1比file2新(文件修改时间)
* `file1 -ot file2` file1比file2旧(文件修改时间)
* `file1 -ef file2` file1和file2inode相同

### 字符串检查
* `-z string` (Zero)字符串长度为0
* `-n string` (Not zero)字符串长度不为0
