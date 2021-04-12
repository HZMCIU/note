### [剑指 Offer 60. n个骰子的点数](https://leetcode-cn.com/problems/nge-tou-zi-de-dian-shu-lcof/)

### 题目

把n个骰子扔在地上，所有骰子朝上一面的点数之和为s。输入n，打印出s的所有可能的值出现的概率。

你需要用一个浮点数数组返回答案，其中第 i 个元素代表这 n 个骰子所能掷出的点数集合中第 i 小的那个的概率。

### 思路

点数$k$ 出现的概率为
$$
P_{k}=\frac{k出现的次数}{总次数}
$$
使用动态规划计算出$n$ 个骰子，掷出点数为$s$的次数
* 定义状态。 $dp[i][j]$ 为$i$ 个骰子能够掷出点数为$j$ 的次数
* 第$i$ 投掷骰子所有可能的点数为$1,2,3,4,5,6$ 。所以投掷完$i$枚骰子点数为$j$ ，投掷完$i-1$枚骰子点数为$j-1,j-2,j-3,j-4,j-5,j-6$ 转化过来的
    * 状态转移方程
        $$
        dp[i][j]=\sum_{k=1}^{6} dp[i-1][j-k]
        $$
* 投掷$n$个骰子，所有可能共有$6^{n}$可能
* 由于投掷$n$ 个骰子的次数，只和投掷$n-1$ 个骰子的次数相关，可以使用一维数组优化空间
### AC代码

```java
class Solution {
    public static double[] dicesProbability(int n) {
        double [] dp = new double[n * 6 + 1];
        for (int i = 1; i <= 6; i++) {
            dp[i] = 1.0;
        }
        for (int i = 2; i <= n; i++) {
            for (int j = 6 * i; j >= i; j--) {
                dp[j] = 0;
                for (int k = 1; k <= 6; k++) {
                    if (j - k >= i - 1) {
                        dp[j] += dp[j - k];
                    }

                }
            }
        }
        double tot = Math.pow(6.0, 1.0 * n);
        double [] res = new double[5 * n + 1];

        for (int i = 0; i < 5 * n + 1; i++) {
            res[i] = dp[i + n] / tot;
        }
        return res;
    }
    public static void main(String[] args) {
        System.out.println(Arrays.toString(dicesProbability(1)));
    }
}
```

