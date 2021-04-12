### [剑指 Offer 49. 丑数](https://leetcode-cn.com/problems/chou-shu-lcof/)

### 题目

我们把只包含质因子 2、3 和 5 的数称作丑数（Ugly Number）。求按从小到大的顺序的第 n 个丑数。

### 思路

* 假设现在已有丑数序列$x_{1}x_{2}\cdots x_{n}$，求$x_{n+1}$ ，$x_{n+1}$ 一定是前面抽数序列$x_{1}x_{2}\cdots x_{n}$ 中的某一个值$x_{i}$乘以$2,3,5$ 
    * $x_{n+1}$ 只含有因子$2,3,4$ ，故$x_{n+1}$ 只能有较小的且只含有因子$2,3,5$ 的数乘以$2或3或5$ 得到

根据上述的推断，存在两个方法解得第$n$ 个丑数
* 使用最小堆维护所有可能成为丑数的值。当计算完第$i$ 个丑数时，优先队列中加入第$i$ 个丑数乘2、乘3、乘5的值，即`pq.add(dp[i]*2);pq.add(dp[i]*3);pq.add(dp[i]*5)`
    * 使用`HashSet`去重，防止最小堆中加入重复的结点
* 使用三个指针 `a,b,c`，指向抽数序列$x_{1}x_{2}\cdots x_{n}$乘以`2,3,5`可能成为第$n+1$ 个丑数的值。例如`dp[a]*2`，可能成为第$n+1$ 个丑数。`b,c`同理
    * $dp[n+1]=\min(dp[a]\times 2,dp[b]\times 3,dp[5]\times 5)$
    * 如果$dp[n+1]=dp[a]\times 2$，则指针 `a`向后移动；指针`b,c`同理。 <font color="red">在计算$dp[n+1]$时，可能存在指针`a,b,c`同时向后移动的情况，$dp[n+1]=dp[a]\times 2=dp[b]\times 3=dp[c]\times 5$，$dp[n+1]$ 可由三个指针所指向的值获得，为了去除重复，三个指针同时向后移动</font>

### AC代码

```java
class Solution {
    public static int nthUglyNumber(int n) {
        int a = 1, b = 1, c = 1;
        int[] dp = new int[n + 1];
        dp[1] = 1;
        for (int i = 2; i <= n; i++) {
            int n1 = 2 * dp[a], n2 = 3 * dp[b], n3 = 5 * dp[c];
            dp[i] = Math.min(n1, Math.min(n2, n3));
            if (dp[i] == n1) {
                a++;
            } 
            if (dp[i] == n2) {
                b++;
            } 
            if (dp[i] == n3) {
                c++;
            }
        }
        return dp[n];
    }
    public static void main(String[] args) {
        System.out.println(nthUglyNumber(10));
    }
}
```

