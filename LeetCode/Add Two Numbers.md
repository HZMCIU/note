### [Add Two Numbers](https://leetcode.com/problems/add-two-numbers/)

#### 题意

将链表中的两个数相加

#### 反思

+ **如何编写程序更加简洁**
  + 为结果创建一个新的链表来存储，不使用传入的参数
  + `while (p != null || q != null)` 和`x = (p != null) ? p.val : 0;` 组合来遍历两个链表的所有结点
  + 创建一个空的链表头`dummyHead`来同步
  + 使用临时变量`x` `y`来替代`p.val`和`q.val`

#### 标程

```java
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    ListNode dummyHead = new ListNode(0);
    ListNode p = l1, q = l2, curr = dummyHead;
    int carry = 0;
    while (p != null || q != null) {
        int x = (p != null) ? p.val : 0;
        int y = (q != null) ? q.val : 0;
        int sum = carry + x + y;
        carry = sum / 10;
        curr.next = new ListNode(sum % 10);
        curr = curr.next;
        if (p != null) p = p.next;
        if (q != null) q = q.next;
    }
    if (carry > 0) {
        curr.next = new ListNode(carry);
    }
    return dummyHead.next;
}
```

#### 代码

```cpp
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode p=new ListNode(0),prev=null;
        ListNode result=p;
        int carry=0;
        while(l1!=null&&l2!=null){
            p.val=(l1.val+l2.val+carry)%10;
            carry=(l1.val+l2.val+carry)/10;
            p.next=new ListNode(0);
            prev=p;
            p=p.next;
            l1=l1.next;
            l2=l2.next;
        }
        while(l1!=null){
            p.val=(l1.val+carry)%10;
            carry=(l1.val+carry)/10;
            p.next=new ListNode(0);
            l1=l1.next;
            prev=p;
            p=p.next;
        }
        while(l2!=null){
            p.val=(l2.val+carry)%10;
            carry=(l2.val+carry)/10;
            p.next=new ListNode(0);
            l2=l2.next;
            prev=p;
            p=p.next;
        }
        if(carry==0){
            prev.next=null;
        }else{
            p.val=1;
        }
        return result;
    }
}
```

