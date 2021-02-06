#### [环形链表 II](https://leetcode-cn.com/problems/linked-list-cycle-ii/)

### 思路

定义快指针`fast` 和慢指针`slow`，`slow`走一步，`fast`走两步。若链表中存在环，则`slow`和`fast`就会相遇，相遇点为`intersect`。相遇后，从相遇点`intersect`出发，`slow`从头节点出发，intersect和slow相遇的结点为，环的入口。

### AC代码

```cpp
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution
{
public:
    ListNode *detectCycle(ListNode *head)
    {
        ListNode *slow = head, *fast = head, *intersect = head;

        while (fast && fast->next)
        {
            slow = slow->next;
            fast = fast->next->next;
            if (fast == slow)
                break;
        }

        if (!fast || !fast->next)
            return NULL;

        intersect = slow;
        slow = head;
        while (slow != intersect)
        {
            intersect = intersect->next;
            slow = slow->next;
        }
        return slow;
    }
};

```

