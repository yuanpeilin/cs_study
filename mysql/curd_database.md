- [新建数据库](#新建数据库)
- [删除数据库](#删除数据库)
- [查看所有数据库](#查看所有数据库)
- [查看数据库结构](#查看数据库结构)
- [修改数据库字符集](#修改数据库字符集)
- [使用数据库](#使用数据库)



*******************************************************************************
*******************************************************************************



# 新建数据库
```sql
CREATE DATABASE [IF NOT EXISTS] <DATABASE_NAME> [ [DEFAULT] CHARACTER SET [=] <CHARACTER_SET_NAME> ];
```

```sql
CREATE DATABASE test CHARACTER SET utf8;
CREATE DATABASE test CHARACTER SET = utf8;
CREATE DATABASE test DEFAULT CHARACTER SET utf8;
```

# 删除数据库
```sql
DROP DATABASE [IF EXISTS] <DATABASE_NAME>;
```

# 查看所有数据库
```sql
SHOW DATABASES;
```

# 查看数据库结构
```sql
SHOW CREATE DATABASE <DATABASE_NAME>;
```

# 修改数据库字符集
```sql
ALTER DATABASE <DATABASE_NAME> CHARACTER SET <CHARACTER_SET_NAME>;
```

# 使用数据库
```sql
USE <DATABASE_NAME>;
```