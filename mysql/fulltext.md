- [全文本搜索](#全文本搜索)
- [创建全文本搜索](#创建全文本搜索)
- [使用全文本搜索](#使用全文本搜索)
- [优先级](#优先级)
- [查询扩展](#查询扩展)
- [布尔文本搜索](#布尔文本搜索)



*******************************************************************************
*******************************************************************************



# 全文本搜索
* MyISAM支持全文本搜索, InnoDB不支持全文本搜索
* 全文本搜索也是一个索引, 在增加更新或删除行时, 索引随之自动更新

# 创建全文本搜索
一般在创建表时启用全文本搜索

```sql
CREATE TABLE productnotes
(
  note_id   int NOT  NULL     AUTO_INCREMENT,
  prod_id   char(10) NOT NULL,
  note_date datetime NOT NULL,
  note_text text     NULL,
  PRIMARY KEY(note_id),
  FULLTEXT(note_text)
) ENGINE=MyISAM
```

# 使用全文本搜索
使用`Match()`和`Against()`函数进行全文本搜索
* `Match()` 指定要搜索的**列名**  
* `Against()` 指定要搜索的**文本**  

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit');
+----------------------------------------------------------------------------------------------------------------------+
| note_text                                                                                                            |
+----------------------------------------------------------------------------------------------------------------------+
| Customer complaint: rabbit has been able to detect trap, food apparently less effective now.                         |
| Quantity varies, sold by the sack load. All guaranteed to be bright and orange, and suitable for use as rabbit bait. |
+----------------------------------------------------------------------------------------------------------------------+
```

# 优先级
全文本搜索的一个重要部分就是对结果排序. 具有较高等级的行先返回  
等级由MySQL根据行中词的数目、唯一词的数目、整个索引中词的总数以及包含该词的行的数目计算出来  

```sql
SELECT note_text, Match(note_text) Against('rabbit')
FROM productnotes;
+-------------------------------------------------------------------------------------------+------------------------------------+
| note_text                                                                                 | Match(note_text) Against('rabbit') |
+-------------------------------------------------------------------------------------------+------------------------------------+
| Quantity varies, sold by the sack load. All guaranteed to be bright and orange, and suitable for use as rabbit bait. | 1.5905543565750122 |
| Customer complaint: rabbit has been able to detect trap, food apparently less effective now.  | 1.6408053636550903 |
| Call from individual trapped in safe plummeting to the ground, suggests an escape hatch be added. Comment forwarded to vendor. | 0 |
+-------------------------------------------------------------------------------------------+------------------------------------+
```

# 查询扩展
在使用查询扩展时, MySQL对数据和索引进行两遍扫描来完成搜索
1. 进行一个基本的全文本搜索, 找出与搜索条件匹配的所有行  
2. MySQL检查这些匹配行并选择所有有用的词  
3. MySQL再次进行全文本搜索, 这次不仅使用原来的条件, 而且还使用所有有用的词  

进行普通的全文本搜索, 只返回一行

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils');
+---------------------------------------------------------------------------------------------------------------------------------+
| note_text                                                                                                                       |
+---------------------------------------------------------------------------------------------------------------------------------+
| Multiple customer returns, anvils failing to drop fast enough or falling backwards on purchaser. Recommend that customer        |
| considers using heavier anvils.                                                                                                 |
+---------------------------------------------------------------------------------------------------------------------------------+
```

通过关键字 **`WITH QUERY EXPANSION`** 进行查询扩展, 返回了七行
* 第一行包含词anvils, 因此等级最高. 第二行与anvils无关, 但因为它包含第一行中的两个词（customer和recommend）, 所以也被检索出来. 第3行也包含这两个相同的词, 但它们在文本中的位置更靠后且分开得更远, 因此也包含这一行, 但等级为第三

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION);
+---------------------------------------------------------------------------------------------------------------------------------+
| note_text                                                                                                                       |
+---------------------------------------------------------------------------------------------------------------------------------+
| Multiple customer returns, anvils failing to drop fast enough or falling backwards on purchaser. Recommend that customer considers using heavier anvils. |
| Customer complaint: Sticks not individually wrapped, too easy to mistakenly detonate all at once. Recommend individual wrapping. |
| Customer complaint: Not heavy enough to generate flying stars around head of victim. If being purchased for dropping, recommend ANV03 instead.        |
| Please note that no returns will be accepted if safe opened using explosives.                                                   |
| Customer complaint: rabbit has been able to detect trap, food apparently less effective now.                                    |
| Customer complaint: Circular hole in safe floor can apparently be easily cut with handsaw.                                      |
| Matches not included, recommend purchase of matches or detonator (item DTNTR).                                                  |
+---------------------------------------------------------------------------------------------------------------------------------+
```

# 布尔文本搜索
即使没有定义FULLTEXT索引, 也可以使用布尔文本搜索. 但这是一种非常缓慢的操作

### 布尔操作符

符号 | 说明
---- | ----
`+`  | 包含, 词必须存在
`-`  | 排除, 词必须不出现
`>`  | 包含, 而且增加等级值
`<`  | 包含, 且减少等级值
`()` | 把词组成子表达式
`~`  | 取消一个词的排序值
`*`  | 词尾的通配符
`""` | 定义一个短语

### 例子
匹配包含heavy但不包含任意以rope开始的词的行

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('heavy -rope*' IN BOOLEAN MODE);
+---------------------------------------------------------------------------------------------------------------------------------+
| note_text                                                                                                                       |
+---------------------------------------------------------------------------------------------------------------------------------+
| Customer complaint:Not heavy enough to generate flying stars around head of victim. If being purchased for dropping, recommend ANV02  instead.       |
+---------------------------------------------------------------------------------------------------------------------------------+
```

包含词rabbit和bait的行

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('+rabbit +bait' IN BOOLEAN MODE);
```

没有指定操作符, 匹配包含rabbit和bait中的至少一个词的行

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('rabbit bait' IN BOOLEAN MODE);
```

匹配短语rabbit bait而不是匹配两个词rabbit和bait

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('"rabbit bait"' IN BOOLEAN MODE);
```

匹配rabbit和carrot, 增加前者的等级, 降低后者的等级

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('>rabbit <bait' IN BOOLEAN MODE);
```

匹配词safe和combination, 降低后者的等级

```sql
SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('+rabbit +(<bait)' IN BOOLEAN MODE);
```
