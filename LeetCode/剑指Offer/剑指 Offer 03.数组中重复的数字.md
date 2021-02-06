### [数组中重复的数字](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)

### 题目

找出数组中重复的数字。

在一个长度为 n 的数组 `nums `里的所有数字都在 $0\sim n-1 $的范围内。数组中某些数字是重复的，但不知道有几个数字重复了，也不知道每个数字重复了几次。请找出数组中任意一个重复的数字。





### 思路

数组的长度为$[0,n-1]$，数组中的元素的大小也为$[0,n-1]$，因此如果数组不存在重复元素，则将数组排序后必定有$a[i]=i$

因为数组中的元素范围为$[0,n-1]$，故可以采用 **原地置换** 对数组进行排序 ， 若交换过程中，两个位置存在相同的值，那么这就是答案



### AC代码	

```java
class Solution {
    public int findRepeatNumber(int[] nums)
    {
        for(int i = 0; i < nums.length; i++) {
            while(nums[i] != i) {
                int m = nums[i];
                if(nums[m] == m) {
                    return m;
                }
                else {
                    int temp = nums[i];
                    nums[i] = nums[temp];
                    nums[temp] = temp;
                }
            }
        }
        return -1;
    }
}
```

