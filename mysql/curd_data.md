* [Insert 新增数据](#新增数据)
* [Delete 删除数据](#删除数据)
* [Select 查询数据](#查询数据)
    - [1. 格式](#1-格式)
    - [2. 检索不同的行 DISTINCT](#2-检索不同的行-distinct)
    - [3. 限制行数 LIMIT](#3-限制行数-limit)
    - [4. 排序 ORDER BY](#4-排序-order-by)
    - [5. 空值检查 IS NULL](#5-空值检查-is-null)
    - [6. WHERE子句过滤数据 BETWEEN](#6-where子句过滤数据-between)
    - [7. 组合WHERE子句过滤数据 AND OR](#7-组合where子句过滤数据-and-or)
    - [8. WHERE子句过滤数据 IN](#8-where子句过滤数据-in)
    - [9. WHERE子句过滤数据 通配符 LIKE](#9-where子句过滤数据-通配符-like)
    - [10. 正则表达式 REGEXP](#10-正则表达式-regexp)
    - [11. 分组](#11-分组)
    - [12. 汇总分组](#12-汇总分组)
    - [13. 过滤分组](#13-过滤分组)
* [Update 修改数据](#修改数据)



*******************************************************************************
*******************************************************************************



# 新增数据
```sql
-- 插入完整的行
INSERT INTO customers 
VALUES (NULL, 'Bob', '100 Street', 'Los Angeles', 'CA', 90046, 'USA', NULL, NULL);
```

```sql
-- 插入部分数据
INSERT INTO customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country)
VALUES ('Bob', '100 Street', 'Los Angeles', 'CA', 90046, 'USA');
```

```sql
-- 插入多个记录
INSERT INTO customers(cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country) 
VALUES('Bob', '100 Street', 'Los Angeles', 'CA', '90046', 'USA'),
      ('Aoa', '999 Street', 'New York', 'NY', '11213', 'USA');
```

```sql
-- 插入搜索出来的数据
INSERT INTO customers(cust_id, cust_contact)
SELECT cust_id, cust_contact
FROM custnew;
```

# 删除数据
```sql
DELETE FROM customers
WHERE cust_id = 10006;

DELETE a
FROM Person a JOIN Person c
on a.Email = c.Email
AND a.Id > c.Id
```

# 查询数据
### 1. 格式
```sql
SELECT select_expr [, select_expr ...]
[
    FROM table_references
    [WHERE where_condition]
    [GROUP BY {column_name | position} [ASC | DESC], ... ]
    [HAVING where_conditionl]
    [ORDER BY {column_name | expr | position} [ASC | DESC], ... ]
    [LIMIT {[offset,] row_count | row_count OFFSET offset}]
]
```

### 2. 检索不同的行 DISTINCT
DESTINCT关键字只返回不同的值. 如果修饰两个或两个以上的列, 那么只有两个列的值都相同时, 才算相同

```sql
SELECT vend_id, prod_price FROM products;
+---------+------------+
| vend_id | prod_price |
+---------+------------+
|    1003 |       2.50 |
|    1003 |       2.50 |
|    1003 |       4.49 |
|    1003 |      10.00 |
|    1003 |      10.00 |
+---------+------------+

SELECT DISTINCT vend_id, prod_price
FROM products
ORDER BY vend_id,prod_price;
+---------+------------+
| vend_id | prod_price |
+---------+------------+
|    1003 |       2.50 |
|    1003 |       4.49 |
|    1003 |      10.00 |
+---------+------------+
```

### 3. 限制行数 LIMIT
* `LIMIT 3` 返回前三条记录(返回第0, 1, 2条记录)
* `LIMIT 3, 2` 从0开始编号, 包括第3条记录, 返回2条记录(返回第3, 4条记录, 前面还有第0, 1, 2条记录)

```sql
SELECT * FROM users LIMIT 3;
SELECT * FROM users LIMIT 3, 2;
SELECT * FROM users LIMIT 3 OFFSET 2;
```

### 4. 排序 ORDER BY
* 默认为ASC升序(A-Z 1-9), 还可以设置为DESC降序(Z-A 9-1)
* ORDER BY子句应该保证它位于FROM子句之后. 如果使用LIMIT, LIMIT必须位于ORDER BY之后  

```sql
SELECT * FROM users ORDER BY id, age DESC;
```

### 5. 空值检查 IS NULL
```sql
SELECT cust_id FROM customers WHERE cust_email IS NULL;
+---------+
| cust_id |
+---------+
|   10002 |
|   10005 |
+---------+
```

### 6. WHERE子句过滤数据 BETWEEN
```sql
SELECT prod_name, prod_price
FROM products
WHERE prod_price BETWEEN 5 AND 10;
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| .5 ton anvil   |       5.99 |
| 1 ton anvil    |       9.99 |
| Bird seed      |      10.00 |
| TNT (5 sticks) |      10.00 |
+----------------+------------+
```

### 7. 组合WHERE子句过滤数据 AND OR
SQL在处理OR操作符之前, 会优先处理AND操作符. 在同时使用AND和OR时, 应使用圆括号明确地分组相应的操作符

```sql
SELECT prod_name, prod_price 
FROM products 
WHERE (vend_id=1002 OR vend_id=1003) AND prod_price>=10;
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| Detonator      |      13.00 |
| Bird seed      |      10.00 |
| Safe           |      50.00 |
| TNT (5 sticks) |      10.00 |
+----------------+------------+
```

### 8. WHERE子句过滤数据 IN
IN操作符用来指定条件范围, 范围中的每个条件都可以进行匹配. IN取合法值的由逗号分隔的清单, 全都括在圆括号中  

```sql
SELECT prod_name, prod_price 
FROM products 
WHERE vend_id IN (1002, 1003);
+----------------+------------+
| prod_name      | prod_price |
+----------------+------------+
| Detonator      |      13.00 |
| Bird seed      |      10.00 |
| Carrots        |       2.50 |
| Fuses          |       3.42 |
| Oil can        |       8.99 |
| Safe           |      50.00 |
| Sling          |       4.49 |
| TNT (1 stick)  |       2.50 |
| TNT (5 sticks) |      10.00 |
+----------------+------------+
```

```sql
SELECT *
FROM products
WHERE (vend_id,prod_price)
IN (
    SELECT a, b ...
)
```

### 9. WHERE子句过滤数据 通配符 LIKE
* **`%`** 通配符表示匹配任意个字符, 不仅包括一个字符和多个字符, 还可以代表0个字符. 此通配符 **不能匹配NULL**
* **`_`配符** 通配符表示匹配单个字符

```sql
SELECT prod_id, prod_name FROM products WHERE prod_name LIKE 'jet%';
+---------+--------------+
| prod_id | prod_name    |
+---------+--------------+
| JP1000  | JetPack 1000 |
| JP2000  | JetPack 2000 |
+---------+--------------+
```

```sql
SELECT prod_id, prod_name FROM products WHERE prod_name LIKE '_ ton anvil';
+---------+-------------+
| prod_id | prod_name   |
+---------+-------------+
| ANV02   | 1 ton anvil |
| ANV03   | 2 ton anvil |
+---------+-------------+
```

### 10. 正则表达式 REGEXP
* 若匹配返回1, 不匹配返回0
* 基本格式: 用REGEXP关键字代替LIKE
* **`BINARY`** 关键字表示区分大小写
* 转义要使用两个反斜线

```sql
SELECT 'hello' REGEXP '[0-9]';
+------------------------+
| 'hello' regexp '[0-9]' |
+------------------------+
|                      0 |
+------------------------+

SELECT prod_name FROM products WHERE prod_name REGEXP 'jetpack .000';
+--------------+
| prod_name    |
+--------------+
| JetPack 1000 |
| JetPack 2000 |
+--------------+

SELECT prod_name FROM products WHERE prod_name REGEXP BINARY 'jetpack .000';
Empty set

SELECT prod_name FROM products WHERE prod_name REGEXP '\\.';
+--------------+
| prod_name    |
+--------------+
| .5 ton anvil |
+--------------+

SELECT prod_name FROM products WHERE prod_name REGEXP '[[:digit:]]{4}';
+--------------+
| prod_name    |
+--------------+
| JetPack 1000 |
| JetPack 2000 |
+--------------+
```

### 11. 分组
* GROUP BY子句必须出现在WHERE子句之后, ORDER BY子句之前
* 除聚集计算语句外, SELECT语句中的每个列都必须在GROUP BY子句中给出
* 如果在SELECT中使用表达式, 则必须在GROUP BY子句中指定相同的表达式, 不能使用别名

```sql
SELECT vend_id, COUNT(*) FROM products GROUP BY vend_id;
+---------+----------+
| vend_id | COUNT(*) |
+---------+----------+
|    1001 |        3 |
|    1002 |        2 |
|    1003 |        7 |
|    1005 |        2 |
+---------+----------+
```

### 12. 汇总分组
使用`WITH ROLLUP`关键字可以得到每个分组汇总级别的值

```sql
SELECT vend_id, COUNT(*) FROM products GROUP BY vend_id WITH ROLLUP;
+---------+----------+
| vend_id | COUNT(*) |
+---------+----------+
|    1001 |        3 |
|    1002 |        2 |
|    1003 |        7 |
|    1005 |        2 |
|    NULL |       14 |
+---------+----------+
```

### 13. 过滤分组
* WHERE过滤指定的是行而不是分组, WHERE过滤行, 而HAVING过滤分组
* WHERE在数据分组前进行过滤，HAVING在数据分组后进行过滤

```sql
SELECT vend_id, COUNT(*) FROM products GROUP BY vend_id WITH ROLLUP HAVING COUNT(*)>=3;

+---------+----------+
| vend_id | COUNT(*) |
+---------+----------+
|    1001 |        3 |
|    1003 |        7 |
|    NULL |       14 |
+---------+----------+
```

# 修改数据
```sql
-- 修改单个字段记录
UPDATE customers
SET cust_email = 'example@mail.com'
WHERE cust_id = 10005;
```

```sql
-- 修改多个字段记录
UPDATE customers
SET cust_email = 'example@Email.com',
    cust_name = 'Bob'
WHERE cust_id = 10005;
```
