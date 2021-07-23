# 目录
- [引言](#引言)
- [子查询概述](#子查询概述)
- [计算字段使用子查询](#计算字段使用子查询)
- [SELECT引发的子查询](#select引发的子查询)
- [INSERT引发的子查询](#insert引发的子查询)



*******************************************************************************
*******************************************************************************



# 引言
假如需要列出订购物品TNT2的所有客户, 分为下列步骤
1. 检索包含物品TNT2的所有订单的编号
2. 检索具有前一步骤列出的订单编号的所有客户的ID
3. 检索前一步骤返回的所有客户ID的客户信息

```sql
SELECT order_num
FROM orderitems
WHERE prod_id='TNT2';
+-----------+
| order_num |
+-----------+
|     20005 |
|     20007 |
+-----------+

SELECT cust_id
FROM orders
WHERE order_num IN (20005,20007);
+---------+
| cust_id |
+---------+
|   10001 |
|   10004 |
+---------+

SELECT cust_name
FROM customers
WHERE cust_id IN (10001,10004);
+----------------+
| cust_name      |
+----------------+
| Coyote Inc.    |
| Yosemite Place |
+----------------+
```
  

```sql
-- 将上述三句组成一个句子
SELECT cust_name 
FROM customers 
WHERE cust_id IN (SELECT cust_id 
                  FROM orders 
                  WHERE order_num IN (SELECT order_num 
                                      FROM orderitems 
                                      WHERE prod_id='TNT2') );
+----------------+
| cust_name      |
+----------------+
| Coyote Inc.    |
| Yosemite Place |
+----------------+
```

# 子查询概述
* 子查询(Subquery)是指出现在其他查询语句内的SELECT子句
* 一般与`IN` `=` `<>` **操作符**一起使用

```sql
-- SELECT * FROM t1, 称为Outer Query / Outer Statement 
-- SELECT column2 FROM t2, 称为SubQuery

SELECT * FROM t1 WHERE column1 = (
    SELECT column2 FROM t2
); 
```

# 计算字段使用子查询
显示customers表中每个客户的订单总数  

```sql
SELECT cust_id,
       cust_name,
       (SELECT COUNT(*) 
        FROM orders 
        WHERE orders.cust_id=customers.cust_id)
FROM customers;

+---------+----------------+----------------------------------------------------------------------+
| cust_id | cust_name      | (SELECT COUNT(*) FROM orders WHERE orders.cust_id=customers.cust_id) |
+---------+----------------+----------------------------------------------------------------------+
|   10001 | Coyote Inc.    |                                                                    2 |
|   10002 | Mouse House    |                                                                    0 |
|   10003 | Wascals        |                                                                    1 |
|   10004 | Yosemite Place |                                                                    1 |
|   10005 | E Fudd         |                                                                    1 |
+---------+----------------+----------------------------------------------------------------------+
```

# SELECT引发的子查询
* 使用 **比较运算符**的子查询 **`=`** **`>`** **`<`** **`>=`** **`<=`** **`<>`** **`!=`** **`<=>`**
```sql
operand comparison_operator (subquery)
operand comparison_operator ANY (subquery)
operand comparison_operator SOME (subquery)
operand comparison_operator ALL (subquery)
```
```sql
# 大于平均值
SELECT goods_id,goods_name,goods_price FROM tdb_goods WHERE goods_price >= (
    SELECT ROUND(AVG(goods_price),2) FROM tdb_goods
);
```
```sql
# 大于子查询得到的最小值
SELECT * FROM tdb_goods WHERE goods_price > ANY (
    SELECT goods_price FROM tdb_goods WHERE goods_cate = '超级本'
);
```
![](src/compare.png)
* 使用 **[NOT] IN**的子查询
  * = ANY运算符与IN等效
  * != ALL或<> ALL运算符与NOT IN等效
```sql
operand comparison_operator [NOT] IN (subquery)
```
* 使用 **[NOT] EXISTS**的子查询: 如果子查询返回任何行, EXISTS将返回TRUE; 否则为FALSE

# INSERT引发的子查询
```sql
INSERT [INTO] table_name [(column_name,...)]
SELECT ...


    INSERT INTO tdb_goods_cates(cate_name)
        SELECT goods_cate FROM tdb_goods GROUP BY goods_cate
    ;
```
