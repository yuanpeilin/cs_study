# 目录
* [add](#add)
* [blame](#blame)
* [branch](#branch)
* [checkout](#checkout)
* [cherry-pick](#cherry-pick)
* [commit](#commit)
* [config](#config)
* [diff](#diff)
* [grep](#grep)
* [log](#log)
* [merge](#merge)
* [plumbing](#plumbing)
    - [cat-file](#cat-file)
    - [ls-files](#ls-files)
    - [others](#others)
* [push](#push)
* [rebase](#rebase)
* [reflog](#reflog)
* [remote](#remote)
* [reset](#reset)
* [revert](#revert)
* [show](#show)
* [stash](#stash)
* [status](#status)
* [tag](#tag)
* [worktree](#worktree)
* [others](#others-1)
    - [使用不同的配置文件](#使用不同的配置文件)
    - [.git目录结构](#git目录结构)



*********************************************************************************
*********************************************************************************



# add
* **`git add --renormalize <file_path>`** 设置autocrlf之后更新换行符
* **`git add -u <file_path>`** 只添加已追踪文件, 不添加新增文件
* **`git add --patch`** 按照补丁来添加修改

# blame
* **`git blame [--] <file path>`** 查看文件每一行修改的时间与作者
* **`git blame -L <n,m> [--] <file path>`** 查看文件n到m行修改的时间与作者

# branch
* **`git branch`** 查看所有分支
* **`git branch <branch_name> [commit_id]`** 新建一个分支并使分支指向对应的提交对象, 默认为当前分支
* **`git branch --contains --all <commit_id>`** 查看某个commit属于哪个分支
* **`git branch -d <branch_name>`** 删除一个已合并的分支
* **`git branch -D <branch_name>`** 强制删除一个未合并的分支
* **`git branch [--merged | --no-nerged]`** 查看已/未合并的分支
* **`git branch -r`** 查看远程分支
* **`git branch --set-upstream-to=origin/<remote_branch> <local_branch>`** 将本地已有分支和远程已有分支关联起来(设置上游分支)
* **`git branch -vv`** 查看分支详细信息

# checkout
* **`git checkout <branch_name | tag_name>`** 切换分支
* **`git checkout <remote_branch_name>`** 本地不存在对应的分支, 新建一个跟踪远程的分支并切换
* **`git checkout <file path>`** 将工作区和暂存区的file换成暂存区的file(**动工作区和暂存区(实际只动工作区)**)
    * 修改一个文件, 状态为` M`, 执行命令后修改会被撤销
    * 修改一个文件添加进暂存区, 再次修改此文件, 状态为`MM`, 执行命令后修改被撤销而暂存区不变
* **`git checkout <commit_id> -- <file path>`** 将暂存区和工作区换成commit_id指向的file(**动工作区和暂存区**)
* **`git checkout -b <branch_name>`** 创建并切换到创建的分支
* **`git checkout -b <local_branch_name> origin/<remote_branch_name>`** 本地新建一个跟踪远程的分支
* **`git checkout --conflict=diff3 <file path>`** 带有base版本的差异比较

# cherry-pick
* **`git cherry-pick <commit_id>`** 取出某一个提交应用到当前分支

# commit
* **`git commit --amend [--no-edit]`** 修改提交信息或暂存区

# config
* **`git config [--system | --global] --list [--show-origin]`** 查看配置与范围. 小范围会覆盖大范围的配置, .git/config的配置变量会覆盖/etc/gitconfig中的配置变量
    * `不加参数`对应的配置文件位于.git/config, 仅对当前仓库生效
    * `--global`选项对应的配置文件位于\~/.gitconfig, 对当前用户的的所有仓库生效
    * `--system`选项对应的配置文件位于/etc/gitconfig, 每一个用户都会生效
* push.default 2.0版本之前为matching, 2.0版本之后为simple
    * **nothing:** push操作无效, 除非显式指定远程分支, 例如`git push origin develop`
    * **current:** push当前分支到远程同名分支, 如果远程同名分支不存在则自动创建同名分支
    * **upstream:** push当前分支到它的upstream分支上(这种模式叫做central workflow)
    * **simple:** simple和upstream是相似的, 只有一点不同, simple必须保证本地分支和它的远程upstream分支同名, 否则会拒绝push操作
    * **matching:** push所有本地和远程两端都存在的同名分支

```sh
# 配置别名
git config --global alias.br      branch
git config --global alias.cat     cat-file
git config --global alias.cm      commit
git config --global alias.co      checkout
git config --global alias.cp      cherry-pick
git config --global alias.di      diff
git config --global alias.dc      'diff --cached'
git config --global alias.dn      'diff --name-status'
git config --global alias.ds      'diff --stat'
git config --global alias.ft      fetch
git config --global alias.last    'show --stat HEAD'
git config --global alias.lo      "log --format='%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>' --graph"
git config --global alias.loa     "log --format='%C(yellow)%h%Creset %C(auto)%d%Creset %s %C(blue)(%cr) <%an>' --graph --all"
git config --global alias.ls      ls-files
git config --global alias.rb      rebase
git config --global alias.re      remote
git config --global alias.rf      reflog
git config --global alias.rs      reset
git config --global alias.rv      revert
git config --global alias.sa      stash
git config --global alias.st      status
git config --global alias.wt      worktree
# 设置换行符
git config --global core.autocrlf input
git config --global merge.renormalize true
# 设置ss代理
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'
# 在浏览器打开帮助手册 (此外还要 sudo apt install git-doc)
git config --global help.browser google-chrome
git config --global help.format web
git config --global web.browser open
# 其他
git config --global core.editor vim
git config --global core.excludesfile '~/.gitignore'
git config --global pull.rebase true
```

# diff
* **`git diff [--name-only | --name-status] [commit_id...] [--] [file_name]`** 
* **`git diff`** 查看工作区和暂存区的差异(未暂存的修改)
* **`git diff HEAD`** 查看工作区和版本库差异
* **`git diff <--cached | --staged>`** 查看暂存区和版本库的差异(已暂存的修改)
* **`git diff --name-status <commit_id1> <commit_id2>`** 获取两次commit修改的文件
* **`git diff <--ours | --theirs | --base>`** 合并时比较
* **`git diff --check`** 找到可能的空白错误

# grep
* **`git grep <-c | --count> <sting>`** 只显示匹配的个数
* **`git grep <-n | --line-number> <string>`** 查找工作区的字符串, 显示 详细内容与行号

# log
* **`git log`** 查看提交历史
* **`git log -1`** 限制输出长度
* **`git log --author=<string>`** 查看指定作者的提交历史
* **`git log --committer=<string>`** 查看指定提交者的提交历史
* **`git log --format='%c(yellow)%h%creset %c(auto)%d%creset %s %c(green)(%cr) %c(blue)<%an> <file_path>'`** 查看某个文件的修改历史
* **`git log --grep=<string>`** 查看提交说明中包含指定字符的提交历史
* **`git log [-p | --patch]`** 以patch的形式查看日志(类似diff, 改动了哪些地方)
* **`git log --stat`** 查看每一个日志的统计信息(增加多少行, 删除多少行)
* **`git log --pretty=[oneline | short | full | medium | fuller | raw]`** 格式化日志, oneline最简略, fuller最详细, 默认为full
* **`git log [--since | --after | --until | --before]=<time>`** 通过时间过滤. time可以是2008-01-15或是2 years 1 day 3 minutes ago
    * since/after 指定时间开始, 一直输出到最近的一次提交
    * 从最开始的提交开始, until/before 指定时间
* **`git log -S <string>`** 查看文件内容中某个字符串的历史(俗称鹤嘴锄pickaxe)
* **`git log --oneline --all --graph`** 查看分支图
* **`git log --oneline --graph <branch1>..<branch2>`** 两点: 属于branch2但不属于branch1的提交
* **`git log --left-right <branch1>...<branch2>`** 三点: 不同时属于branch1和branch2提交
* **`git log --pretty=format:"%h - %an, %ar : %s"`** 格式化
* **`git log --format="%h - %an, %ar : %s"`** 格式化

选项 | 说明
---- | ---
%d   | HEAD指针, 分支等相关信息
%h   | 提交的完整哈希值
%h   | 提交的简写哈希值
%t   | 树的完整哈希值
%t   | 树的简写哈希值
%p   | 父提交的完整哈希值
%p   | 父提交的简写哈希值
%an  | 作者名字
%ae  | 作者的电子邮件地址
%ad  | 作者修订日期(可以用--date=选项 来定制格式)
%ar  | 作者修订日期, 按多久以前的方式显示
%cn  | 提交者的名字
%ce  | 提交者的电子邮件地址
%cd  | 提交日期
%cr  | 提交日期(距今多长时间)
%s   | 提交说明

# merge
* **`git merge <branch_name>`** 合并某分支到当前分支
* **`git merge --no-ff [-m message] <branch_name>`** --no-ff参数, 表示禁用 **fast forward** 模式
* **`git merge --squash <branch_name>`** 将某分支上所有的提交合并成一个, 应用到当前分支(只是到暂存区, 且不移动HEAD)

# plumbing
### cat-file
* **`git cat-file -p [commit_hash]`** 查对象的**内容**
* **`git cat-file -t [commit_hash]`** 查对象的**类型**

### ls-files
* **`git ls-files -c`** 查看暂存区(只输出文件名)
* **`git ls-files -s`** 查看暂存区(包括文件名和SHA1值)
* **`git ls-files --eol`** 查看文件的换行符
* **`git ls-files --ignore --others --exclude-standard`** 查看被排除追踪的文件
* **`git ls-files -u`** 查看(合并冲突时)未暂存的文件

### others
* **`git hash-object -w file_url`** 生成一个key:value(hashcode:压缩后的文件)存储到.git/object
* **`git update-index --add --cacheinfo 100644 hash test.txt`** 往暂存区添加一条记录
* **`git write-tree`** 生成一个tree对象存储到.git/object
* **`echo '' | git commit-tree treehash`** 生成一个commit对象
* **`git merge-file -p <file_path1..3>`** 手动合并单个文件

# push
* **`git push origin <tag_name>`** 推送标签到远程
* **`git push origin --tags`** 推送所有标签到远程
* **`git push origin :refs/tags/<tag_name>`** 删除远程标签
* **`git push origin <local_branch_name>:<remote_branch_name>`** 推送本地分支到指定的远程分支
* **`git push origin --delete <remote_branch_name>`** 删除远程分支
* **`git push origin --delete <tag_name>`** 删除远程标签(删除本地标签后, 远程标签不会删除, 必须手动删除远程标签)
* **`git push origin :<remote_branch_name>`** 删除远程分支(推送空分支到远程)
* **`git push origin :refs/tags/<tag_name>`** 删除远程标签

# rebase
* **`git rebase master`** 将当前分支(主题分支)的修改变基到 **master** 分支(目标分支)上
* **`git rebase master HEAD`** 将当前分支(主题分支)的修改变基到 **master** 分支(目标分支)上
* **`git rebase <base_branch> <topic_branc>`** 将主题分支变基到目标分支上(不指定topic_branc则默认为当前分支)
* **`git rebase --onto <base_branch> <topic_branc>`** 合并到目标分支时不会生产新的提交(类似amend)
* **`git rebase --onto master server client`** 找出client分支从server分支分歧之后的补丁, 然后把这些补丁在master分支上应用, 让client看起来像直接基于master修改一样
* **`git rebase -i HEAD~3`** 修改最近三次修改(注意HEAD\~3包含了四次提交)(实际上是当前分支变基到HEAD\~3分支上)

# reflog
* **`git reflog`** 查看所有历史日志

# remote
* **`git remote add <repository_name> <ssh | https>`** 使本地仓库与远程仓库关联
* **`git remote`** 查看所有远程仓库
* **`git remote -v`** 查看远程仓库信息
* **`git remote show origin`** 查看某个远程仓库详细信息, 需要网络(Fetch URL, Push URL, 远程分支)
* **`git remote rename <old name> <new name>`** 重命名仓库
* **`git remote prune origin --dry-rnu`** 列出仍在跟踪但远程已删除的分支
* **`git remote set-url origin <url>`** 设置远程仓库地址

# reset
* **`git reset [--hard | --mixed | --soft] HEAD^`** 回退到上一个版本
* **`git reset [--hard | --mixed | --soft] <commit_id>`** 回退到指定版本
    * `--soft` 不修改working directory和index, 只修改**HEAD**的内容. 本质上是撤销了某一次的commit命令
    * `--mixed` 不修改working directory, 只修改**index**和**HEAD**的内容
    * `--hard` 修改**working directory**和**index**和**HEAD**的内容
* **`git reset HEAD -- <file>`** 将暂存区的file替换成HEAD指向的file, 可以把提交到暂存区的修改unstaged(**只动暂存区**)

# revert
* **`git revert HEAD`** 撤销HEAD的修改
* **`git revert HEAD~`** 撤销HEAD~的修改(不会撤销HEAD的修改, 只撤销一个commit的修改)
* **`git revert <commit_id>`** 
* **`git revert -m 1 <commit_id>`** 对于 **两个分支合并而来的提交** , 指定第一个分支为主线分支, 撤销第二个分支的修改
* **`git revert --no-commit`** 不自动生成反向修改的提交, 只改动暂存区
* **`git revert <commit_id1>..<commit_id2>`** 撤销一系列提交, 左开右闭, 不包括1包括2

# show
* **`git show <tag_name>`** 查看标签具体信息
* **`git show --no-patch <reversion id>`** 查看某个版本信息
* **`git show <reversion id>:<file apth>`** 查看某个版本中的某个文件
* **`git show :<number>:<file_name>`** 查看合并冲突时index中的文件, number取值为1-3, 1表示共同祖先, 2是当前分支的版本, 3是他们的版本

# stash
* **`git stach`** 
* **`git stash [-u | --include-untracked]`** stash未追踪的文件
* **`git stash push [-m 'message'] [-- file_path]`** stash指定文件
* **`git stash list`** 查看所有的贮藏
* **`git satsh show [stash]`** 查看某个stash
* **`git stash apply [--index] [stash]`** 应用某个stash(不删除)
* **`git stash pop [--index] [stash]`** 应用并删除某个stash
* **`git stash drop [stash]`** 删除stash
* **`git stash clear`** 删除所有stash

# status
* **`git status [ -s | --short]`** 简单展示状态: 左栏为暂存区的状态, 右栏为工作区的状态

# tag
* **`git tag`** 查看所有标签(可以不带-l)
* **`git tag <-l | --list> v1.8.5*`** 按照特定模式查找标签
* **`git tag <tag_name> [commit_id]`** 新建一个lightweight标签, 本质是一个指向commit对象的指针, 使用`git cat-file -t`查看为commit
* **`git tag -a <tag_name> -m <tag_description> [commit_id]`** 新建一个annotated标签, 是一个tag对象
* **`git tag -d <tag_name>`** 删除本地标签

# worktree
* **`git worktree add <path> [commit-id]`** 新建一个worktree
* **`git worktree list`** 列出所有的worktree
* **`git worktree move <path> <new-path>`** 移动worktree
* **`git worktree remove <path>`** 移除某个worktree

# others
* **`git difftool --tool-help`** 系统支持哪些Git Diff插件
* **`git gc --prune=now --aggressive`** 清理仓库中的孤儿对象
* **`git rev-list --count <branch name>`** 计算指定分支的提交数量
* **`git clone --bare <url>`** 克隆一个bare仓库
* **`git clone -o <name> <url>`** 指定远程仓库名(取代origin)
* **`git ls-remote <remote-repo>`** 查看某个远程仓库详细信息(需要网络)
* **`git ls-remote origin`** 列出远程仓库信息(分支, tag, PR及其的hash值)
* **`git format-patch -M origin/master`** 形成补丁文件(当前分支相对于origin/master的差异)
* **`git apply /tmp/patch-ruby-client.patch`** 应用一个补丁(兼容diff生成的补丁)
* **`git apply --check 0001-seeing-if-this-helps-the-gem.patch`** 检查补丁是否可用
* **`git am 0001-limit-log-function.patch`** Apply Mailbox, 应用一个补丁(format-patch生产的补丁)
* **`git am -3 0001-seeing-if-this-helps-the-gem.patch`** 使用三方合并应用补丁

### 使用不同的配置文件
* **`gitdir`** 匹配目录, 注意是 **git** 不是get
* **`gitdir/i`** 忽略大小写
* **`onbranch`** 根据分支匹配

```
[includeIf "gitdir/i:~/Desktop/"]
    path = ~/.gitconfig2
```

### .git目录结构
```
.git
├── commit_editmsg   最后一次提交的注释
├── config   git有关配置
├── fetch_head   每个分支最后一次和服务器通信的sha1值
├── head   `ref: refs/heads/dev` 当前工作区所在分支
├── index   二进制文件, 暂存区, 使用 git ls-files -s 查看
├── orig_head
├── packed-refs
├── hooks   钩子
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   └── ......
├── info
│   └── exclude
├── logs 提交日志
│   ├── head
│   └── refs
│       ├── heads
│       └── remotes
├── objects   存储对象
│   ├── d0
│   │   ├── 17c08b44aa8abf163e98693d57536a9cfc863f   二进制文件
│   │   └── b81b4bf9f7134ed9d898af1fbadb6de51fa492
│   ├── d1
│   │   └── f941b9270a3aac4d9832bb0b597deaaf6036e9
│   ├── ......
│   ├── info
│   └── pack
│       ├── pack-9ac9585083426804d36449397d78a3ae6d5ddff8.idx
│       └── pack-9ac9585083426804d36449397d78a3ae6d5ddff8.pack
└── refs   文件内容都是sha1值
    ├── heads
    │   ├── dev
    │   └── master
    ├── remotes
    │   └── origin
    └── tags
```
