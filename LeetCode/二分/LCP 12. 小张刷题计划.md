#### [LCP 12. 小张刷题计划](https://leetcode-cn.com/problems/xiao-zhang-shua-ti-ji-hua/)

### 思路

​		首先要发现这个问题具有单调性，可以使用二分法枚举时间长度。

​		在检验长度的合法性的时候，要减去一个序列中的最大值，LeetCode标程给出了一个比较巧妙地解法。使用类似“木桶短板”的方法，获取一个序列中除去最大值的sum。

### 标程代码

```cpp
class Solution {
public:
    bool Check(int limit, vector<int> cost, int day) {
      // 每组划分 limit 的最大和，贪心划分看有多少组
        int useday, totaltime, maxtime;
        useday = 1; totaltime = maxtime = 0;
        for (int i=0; i<cost.size(); ++i) {
            int nexttime = min(maxtime, cost[i]);
            if (nexttime + totaltime <= limit) {
                totaltime += nexttime;
                maxtime = max(maxtime, cost[i]);
            } else {
                ++useday;
                totaltime = 0;
                maxtime = cost[i];
            }
        }
        return (useday <= day);
    }
    int minTime(vector<int>& time, int m) {
        int left, right, middle;
        left = right = 0;
        for (int i=0; i<time.size(); ++i) {
            right += time[i];
        }
        while (left <= right) {
            middle = (left + right) >> 1;
            if (Check(middle, time, m)) right = middle - 1;
            else left = middle + 1;
        }
        return left;
    }
};
```

