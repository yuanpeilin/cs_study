# 目录
- [事务](#事务)
- [隔离级别](#隔离级别)
    - [未提交读(read uncommitted)](#未提交读read-uncommitted)
    - [已提交读(read committed)](#已提交读read-committed)
    - [可重复读(repeatable read)](#可重复读repeatable-read)
    - [可串行化(serializable)](#可串行化serializable)
- [ROLLBACK](#rollback)
- [COMMIT](#commit)
- [保留点](#保留点)



*******************************************************************************
*******************************************************************************



# 事务
事务处理(transaction processing)可以用来维护数据库的完整性, 它保证成批的MySQL操作要么完全执行, 要么完全不执行

# 隔离级别
![](src/isolation.png)
  
### 未提交读(read uncommitted)
A修改了数据之后, 即使未提交, B读取到的数据都是修改的数据. 如果A撤销操作, B读到的就是错误的数据, B读到A未提交的数据, 产生了**脏读**

```sql
SET SESSION TRANSACTION ISOLATION LEVEL read committed;
start transaction;
.....
commit;
```

### 已提交读(read committed)
* 解决**脏读**
* A修改数据但未提交, B只能读取提交的数据, 读不到已修改的数据
* B读到了A提交前和提交后的数据, 不一致. 产生了**不可重复读**

### 可重复读(repeatable read)
* 解决**不可重复读**
* 每次读取的结果都相同, 不管其他事物是否已提交

### 可串行化(serializable)
* 只能有一个人操作, 其他操作将被挂起

# ROLLBACK
ROLLBACK语句回退到START TRANSACTION之后的所有语句

```sql
SELECT * FROM ordertotals;
START TRANSACTION;
DELETE FROM ordertotals;
SELECT * FROM ordertotals;
ROLLBACK;
```

# COMMIT
如果第一条DELETE起作用, 但第二条失败, 则所有DELETE不会提交

```sql
START TRANSACTION;
DELETE FROM orderitems WHERE order_num = 20010;
DELETE FROM orders WHERE order_num = 20010;
COMMIT;
```

# 保留点
* 为了支持回退部分事务处理, 必须能在事务处理块中合适的位置放置占位符. 这样, 如果需要回退, 可以回退到某个占位符, 这些占位符称为 **保留点**
* 保留点在事务处理完成(执行一条ROLLBACK或COMMIT)后自动释放

```sql
-- 创建占位符使用SAVEPOINT语句
SAVEPOINT delete1;
  
-- 回退到指定的保留点
ROLLBACK TO delete1;
```
