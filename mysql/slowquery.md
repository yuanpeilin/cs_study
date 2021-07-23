- [慢查询参数](#慢查询参数)
- [慢查询设置](#慢查询设置)
- [mysqldumpslow](#mysqldumpslow)
- [优化方式](#优化方式)



*******************************************************************************
*******************************************************************************



# 慢查询参数

参数                              | 说明
--------------------------------  | :--
`slow_query_log`                  | 慢查询日志开启状态
`slow_query_log_file`             | 指定慢查询日志存储路径(需要MySQL用户有w权限)
`long_query_time`                 | 指定慢查询执行时间, 默认10s
`log_queries_not_using_indexes`   | 记录未使用索引的SQL
`log_output [[table] [,] [file]]` | 日志存放的地方

# 慢查询设置
* 查看慢查询参数
```sql
show variables like 'slow_query%';
+---------------------+-------------------------------+
| Variable_name       | Value                         |
+---------------------+-------------------------------+
| slow_query_log      | OFF                           |
| slow_query_log_file | /var/lib/mysql/GL62M-slow.log |
+---------------------+-------------------------------+

show variables like 'long_query_time';
+-----------------+-----------+
| Variable_name   | Value     |
+-----------------+-----------+
| long_query_time | 10.000000 |
+-----------------+-----------+
```

* 通过 **命令行** 设置慢查询参数(修改后记得重启)
```sql
set global slow_query_log='ON'; 

set global slow_query_log_file='/var/lib/mysql/slow_query.log';

set global long_query_time=1;
```

* 通过 **修改配置文件** 设置慢查询参数
```
修改/etc/mysql/mysql.conf.d/mysqld.cnf
在[mysqld]下的下方加入

[mysqld]
slow_query_log = ON
slow_query_log_file = /usr/local/mysql/data/slow.log
long_query_time = 1
```

# mysqldumpslow
一个处理慢查询日志的工具

### 参数
* **`-s [al | ar | at | c | l | r | t]`** 
    * **`al`** 平均锁时间
    * **`ar`** 平均行数
    * **`at`** 平均总时间(默认)
    * **`c`** 总次数
    * **`l`** 锁时间
    * **`r`** 总数据行
    * **`t`** 查询总时间
* **`-t NUM`** 指定前面几条作为结果输出
* **`-g`** grep, 后接一个正则

### 例子
```sql
-- 最慢的三条记录
mysqldumpslow -s t -t 3 /usr/local/mysql/data/slow.log

-- 最慢且有左连接的三条记录
mysqldumpslow -s t -t 3 -g “left join” /database/mysql/mysql06_slow.log
```

# 优化方式
* **服务器硬件:** 换固态......
* **SQL语句优化**
* **反范式设计优化:** 适当违反对数据库范式设计的要求(空间换时间)
* **索引优化**
