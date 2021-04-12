### [剑指 Offer 42. 连续子数组的最大和](https://leetcode-cn.com/problems/lian-xu-zi-shu-zu-de-zui-da-he-lcof/)

### 题意

输入一个整型数组，数组中的一个或连续多个整数组成一个子数组。求所有子数组的和的最大值。

要求时间复杂度为O(n)

### 思路

+ 状态定义：$dp[i]$代表以$nums[i]$结尾的连续数组的最大和
+ 转移方程：
  + 如果$dp[i-1]<0$ ，那么$dp[i-1]+nums[i]<nums[i]$，还不如$nums[i]$大。直接执行$dp[i]=nums[i]$
  + 如果$dp[i-1]>0$。执行$dp[i]=dp[i-1]+nums[i]$

### AC代码

```java
class Solution {
    public int maxSubArray(int[] nums) {
        int n = nums.length;
        int[] dp = new int[n];
        int ans = nums[0];
        dp[0] = nums[0];

        for (int i = 1; i < n; i++) {
            dp[i] = Math.max(nums[i], dp[i - 1] + nums[i]);
            ans = Math.max(ans, dp[i]);
        }

        return ans;
    }
}
```

