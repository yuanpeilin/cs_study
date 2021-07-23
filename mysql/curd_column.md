- [添加列](#添加列)
- [删除列](#删除列)
- [查看列](#查看列)
- [修改列定义](#修改列定义)



*******************************************************************************
*******************************************************************************



# 添加列
```sql
ALTER TABLE <TABLE_NAME> 
ADD [COLUMN] COLUMN_NAME COLUMN_DEFINITION 
[FIRST | AFTER COLUMN_NAME]
```

```sql
ALTER TABLE student
ADD age TINYINT NOT NULL
AFTER name;
```

# 删除列
```sql
ALTER TABLE <TABLE_NAME> 
DROP [COLUMN] COLUMN_NAME
```

# 查看列
```sql
SHOW COLUMNS FROM <TABLE_NAME>;

DESCRIBE <TABLE_NAME>;
```

# 修改列定义
```sql
ALTER TABLE <TABLE_NAME> 
MODIFY [COLUMN] COLUMN_NAME COLUMN_DEFINITION 
[FIRST丨AFTER COLUMN_NAME]

ALTER TABLE <TABLE_NAME> 
CHANGE [COLUMN] old_COLUMN_NAME new_COLUMN_NAME COLUMN_DEFINITION 
[FIRST | AFTER COLUMN_NAME]
```

```sql
ALTER TABLE qq
MODIFY username VARCHAR(45)
FIRST;

ALTER TABLE qq
CHANGE username username VARCHAR(45)
AFTER id;
```
