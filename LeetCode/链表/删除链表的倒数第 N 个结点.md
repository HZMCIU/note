### [删除链表的倒数第 N 个结点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/)

### 题意

给你一个链表，删除链表的倒数第 `n` 个结点，并且返回链表的头结点。

**进阶：**你能尝试使用一趟扫描实现吗？

### 思路

使用两个指针`first`和`second`来对链表进行遍历。`first`初始化为链表第一个元素，`second`初始化为`dummy`头节点，`first`和`second`中间相隔n个结点。当`first`遍历到链表末尾时，`second`处于倒数第n个节点上。

当链表中只有一个元素的时候，删除链表中的唯一元素，使用`dummy`头结点可以简化操作。

### AC代码

```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        ListNode dummy = new ListNode();
        dummy.next = head;
        ListNode first = head, second = dummy;
        for (int i = 0; i < n; i++) {
            first = first.next;
        }
        while (first != null) {
            first = first.next;
            second = second.next;
        }
        second.next = second.next.next;
        return dummy.next;
    }
}
```

