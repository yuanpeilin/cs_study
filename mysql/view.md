# 目录
- [概述](#概述)
- [基本使用](#基本使用)
- [视图curd](#视图curd)



*******************************************************************************
*******************************************************************************



# 概述
**视图是虚拟的表**, 使用视图的好处:
* 重用SQL语句
* 简化复杂的SQL操作. 在编写查询后, 可以方便地重用它而不必知道它的基本查询细节
* 保护数据. 可以给用户授予表的特定部分的访问权限而不是整个表的访问权限
* 更改数据格式和表示. 视图可返回与底层表的表示和格式不同的数据

# 基本使用
```sql
-- 查询订购了某个特定产品的客户, 使用联结必须理解相关表的结构, 并且知道如何创建查询和对表进行联结. 以下是联结的写法:
SELECT customers.cust_name
FROM orders, orderitems, customers
WHERE orderitems.prod_id = 'TNT2'
AND orderitems.order_num = orders.order_num
AND orders.cust_id = customers.cust_id;
```

```sql
-- 假如可以把整个查询包装成一个名为productcustomers的虚拟表，则可以如下轻松地检索出相同的数据
SELECT cust_name, cust_contact
FROM productcustomers
WHERE prod_id = 'TNT2';

-- 创建视图
CREATE VIEW productcustomers AS
SELECT cust_name, cust_contact, prod_id
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
AND orderitems.order_num = orders.order_num;

-- 使用视图
SELECT * FROM productcustomers;
+----------------+--------------+---------+
| cust_name      | cust_contact | prod_id |
+----------------+--------------+---------+
| Coyote Inc.    | Y Lee        | ANV01   |
| Coyote Inc.    | Y Lee        | ANV02   |
| Coyote Inc.    | Y Lee        | TNT2    |
| Coyote Inc.    | Y Lee        | FB      |
| Coyote Inc.    | Y Lee        | FB      |
| Coyote Inc.    | Y Lee        | OL1     |
| Coyote Inc.    | Y Lee        | SLING   |
| Coyote Inc.    | Y Lee        | ANV03   |
| Wascals        | Jim Jones    | JP2000  |
| Yosemite Place | Y Sam        | TNT2    |
| Bob            | E Fudd       | FC      |
+----------------+--------------+---------+
```

# 视图curd
* 增 `CREATE VIEW`

```sql
CREATE VIEW productcustomers AS
SELECT cust_name, cust_contact, prod_id
FROM customers, orders, orderitems
WHERE customers.cust_id = orders.cust_id
AND orderitems.order_num = orders.order_num;
```

* 删 `DROP VIEW view_name`

* 查 `SHOW CREATE VIEW view_name`

* 改 `CREATE OR REPLACE VIEW`
