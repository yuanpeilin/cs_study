- [触发器](#触发器)
- [创建触发器](#创建触发器)
- [删除触发器](#删除触发器)
- [INSERT触发器](#insert触发器)
- [DELETE触发器](#delete触发器)
- [UPDATE触发器](#update触发器)



*******************************************************************************
*******************************************************************************



# 触发器
* 触发器是位于BEGIN和END语句之间, 在某个表发生更改时而自动执行的一条MySQL语句
* 只有表才支持触发器, 每个事件每次只允许一个触发器, 所以每个表最多支持6个触发器(每条INSERT、UPDATE和DELETE的之前和之后)

# 创建触发器
* `CREATE TRIGGER`用来创建名为newproduct的新触发器
* `AFTER INSERT`表示触发器将在INSERT语句成功执行后执行
* `FOR EACH ROW`表示对每个插入行触发触发器
* 使用INSERT语句添加一行或多行到products中, 对每个成功的插入, 显示Product added消息

```sql
CREATE TRIGGER newproduct
AFTER INSERT ON products
FOR EACH ROW SELECT 'Product added'
```

# 删除触发器
```sql
DROP TRIGGER newproduct;
```

# INSERT触发器
* 在INSERT触发器代码内, 可引用一个名为NEW的虚拟表, 访问被插入的行
* 在BEFORE INSERT触发器中, NEW中的值可以被更新(允许更改被插入的值)

```sql
-- 对于orders的每次插入, 使用这个触发器将总是返回新的订单号
CREATE TRIGGER neworder
AFTER INSERT ON orders
FOR EACH ROW SELECT NEW.order_num;
```

# DELETE触发器
* 在DELETE触发器代码内, 可以引用一个名为OLD的虚拟表, 访问被删除的行
* OLD中的值全都是只读的, 不能更新

```sql
-- 在任意订单被删除前将执行此触发器: 它使用一条INSERT语句将OLD中的要被删除值保存到一个名为archive_orders的表中
CREATE TRIGER deleteorder
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
INSERT INTO archive_orders(order_num, order_date)
VALUES(OLD.order_num, OLD.cust_id);
END
```

# UPDATE触发器
* 在UPDATE触发器代码中, 可以引用一个名为OLD的虚拟表访问UPDATE语句前的值, 引用一个名为NEW的虚拟表访问更新的后值
* 在BEFORE UPDATE触发器中, NEW中的值可以被更新(允许更改被更新的值)
* OLD中的值全都是只读的

```sql
-- 下面的例子保证州名缩写总是大写
CREATE TRIGGER updatevendor
BEFORE UPDATE ON vendors
FOR EACH ROW SET NEW.vend_state = UPPER(NEW.vend_state);
```
