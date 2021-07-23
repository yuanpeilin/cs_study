- [游标](#游标)
- [创建游标](#创建游标)
- [打开和关闭游标](#打开和关闭游标)
- [使用游标数据](#使用游标数据)



*******************************************************************************
*******************************************************************************



# 游标
MySQL检索操作返回的行都是与SQL语句相匹配的行, 没有办法得到第一行、下一行或前10行. 游标(cursor)可以在检索出来的行中前进或后退一行或多行, 游标只能用于存储过程和函数

# 创建游标
使用 **`DECLARE`** 关键字定义游标

```sql
DELIMITER //
CREATE PROCEDURE processorders()
BEGIN
	DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;
END //
DELIMITER ;
```

# 打开和关闭游标
```sql
OPEN ordernumbers;

CLOSE ordernumbers;
```

# 使用游标数据
* 在一个游标被打开后, 可以使用FETCH语句分别访问它的每一行, FETCH指定检索什么数据(所需的列), 检索出来的数据存储在什么地方
* 它还向前移动游标中的内部行指针, 使下一条FETCH语句检索下一行

```sql
DELIMITER //
CREATE PROCEDURE processorders()
BEGIN
    DECLARE o INT;
	DECLARE ordernumbers CURSOR
    FOR
    SELECT order_num FROM orders;

    OPEN ordernumbers;
    FETCH ordernumbers INTO o;
    CLOSE ordernumbers;
END //
DELIMITER ;
```
