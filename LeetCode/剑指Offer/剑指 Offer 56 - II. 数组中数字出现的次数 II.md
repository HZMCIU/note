### [剑指 Offer 56 - II. 数组中数字出现的次数 II](https://leetcode-cn.com/problems/shu-zu-zhong-shu-zi-chu-xian-de-ci-shu-ii-lcof/)

### 题目

在一个数组 `nums` 中除一个数字只出现一次之外，其他数字都出现了三次。请找出那个只出现一次的数字。

### 思路

* 统计数组所有元素各个位出现的次数，并模3，将各个位的余数以二进制的形式转为整数
    * 出现三次的元素，相对应的比特位出现次数为3的整数倍，模3后，只剩余出现1次的元素的比特位
    ![统计数组元素的各个位](./Pict/202104120950_剑指Offer56_1.png "opt title")
* 使用 **[[剑指 Offer 20. 表示数值的字符串|有限状态自动机]]** 来统计各个数位1的数量
    * 以下为有限状态自动机示意图
        ![有限状态自动机](./Pict/202104120950_剑指Offer56_2.png "opt title")
    * 由于有3个状态，需要2个比特位`two one`来表示，以下为2个比特位形式的有限状态自动机示意图
        ![比特位有限状态自动机](./Pict/202104120950_剑指Offer56_3.png "opt title")
* 比特位 `one` 和 `two`的计算规则
    * 比特位`one`的计算规则
        * 通过观察自动机的转移规律，发现以下规律
            ```python
            if two == 0:
                if n == 0:
                  one = one
                if n == 1:
                  one = ~one
            if two == 1:
                one = 0
            ```
        * 引入异或运算后，可以将上述计算化简为
            ```python
            if two == 0:
                one = one ^ n
            if two == 1:
                one = 0
            ```
        * 引入与运算后，将上述计算简化为
            `one=one^n&~two`
        * 状态转化表
            ![状态转化表](./Pict/202104120950_剑指Offer56_4.png "opt title")
    * 比特位 `two`的计算规律
        * 计算完比特位 `one`后，在新的基础上计算比特位 `two`，使用类似的方法计算比特位 `two`
             ```python
             two = two ^ n & ~one
             ```
        * 新状态示意图
            ![新状态](./Pict/202104120950_剑指Offer56_5.png "opt title")
### AC代码

```java
class Solution {
    public int singleNumber(int[] nums) {
        int one = 0, two = 0;
        for (int n : nums) {
            one = one ^ n & ~two;
            two = two ^ n & ~one;
        }
        return one;
    }
}
```

