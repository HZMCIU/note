[TOC]

# `count`的使用[^2]

`SELECT`从数据库检索出一系列数据集。`count(expr)`返回结果集中`expr`字段**非空**的数量。

**使用`count(*)`获取数据行数**

1. 获取整张表的数据行数

   ```sql
   SELECT COUNT(*) FROM pet; --查询一共有多少宠物
   ```

   结果

   ```
   +----------+
   | COUNT(*) |
   +----------+
   |        9 |
   +----------+
   ```

   

2. 使用`GROUP BY`先对数据进行分组，然后对各个分组进行统计

   ```sql
   SELECT owner, COUNT(*) FROM pet GROUP BY owner; -- 查询每个主人所拥有的的宠物的数量
   ```

   结果

   ```
   +--------+----------+
   | owner  | COUNT(*) |
   +--------+----------+
   | Benny  |        2 |
   | Diane  |        2 |
   | Gwen   |        3 |
   | Harold |        2 |
   +--------+----------+
   ```

3. `GROUP BY`选定多个分组标准，并用`count(*)`对各个分组进行统计

   ```sql
   SELECT species, sex, COUNT(*) FROM pet GROUP BY species, sex; -- 以性别和物种对宠物进行分类，并统计每个类别中宠物的数量
   ```

   结果

   ```
   +---------+------+----------+
   | species | sex  | COUNT(*) |
   +---------+------+----------+
   | bird    | NULL |        1 |
   | bird    | f    |        1 |
   | cat     | f    |        1 |
   | cat     | m    |        1 |
   | dog     | f    |        1 |
   | dog     | m    |        2 |
   | hamster | f    |        1 |
   | snake   | m    |        1 |
   +---------+------+----------+
   ```

4. 对指定条件查询获取的结果集进行统计，此时不需要进行全表扫描

   ```sql
   -- 查询狗和猫，并以物种和性别进行分类，对每一个类别进行统计
   SELECT species, sex, COUNT(*) FROM pet
   WHERE species = 'dog' OR species = 'cat'
   GROUP BY species, sex;
   ```

   结果

   ```
   +---------+------+----------+
   | species | sex  | COUNT(*) |
   +---------+------+----------+
   | cat     | f    |        1 |
   | cat     | m    |        1 |
   | dog     | f    |        1 |
   | dog     | m    |        2 |
   +---------+------+----------+
   ```

# `count(*)`[^1]

`count(*)`返回结果集的数据行行数。即使数据行中包含了NULL值，也会被统计进去。

InnoDB引擎在多事务并发的过程中，`SELECT COUNT(*)`统计当前事务中的数据行数，不受其他事务影响。

由于MyISAM引擎不需要支持事务，MyISAM引擎会在内部维护一个计数器，统计表中数据行的数量。因此，在MyISAM引擎中，`SELECT COUNT(*)`如果只是对一张表操作，并且没有`WHERE`子句，直接返回内部的MyISAM内部的计数器。

MySQL8.0.13版本中，`SELECT COUNT(*) FROM tbl_name`  没有跟`WHERE`或`GROUP BY`子句，会对`SELECT COUNT(*)`进行优化。

`COUNT(*)`和`COUNT(1)`，执行的过程是一致的，没有性能上的差异。

`SELECT COUNT(*)` 在执行的原理是遍历最小可用的辅助索引，这是出于性能的考虑，辅助索引比主键索引要小，遍历最小辅助索引能够大大减少IO．

# `count(*)`、`count(1)`、`count(主键)`、`count(字段)`的区别

count()是一个聚合函数，对于返回的结果集，会逐行判断，若返回的不是 NULL，就会加 1，否则不加。

因此，count(*)、count(主键 id)和count(1)都表示返回满足条件的结果集的总行数；而count(字段），则表示返回满足条件的数据行里面，参数“字段”不为 NULL 的总个数。

**性能区别**

分析性能，考虑以下几个原则：

1. server 层要什么就会返回什么；

2. InnoDB 只返回必要的值；

3. 优化器只优化了count(*)

<span style="color:red">**执行原理**</span>

对于count(主键id)，InnoDB 会遍历全表，取每行的主键 id，返回给 server 层，server 层拿到数据后，进行判断累加。

对于count(1)，InnoDB 仍遍历全表，但是不取值，server 层对返回的每一行数据新增一个 1，然后进行判断累加；

因此，count(1)要更快些，因为无需取值。从引擎返回 id 会涉及到解析数据行，以及拷贝字段值的操作。

对于count(字段)：

1. 如果这个“字段”是定义为 not null 的话，一行行地从记录里面读出这个字段，判断不能为 null，按行累加；
2. 如果这个“字段”定义允许为 null，那么执行的时候，判断到有可能是 null，还要把值取出来再判断一下，不是 null 才累加。

但是count(\*)是例外，并不会把全部字段取出来，而是专门做了优化，不取值。count(\*)肯定不是 null，按行累加。

> **结论**：按照效率排序的话，count(字段)<count(主键 id)<count(1)≈count(*)，所以我建议你，尽量使用count(*)。

# 参考资料

[^1]: [MySQL官方文档–count()函数](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count)
[^2]:[MySQL官方文档–counting-rows](https://dev.mysql.com/doc/refman/8.0/en/counting-rows.html)
[^3]:[Mysql count(*)，count(字段)，count(1)的区别 ](https://www.jianshu.com/p/e1229342a5e2)