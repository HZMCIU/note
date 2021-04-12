### [剑指 Offer 35. 复杂链表的复制](https://leetcode-cn.com/problems/fu-za-lian-biao-de-fu-zhi-lcof/)

### 题目

请实现 `copyRandomList` 函数，复制一个复杂链表。在复杂链表中，每个节点除了有一个 `next` 指针指向下一个节点，还有一个 `random` 指针指向链表中的任意节点或者 `null`。

### 思路

* 使用哈希表`HashSet<Node,Node>`保存新旧结点的之间的映射。在遍历原结点的时候，建立新节点之间的关系
* 链表的拼接与拆分
    * 对每个结点构造一个结点的拷贝，加入到原结点的后方。链表呈现`(原结点1->新节点1->原结点2->新节点2-> ... ->原结点n->新节点n)`的形式
    * 按照[[../链表/奇偶链表|奇偶链表]]的划分方式，将新节点从链表分离出来

### AC代码

```java
class Solution {
    public static Node copyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        Node cur = head;
        while (cur != null) {
            Node tmp = new Node(cur.val);
            tmp.next = cur.next;
            cur.next = tmp;
            cur = cur.next.next;
        }
        cur = head;
        while (cur != null) {
            if (cur.random != null) {
                cur.next.random = cur.random.next;
            }
            cur = cur.next.next;
        }

        Node odd = head, even = head.next;
        Node res = head.next;
        while (true) {
            odd.next = even.next;
            odd = odd.next;
            if (odd == null) {
                break;
            }
            even.next = odd.next;
            even = even.next;
            if (even == null) {
                break;
            }
        }
        return res;
    }
}
```

