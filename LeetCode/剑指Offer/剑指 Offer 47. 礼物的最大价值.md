### [剑指 Offer 47. 礼物的最大价值](https://leetcode-cn.com/problems/li-wu-de-zui-da-jie-zhi-lcof/)

### 题目

在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

### 思路

使用动态规划解决问题，定义状态`dp[i][j]`为走到棋盘$(i,j)$ 能够获得的最大价值，有如下的状态转移方程

$$
dp[i][j]=\left\{ 
    \begin{array}{lr}
       grid[i][j],&i= 0 & and & j= 0  \\
       grid[i][j]+dp[i-1][j],& i>0 & and & j= 0 \\ 
       grid[i][j]+dp[i][j-1], &i =0 & and &j>0 \\
       grid[i][j]+\max(dp[i][j-1],dp[i-1][j]),& i>0 & and &j>0
    \end{array}
\right. 
$$

### AC代码

```java
class Solution {
    public int maxValue(int[][] grid) {
        int n = grid.length, m = grid[0].length;
        int [][] dp = new int [n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (i == 0 && j == 0) {
                    dp[i][j] = grid[i][j];
                } else if (i > 0 && j == 0) {
                    dp[i][j] = grid[i][j] + dp[i - 1][j];
                } else if (i == 0 && j > 0) {
                    dp[i][j] = grid[i][j] + dp[i][j - 1];
                } else {
                    dp[i][j] = grid[i][j] + Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[n - 1][m - 1];
    }
}
```
