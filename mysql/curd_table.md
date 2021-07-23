- [创建表](#创建表)
- [删除表](#删除表)
- [查看表的结构](#查看表的结构)
- [显示所有的表](#显示所有的表)
- [修改表名](#修改表名)



*******************************************************************************
*******************************************************************************



# 创建表
### 例子
```sql
CREATE TABLE IF NOT EXISTS customers
(
    cust_id      int       NOT NULL AUTO_INCREMENT,
    cust_name    char(50)  NOT NULL ,
    PRIMARY KEY (cust_id)
) ENGINE=InnoDB;
```

```sql
CREATE TABLE IF NOT EXISTS customers
(
    cust_id      int unsigned          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cust_sex     ENUM('male','female') NOT NULL ,
    cust_email   char(255)             NULL ,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

# 删除表
```sql
DROP TABLE [IF EXISTS] <TABLE_NAME>;
```

# 查看表的结构
```sql
SHOW CREATE TABLE <TABLE_NAME>;

DESCRIBE <TABLE_NAME>;
```

```sql
SHOW CREATE TABLE customers;

CREATE TABLE `customers` (
    `cust_id` int(11) NOT NULL AUTO_INCREMENT,
    `cust_contact` char(50) DEFAULT NULL,
    `cust_email` char(255) DEFAULT NULL,
    PRIMARY KEY (`cust_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10006 DEFAULT CHARSET=latin1
```

# 显示所有的表
```sql
SHOW TABLES;
```

# 修改表名
```sql
ALTER TABLE <TABLE_NAME> RENAME [TO | AS] <NEW_TABLE_NAME>

RENAME TABLE <TABLE_NAME> TO <NEW_TABLE_NAME>
```
