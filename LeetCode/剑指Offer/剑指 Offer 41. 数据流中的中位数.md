### [剑指 Offer 41. 数据流中的中位数](https://leetcode-cn.com/problems/shu-ju-liu-zhong-de-zhong-wei-shu-lcof/)

### 题意
如何得到一个数据流中的中位数？如果从数据流中读出奇数个数值，那么中位数就是所有数值排序之后位于中间的数值。如果从数据流中读出偶数个数值，那么中位数就是所有数值排序之后中间两个数的平均值。

例如，

\[2,3,4\] 的中位数是 3

\[2,3\] 的中位数是 (2 + 3) / 2 = 2.5

设计一个支持以下两种操作的数据结构：

-   void addNum(int num) - 从数据流中添加一个整数到数据结构中。
-   double findMedian() - 返回目前所有元素的中位数。

### 思路

使用最大堆和最小堆分别保存数组的左侧和右侧元素。可以使用堆顶计算得到中位数。

**数据结构**
+ 最大堆`left`维护数组的左侧元素。数组元素个数为$n$
    + 当$n$为偶数时，最大堆`left`的大小为$\frac{n}{2}$。
    + 当$n$为奇数是，`left`的大小为$\frac{n+1}{2}$
+ 最小堆`right`维护数组的右侧元素。数组元素个数为$n$
    + 当$n$为偶数时，最大堆`right`的大小为$\frac{n}{2}$。
    + 当$n$为奇数是，`right`的大小为$\frac{n+1}{2}$ 

**`addNum`**
+ 先向`right`中添加元素，然后取出`right`中的最小值加入到`left`中。
    + 不能将新元素`x`直接添加到`left`中。如果`x`的值较大，直接插入到`left`中，那么`left`保存的将不是有序数组的前半段。
+ 如果`left.size()-right.size()>1`，那么取出`left`中的最大值加入到`right`中，保持左右两侧平衡

**`findMedian`**
+ 如果元素总数为奇数，中位数为最大堆的堆顶
+ 如果元素总数为偶数，中位数为最大堆和最小堆的堆顶的平均值


### AC代码

```java
class MedianFinder {

    /** initialize your data structure here. */
    Queue<Integer> left, right;

    public MedianFinder() {
        left = new PriorityQueue<Integer>((x, y) -> (y - x));
        right = new PriorityQueue<Integer>();
    }

    public void addNum(int num) {
        right.add(num);
        left.add(right.poll());
        if (left.size() - right.size() > 1) {
            right.add(left.poll());
        }
    }

    public double findMedian() {
        int len = left.size() + right.size();
        if (len % 2 == 0) {
            return 1.0 * (left.peek() + right.peek()) / 2;
        } else {
            return left.peek();
        }
    }
}
```
