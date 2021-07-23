* [空值约束](#空值约束)
* [主键约束](#主键约束)
* [唯一约束](#唯一约束)
* [外键约束](#外键约束)
* [检查约束](#检查约束)
* [默认约束](#默认约束)



*******************************************************************************
*******************************************************************************



# 约束
**约束(Constraint)** 是保持数据完整性的一种方法, 有以下几种约束
* [空值约束(Null Constraint)](#空值约束)
* [主键约束(Primary Key Constraint)](#主键约束) 唯一且非null
* [唯一约束(Unique Key)](#唯一约束) 可以为null, 但只能有一个null
* [外键约束(Foreign Key Constraint)](#外键约束) 保证数据一致性和完整性, 实现一对一或一对多的关系
* [检查约束(Check Constraint)](#检查约束)
* [默认约束(Default Constraint)](#默认约束)

# 空值约束
```sql
-- 创建空值约束
column_name column_definition NOT NULL,

column_name column_definition NULL,
```

# 主键约束
* 要求唯一且非null
* 每个表只能有一个主键
* 主键约束拥有自动定义的唯一约束
* AUTO_INCREMENT必须和主键一起使用

```sql
-- 创建主键约束
`username` VARCHAR(45),
PRIMARY KEY (`username`)

`username` VARCHAR(45) PRIMARY KEY,

----- 组合主键
order_num  int          NOT NULL ,
order_item int          NOT NULL ,
PRIMARY KEY (order_num, order_item)
```

```sql
-- 增加主键约束
ALTER TABLE table_name ADD [CONSTRAINT] [constraint_name] PRIMARY KEY [index_type] (index_column_name,..)

ALTER TABLE table_name ADD PRIMARY KEY (column_name),

ALTER TABLE user ADD CONSTRAINT pk_user_id PRIMARY KEY (id);
```

```sql
-- 删除主键约束
ALTER TABLE table_name DROP PRIMARY KEY

ALTER TABLE table_name DROP CONSTRAINT primary_key_name
```

# 唯一约束
* 唯一约束允许有空值, 但是只能有一个空值
* 主键约束拥有自动定义的唯一约束
* 一张表允许有多个唯一约束, 只能有一个主键约束

```sql
-- 创建唯一约束
`username` VARCHAR(45) UNIQUE,

`username` VARCHAR(45),
UNIQUE (username),

`username` VARCHAR(45),
CONSTRAINT constraint_name UNIQUE (username),

`username` VARCHAR(45),
UNIQUE constraint_name (username);
```

```sql
-- 增加唯一约束
ALTER TABLE table_name ADD UNIQUE (column_name)

ALTER TABLE table_name ADD [CONSTRAINT [symbol]] UNIQUE [INDEX | KEY] [index_name] [index_type] (index_column_name,..)

ALTER TABLE user ADD CONSTRAINT UNIQUE (username);

ALTER TABLE user ADD UNIQUE (username);
```

```sql  
-- 删除唯一约束
ALTER TABLE table_name DROP {INDEX | KEY} index_name
```

# 外键约束
保证数据的一致性和完整性

### 要求
* 父表和子表必须使用相同的存储引擎, 并且禁止使用临时表
* 数据库的存储引擎只能为InnoDB
* 外键列和参照列必须具有 **相似的数据类型**. 其中数字的长度和是否有符号位必须相同, 而字符的长度则可以不同
* 外键列和参照列 **必须创建索引**. 如果外键列/参照列不存在索引的话MySQL将会自动创建索引

### 父表和子表
有**外键列**(有FOREIGN KEY关键词的一列)的表为**子表**

```sql
CREATE TABLE user (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(10) NOT NULL,
    pid SMALLINT UNSIGNED,
    FOREIGN KEY (pid) REFERENCES province (id)
);
```

子表所参照的表为**父表**. 外键列所参照的一列为**参照列**

```sql
CREATE TABLE province (
    id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    pname VARCHAR(20) NOT NULL
);
```

### 参照条件
* **`CASCADE`** 从父表删除或更新且自动删除或更新子表中匹配的行
* **`SET NULL`** 从父表中删除或更新行, 并设置子表的中的外键列为NULL. 如果使用该选项, 必须保证子表列没有指定NOT NULL
* **`RESTRICT`** 拒绝对父表的更新或删除操作
* **`NO ACTION`** 标准的SQL关键字, 在MySQL中与RESTRICT相同

```sql
-- 创建外键约束
column_name INT FOREIGN KEY REFERENCES 主表名（主键列名）

column_name INT,
FOREIGN KEY (column_name) REFERENCES 主表名（主键列名）

pid SMALLINT UNSIGNED,
FOREIGN KEY (pid) REFERENCES province (id) ON DELETE CASCADE ON UPDATE CASCADE
```

```sql
-- 增加外键约束
ALTER TABLE table_name ADD FOREIGN KEY (列名) REFERENCES 主表名（主键列名）

ALTER TABLE table_name ADD [CONSTRAINT [symbol]] FOREIGN KEY [index_name] (index_column_name,..) reference_ definition

ALTER TABLE user ADD FOREIGN KEY (pid) REFERENCES province (id);
```

```sql
-- 删除外键约束
ALTER TABLE table_name DROP FOREIGN KEY foreign_key_name
```

# 检查约束
用于限制字段值的范围  

```sql
-- 创建检查约束
id INT CHECK (id>0),
sex varchar(2) CHECK (sex='男' or sex='女'),

id INT,
check (id>0),
```

```sql
-- 增加检查约束
ALTER TABLE table_name ADD CHECK (condition)
```

```sql
-- 删除检查约束
ALTER TABLE table_name DROP CONSTRAINT check_constraint_name
```

# 默认约束
```sql
-- 创建默认约束
`username` VARCHAR(45) DEFAULT 'xiaoming',
`systemtime` DATE DEFAULT gatedate(),
```

```sql
-- 增加默认约束
ALTER TABLE table_name ALTER [COLUMN] column_name SET DEFAULT value;

ALTER TABLE user ALTER id SET DEFAULT 10;
```

```sql
-- 删除默认约束
ALTER TABLE table_name ALTER [COLUMN] column_name DROP DEFAULT;

ALTER TABLE user ALTER id DROP DEFAULT;
```
