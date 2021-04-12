### [剑指 Offer 36. 二叉搜索树与双向链表](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-yu-shuang-xiang-lian-biao-lcof/)

### 题目

输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的循环双向链表。要求不能创建任何新的节点，只能调整树中节点指针的指向。

### 思路

* 二叉搜索树的中序排列是有序的，故在中序遍历的过程中调整指针的位置，得到顺序排列的双向链表
    * `prev`，保存中序遍历的前一个结点。`head`，保存二叉搜索树最左下角的结点，即顺序链表的第一个结点
    * 中序遍历的顺序为“左子树 根 右子树”，故遍历完左子树时，调整前驱结点和根节点的关系
    * 完成二叉树的中序遍历后，调整链表的头节点和尾结点指针的指向，以构成双向链表

### AC代码

```java
public class Solution {
    Node prev = null, head = null;
    public Node treeToDoublyList(Node root) {
        if (root == null) {
            return null;
        }
        dfs(root);
        head.left = prev;
        prev.right = head;
        return head;
    }
    public void dfs(Node root) {
        if (root == null) {
            return ;
        }
        dfs(root.left);
        if (prev != null) {
            prev.right = root;
        } else {
            head = root;
        }
        root.left = prev;
        prev = root;
        dfs(root.right);
    }
}
```

