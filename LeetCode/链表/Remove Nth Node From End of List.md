### [Remove Nth Node From End of List](https://leetcode.com/problems/remove-nth-node-from-end-of-list/)

### 题意

移除链表中倒数第n个节点

### 思路

使用表头结点，来简化代码的书写

### 总结

+ **双指针**。遍历一趟，去除倒数第n个结点。指针`p2`先走n步，接下来`p1`和`p2`同步，直到`p2`走到链表末尾。`p1`执行删除操作。

### 标程

```java
public ListNode removeNthFromEnd(ListNode head, int n) {
    ListNode dummy = new ListNode(0);
    dummy.next = head;
    ListNode first = dummy;
    ListNode second = dummy;
    // Advances first pointer so that the gap between first and second is n nodes apart
    for (int i = 1; i <= n + 1; i++) {
        first = first.next;
    }
    // Move first to the end, maintaining the gap
    while (first != null) {
        first = first.next;
        second = second.next;
    }
    second.next = second.next.next;
    return dummy.next;
}
```

