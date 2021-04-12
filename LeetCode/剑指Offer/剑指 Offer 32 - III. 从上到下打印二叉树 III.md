### [剑指 Offer 32 - III. 从上到下打印二叉树 III](https://leetcode-cn.com/problems/cong-shang-dao-xia-da-yin-er-cha-shu-iii-lcof/)

### 题目

请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

例如:  
给定二叉树: `[3,9,20,null,null,15,7]`,

### 思路

* `res`链表中元素个数为奇数，说明现为奇数层；`res`链表中元素个数为偶数，说明现为偶数层（从0开始）
* 使用双向链表来添加层序遍历结果
    * 偶数层，从左到右添加元素
    * 奇数层，从右到左添加元素

### AC代码

```java
import java.util.*;
class Solution {
    public List<List<Integer>> levelOrder(TreeNode root) {
        if (root == null) {
            return new ArrayList<List<Integer>>();
        }
        List<List<Integer>> res = new ArrayList<>();
        Queue<TreeNode> que = new LinkedList<TreeNode>();
        que.add(root);
        while (!que.isEmpty()) {
            LinkedList<Integer> tmp = new LinkedList<Integer>();
            for (int i = que.size(); i > 0; i--) {
                TreeNode node = que.poll();
                if (res.size() % 2 == 0) {
                    tmp.addLast(node.val);
                } else {
                    tmp.addFirst(node.val);
                }
                if (node.left != null) {
                    que.add(node.left);
                }
                if (node.right != null) {
                    que.add(node.right);
                }
            }
            res.add(tmp);
        }
        return res;
    }
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}

```

