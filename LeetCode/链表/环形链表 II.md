### [环形链表 II](https://leetcode-cn.com/problems/linked-list-cycle-ii/)

### 题意

给定一个链表，返回链表开始入环的第一个节点。 如果链表无环，则返回 `null`。

为了表示给定链表中的环，我们使用整数 `pos `来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 `pos `是 -1，则在该链表中没有环。**注意，`pos `仅仅是用于标识环的情况，并不会作为参数传递到函数中。**

### 思路

定义指针`slow`和`fast`，初始化为链表的头部。`slow`每次向后移动一个结点，`fast`每次向后移动两个结点。如果链表中存在环，两个指针就会相遇。两个指针相遇后，在额外使用一个指针`ptr`，指向链表的头节点，`ptr`和`slow`一起移动，每次移动一个结点，最后在环的入口点相遇。

**算法原理：**假设指针`fast`进入环中，又走了n圈后与指针`slow`相遇。假设指针`fast`行走的距离为 $a+n\times(b+c)+b=a+(n+1)\times b+c$ 。由于`fast`移动的距离是`slow`指针移动距离的两倍，$a+(n+1)\times b+c=2 \times (a+b)$ 。化简得到有$a=(n-1)\times (b+c)+c$ ，即<span style="color:red">从相遇点到入环点的距离加上$n-1$圈的环长等于链表头部到入环点的距离 </span>。



![](环形链表_II_fig1.png)

### AC代码

```java
public class Solution {
    public ListNode detectCycle(ListNode head) {
        if (head == null)
            return head;
        ListNode slow = head, fast = head;
        while (fast != null) {
            slow = slow.next;
            fast = fast.next;
            if (fast != null)
                fast = fast.next;
            else
                return null;
            if (slow == fast) {
                ListNode ptr = head;
                while (slow != ptr) {
                    slow = slow.next;
                    ptr = ptr.next;
                }
                return slow;
            }
        }
        return null;
    }
}
```

