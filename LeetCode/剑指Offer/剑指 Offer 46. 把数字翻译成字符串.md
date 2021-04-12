### [剑指 Offer 46. 把数字翻译成字符串](https://leetcode-cn.com/problems/ba-shu-zi-fan-yi-cheng-zi-fu-chuan-lcof/)

### 题意

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

### 思路

数字序列$x_{1}x_{2}\cdots x_{n}$，青蛙跳格子问题，所以联想到可以尝试使用DP解决 
* 假设状态$dp[i]$为以$x_{i}$ 结尾的字符串可以被翻译的方法数
* 存在以下的状态转移方程
    $$
    dp[i]=\left\{ 
    \begin{array}{lr}
       dp[i-1]+dp[i-2],& x_{i-2}x_{i-1} \in [10,25] \\
       dp[i-1],& x_{i-2}x_{i-1} \not\in [10,25]
    \end{array}
    \right. 
    $$
* 使用`dp[i%3]=dp[(i-1)%3]+dp[(i-2)%3]`来优化空间
* `a.compareTo(b)`，当`a>b`时，返回1；当`a<b`时，返回-1；当`a==b`时，返回0

### AC代码

```java
class Solution {
    public static int translateNum(int num) {
        String digit = Integer.toString(num);
        int [] dp = new int [3];
        dp[0] = dp[1] = 1;
        for (int i = 2; i <= digit.length(); i++ ) {
            String tmp = digit.substring(i - 2, i);
            if (tmp.compareTo("10") >= 0 && tmp.compareTo("25") <= 0) {
                dp[i % 3] = dp[(i - 1) % 3] + dp[(i - 2) % 3];
            } else {
                dp[i % 3] = dp[(i - 1) % 3];
            }
        }
        return dp[digit.length() % 3];
    }
    public static void main(String[] args) {
        System.out.println(translateNum(12258));
    }
}
```

