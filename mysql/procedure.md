# 目录
- [创建存储过程](#创建存储过程)
- [调用存储过程](#调用存储过程)
- [删除存储过程](#删除存储过程)
- [查看存储过程](#查看存储过程)
- [使用参数](#使用参数)
    - [OUT](#out)
    - [IN和OUT](#in和out)



*******************************************************************************
*******************************************************************************



# 创建存储过程
* 用`CREATE PROCEDURE productpricing()`语句定义存储过程
* 如果存储过程接受参数, 它们将在()中列举出来. 此存储过程没有参数, 但后跟的()仍然需要
* BEGIN和END语句用来限定**存储过程体**, 过程体本身仅是一个简单的SELECT语句

```sql
CREATE PROCEDURE productpricing()
BEGIN
    SELECT AVG(prod_price) AS priceaverage
    FROM products;
END;
```

```sql
DELIMITER //
CREATE PROCEDURE productpricing()
BEGIN
    SELECT AVG(prod_price) AS priceaverage
    FROM products;
END //
DELIMITER ;
```

# 调用存储过程
```sql
CALL productpricing();
+--------------+
| priceaverage |
+--------------+
|    16.133571 |
+--------------+
```

# 删除存储过程
```sql
DROP PROCEDURE IF EXISTS productpricing;
```

# 查看存储过程
```sql
SHOW CREATE PROCEDURE ordertotal;
```

# 使用参数
### OUT
* 此存储过程接受3个参数：pl存储产品最低价格，ph存储产品最高价格，pa存储产品平均价格
* 每个参数必须具有指定的类型，这里使用十进制小数
* 关键字 **OUT** 指出相应的参数用来从存储过程传出一个值返回给调用者
* 存储过程的代码位于BEGIN和END语句内, 通过指定INTO关键字保存到相应的变量

```sql
DELIMITER //
CREATE PROCEDURE productpricing(
    OUT pl DECIMAL(8,2),
    OUT ph DECIMAL(8,2),
    OUT pa DECIMAL(8,2)
)
BEGIN
    SELECT MIN(prod_price)
    INTO pl
    FROM products;
    SELECT MAX(prod_price)
    INTO ph
    FROM products;
    SELECT AVG(prod_price)
    INTO pa
    FROM products;
END //
DELIMITER ;

-- 为调用此存储过程, 必须指定3个变量名(所有的mysql变量都必须以@开始)
CALL productpricing (@pricelow,
                     @pricehigh,
                     @priceaverage);

SELECT @pricelow, @pricehigh, @priceaverage;
+-----------+------------+---------------+
| @pricelow | @pricehigh | @priceaverage |
+-----------+------------+---------------+
|      2.50 |      55.00 |         16.13 |
+-----------+------------+---------------+
```

### IN和OUT
* 关键字IN表示传递给存储过程. onumber定义为IN，因为订单号被传入存储过程
* ototal定义为OUT，因为要从存储过程返回给用户

```sql
DELIMITER //
CREATE PROCEDURE ordertotal(
    IN onumber INT,
    OUT ototal DECIMAL(8,2)
)
BEGIN
    SELECT SUM(item_price * quantity)
    FROM orderitems
    WHERE order_num = onumber
    INTO ototal;
END //
DELIMITER ;

CALL ordertotal(20005, @total);

SELECT @total;
```
