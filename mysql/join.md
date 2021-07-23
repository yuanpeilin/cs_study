- [联结](#联结)
- [内联结](#内联结)
    - [语法](#语法)
    - [与子查询的转换](#与子查询的转换)
- [外部联结](#外部联结)
    - [左外联结](#左外联结)
    - [右外联结](#右外联结)
- [自联结](#自联结)
- [自然联结](#自然联结)
- [多表连接](#多表连接)



*******************************************************************************
*******************************************************************************



# 联结
通常使用`ON`关键字来设定联结条件, 联结分为
1. 内联结(等值联结) `[INNER | CROSS] JOIN`
2. 外部联结
    * 左外连接 `LEFT [OUTER] JOIN`
    * 右外连接 `RIGHT [OUTER] JOIN`
3. 自联结
4. 自然联结

# 内联结
内联结也称为**等值联结(equijoin)**

![](src/innerjoin.png)

### 语法
下面两句等价, 只是第二句使用了内联结的语法

```sql
SELECT vend_name, prod_name, prod_price 
FROM vendors, products
WHERE vendors.vend_id = products.vend_id;

SELECT vend_name, prod_name, prod_price 
FROM vendors INNER JOIN products 
ON vendors.vend_id = products.vend_id;
+-------------+----------------+------------+
| vend_name   | prod_name      | prod_price |
+-------------+----------------+------------+
| Anvils R Us | .5 ton anvil   |       5.99 |
| Anvils R Us | 1 ton anvil    |       9.99 |
| Anvils R Us | 2 ton anvil    |      14.99 |
| LT Supplies | Fuses          |       3.42 |
| LT Supplies | Oil can        |       8.99 |
| ACME        | Detonator      |      13.00 |
| ACME        | Bird seed      |      10.00 |
| ACME        | Carrots        |       2.50 |
| ACME        | Safe           |      50.00 |
| ACME        | Sling          |       4.49 |
| ACME        | TNT (1 stick)  |       2.50 |
| ACME        | TNT (5 sticks) |      10.00 |
| Jet Set     | JetPack 1000   |      35.00 |
| Jet Set     | JetPack 2000   |      55.00 |
+-------------+----------------+------------+
```

### 与子查询的转换
在[子查询](subquery.md/#引言)中, 需要查询 *订购物品TNT2的所有客户*, 下面是内联结的写法

```sql
SELECT customers.cust_name
FROM orders, orderitems, customers
WHERE orderitems.prod_id = 'TNT2'
    AND orderitems.order_num = orders.order_num
    AND orders.cust_id = customers.cust_id;
+----------------+
| cust_name      |
+----------------+
| Coyote Inc.    |
| Yosemite Place |
+----------------+
```

# 外部联结
联结包含了那些在相关表中没有关联行的行. 这种类型的联结称为**外部联结**. 如:
* 对每个客户下了多少订单进行计数, 包括那些至今尚未下订单的客户
* 列出所有产品以及订购数量, 包括没有人订购的产品

### 左外联结
![](src/leftoutjoin.png)

```sql
-- 检索所有用户及其订单
SELECT customers.cust_id, orders.order_num
FROM customers INNER JOIN orders
ON customers.cust_id = orders.cust_id;
+---------+-----------+
| cust_id | order_num |
+---------+-----------+
|   10001 |     20005 |
|   10001 |     20009 |
|   10003 |     20006 |
|   10004 |     20007 |
|   10005 |     20008 |
+---------+-----------+
```

```sql
-- 使用外部联结, 检索所有客户, 包括那些没有订单的客户
SELECT customers.cust_id, orders.order_num
FROM customers LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id;
+---------+-----------+
| cust_id | order_num |
+---------+-----------+
|   10001 |     20005 |
|   10001 |     20009 |
|   10002 |      NULL |
|   10003 |     20006 |
|   10004 |     20007 |
|   10005 |     20008 |
+---------+-----------+
```

### 右外联结
![](src/rightoutjoin.png)

# 自联结
**自联结** 表示一个表出现两次, 自己联结自己


```sql
-- 假如某物品(其ID为DTNTR)存在问题, 因此想知道生产该物品的供应商生产的其他物品是否也存在这些问题, 列出该供应商的所有物品

----- 子查询写法
SELECT prod_id, prod_name
FROM products
WHERE vend_id = (SELECT vend_id
                 FROM products
                 WHERE prod_id = 'DTNTR');

----- 联结写法
SELECT a.prod_id, a.prod_name
FROM products AS a, products AS b
WHERE a.vend_id = b.vend_id
    AND b.prod_id = 'DTNTR';

+---------+----------------+
| prod_id | prod_name      |
+---------+----------------+
| DTNTR   | Detonator      |
| FB      | Bird seed      |
| FC      | Carrots        |
| SAFE    | Safe           |
| SLING   | Sling          |
| TNT1    | TNT (1 stick)  |
| TNT2    | TNT (5 sticks) |
+---------+----------------
```

# 自然联结
**自然联结** 在两个表有相同名称的列且列定义类似时使用, 在同名列上进行相等连接

```sql
SELECT c.*, o.order_num, o.order_date, oi.prod_id, oi.quantity, oi.item_price
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
AND   oi.order_num = o.order_num
AND   prod_id = 'FB';
```

# 多表连接
```sql
SELECT prod_name,vend_name,prod_price,quantity 
FROM orderitems,products,vendors 
WHERE products.vend_id=vendors.vend_id 
  AND orderitems.prod_id=products.prod_id
  AND order_num=20005; 
+----------------+-------------+------------+----------+
| prod_name      | vend_name   | prod_price | quantity |
+----------------+-------------+------------+----------+
| .5 ton anvil   | Anvils R Us |       5.99 |       10 |
| 1 ton anvil    | Anvils R Us |       9.99 |        3 |
| TNT (5 sticks) | ACME        |      10.00 |        5 |
| Bird seed      | ACME        |      10.00 |        1 |
+----------------+-------------+------------+----------+
```
