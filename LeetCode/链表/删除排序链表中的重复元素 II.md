### [ 删除排序链表中的重复元素 II](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list-ii/)

### 题意

给定一个排序链表，删除所有含有重复数字的节点，只保留原始链表中 *没有重复出现* 的数字。

### 思路

使用前驱指针和`dummy`头节点删除。

```java
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        ListNode dummy = new ListNode(-1153); // 设置一个随机数，和链表头节点不一样
        dummy.next = head;
        ListNode p1 = dummy;
        ListNode pre = dummy; //前驱指针
        while (p1 != null) {
            // 删除重复的链表段，前驱指针不更新
            if (p1.next != null && p1.val == p1.next.val) {
                while (p1.next != null && p1.val == p1.next.val) {
                    p1 = p1.next;
                }
                p1 = p1.next;
                pre.next = p1;
            } else {
                pre = p1;
                p1 = p1.next;
            }
        }
        return dummy.next;
    }
}
```