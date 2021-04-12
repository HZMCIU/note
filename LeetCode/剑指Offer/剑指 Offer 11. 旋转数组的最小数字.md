### [剑指 Offer 11. 旋转数组的最小数字](https://leetcode-cn.com/problems/xuan-zhuan-shu-zu-de-zui-xiao-shu-zi-lcof/)

### 题意

把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。输入一个递增排序的数组的一个旋转，输出旋转数组的最小元素。例如，数组` [3,4,5,1,2] `为 `[1,2,3,4,5] `的一个旋转，该数组的最小值为1。

### 思路

使用**二分法**查找数组中的最小元素

+ 当$nums[mid]<nums[right]$ 时，最小数位于数组中点的左侧
+ 当$nums[mid]>nums[right]$时，最小数位于数组中点的右侧
+ 当$nums[mid]==nums[right]$时，$right-=1$ 
  + <font color="red">下面证明$right-=1$的正确性 </font>
  + 设最小数的下标为$x$，下面分为$right=x$和$x<right$两种情况来进行讨论
    + 若$x<right$ ，$x$仍在$[left,right-1]$的范围内
    + 若$x=right$，左侧区间$nums[i\cdots m]$的值均为$num[x]$。虽然$right-=1$错过了旋转点$x$，但左侧区间二分的结果$nums[left]=nums[x]$
      + $nums[mid] \le nums[left]$，因为$nums[right]=nums[x]=nums[mid] \le nums[left]$
      + $nums[left] \le nums[mid]$，因为$mid=(left+right)/2$，$left\le mid < right$。所以$nums[mid]$位于左侧的升序数组中，根据单调性有$nums[left]\le nums[mid]$
      + 综上，有$nums[mid] \le nums[left] \le nums[mid]$ ，即 $nums[left]=nums[mid]=nums[x]$。 $\color{red} nums[left \cdots mid]=nums[x]$

**<font color="red">为什么使用$nums[right]$和$nums[mid]$比较</font>**
当 $nums[left] \le nums[mid]$时，无法确定 $nums[mid]$位于左排序数组还是右排序数组。**但 $right$一定位于右排序数组中**。
+ `right=mid`，此时`mid`就在右侧数组中，所以无论`right`如何更新，都会指向右侧区域。
+ `left=mid+1`，`mid`可能为左侧数组的最后一个元素，`left=mid+1`，`left`可能会移动到右侧数组中


### AC代码

```java
class Solution {
    public int minArray(int[] nums) {
        int len = nums.length;
        int left = 0, right = len - 1;
        int mid = 0;
        while (left < right) {
            mid = (left + right) / 2;
            if (nums[mid] < nums[right]) {
                right = mid;
            } else if (nums[mid] > nums[left]) {
                left = mid + 1;
            } else {
                right--;
            }
        }
        return nums[left];
    }
}
```

