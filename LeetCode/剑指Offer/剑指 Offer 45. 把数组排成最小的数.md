### [剑指 Offer 45. 把数组排成最小的数](https://leetcode-cn.com/problems/ba-shu-zu-pai-cheng-zui-xiao-de-shu-lcof/)

### 题目

输入一个非负整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。

### 思路

* 自定义排序: 假设存在两个数$x$,$y$ ，将两个数拼接后，如果$xy<yx$ ，说明 $x<y$
    * 在最终的最小数中$x$ 部分位于$y$ 的左侧
    * 数组`nums`中存在$n$ 个数，$n_{i},i \in [1,n]$, $n$ 个数排列得到的最小数$n_{1}n_{2}\cdots n_{n}$ 一定满足$n_{1}<n_{2}<\cdots < n_{n}$ 的关系。这里的$<$，比较的不是数值的大小，而是偏序关系
    * 使用反证法证明，最小数 $n_{1}n_{2}\cdots n_{n}$满足指定的偏序关系
        * 假设最小数为`xxxxxxx`，最小数中存在两个部分`a` 和 `b`，满足$a>b$（偏序关系上）
        * 最小数为`xxxxxab`，交换a,b，得到`xxxxxba`，显然有`xxxxxab>xxxxba`，这与假设`xxxxab`为最小值矛盾
        * 最小数为`abxxxxx`，交换a,b，得到`baxxxxx`，显然后`abxxxxx>baxxxx`，与假设矛盾
        * 最小数为`axxxxxb`，将中间部分看作一个整体，则有`ayb`，根据数值关系显然有`ay<ya`,`yb<by`，假设`a`,`y`,`b`的长度分别为$n$,$m$,$k$ 位
            * `ay<ya`,等价于$a \times 10^{m} < y \times 10^{n} +a$，化简得$y > \frac{a\left( 10^{m}-1 \right)}{10^{n}-1}$ 
            * `yb<by`，等价于$y\times 10^{k}+b<b\times 10^{m}+y$，化简得$y<\frac{b\left( 10^{m}-1 \right)}{10^{k}-1}$ 
            * 综上可得，$\frac{a\left( 10^{m}-1 \right)}{10^{n}-1}<y<\frac{b\left( 10^{m}-1 \right)}{10^{k}-1}$ ，化简可得$a\times 10^{k}+b<b \times 10^{n}+a$，即`ab<ba`，也即`a<b`，与已知假设矛盾

### AC代码

```java
class Solution {
    public String minNumber(int[] nums) {
        String[] vals = new String[nums.length];
        for (int i = 0; i < nums.length; i++) {
            vals[i] = String.valueOf(nums[i]);
        }
        Arrays.sort(vals, (a, b)->(a + b).compareTo(b + a));
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < nums.length; i++) {
            sb.append(vals[i]);
        }
        return sb.toString();
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.minNumber(new int[] {10, 2}));
        System.out.println(sol.minNumber(new int[] {3, 30, 34, 5, 9}));
    }
}
```

