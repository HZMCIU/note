##[从尾到头打印链表](https://leetcode-cn.com/problems/cong-wei-dao-tou-da-yin-lian-biao-lcof/)

输入一个链表的头节点，从尾到头反过来返回每个节点的值（用数组返回）。

## 思路

Java中的Stack的使用

## AC代码

```java
class Solution {
    public int[] reversePrint(ListNode head)
    {
        Stack<ListNode> stack = new Stack<ListNode>();
        ListNode temp = head;
        while(temp != null) {
            stack.push(temp);
            temp = temp.next;
        }
        int size = stack.size();
        int[] ans = new int[size];
        for(int i = 0; i < size; i++) {
            ans[i] = stack.pop().val;
        }
        return ans;
    }
}
```
