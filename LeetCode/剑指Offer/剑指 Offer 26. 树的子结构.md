### [剑指 Offer 26. 树的子结构](https://leetcode-cn.com/problems/shu-de-zi-jie-gou-lcof/)

### 题意

输入两棵二叉树A和B，判断B是不是A的子结构。(约定空树不是任意一个树的子结构)
B是A的子结构， 即 A中有出现和B相同的结构和节点值。

### 思路

1. 首先遍历二叉树A，找到与B的根节点相同的结点
2. 判断A的子树和二叉树B是否相等

### AC代码

```java
public class Solution {
    public boolean isSubStructure(TreeNode A, TreeNode B) {
        if (A != null && B != null) {
            boolean res = false;
            if (A.val == B.val) {
                res = dfs(A, B);
            }
            return res || isSubStructure(A.left, B) || isSubStructure(A.right, B);
        }
        return false;
    }
    public boolean dfs(TreeNode a, TreeNode b) {
        if (a != null && b != null && a.val == b.val) {
            return dfs(a.left, b.left) && dfs(a.right, b.right);
        } else if (b == null) {
            return true;
        } else {
            return false;
        }
    }
}
```

