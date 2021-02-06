#### [重建二叉树](https://leetcode-cn.com/problems/zhong-jian-er-cha-shu-lcof/)

输入某二叉树的前序遍历和中序遍历的结果，请重建该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

### 思路

**递归法重建二叉树**

1. `Map<Integer,Integer>`来确定根节点在中序序列中的位置，以区分左右子树，`indexMap.put(inorder[i],i)`
2. 计算左右子树的的结点个数，`leftNodes=inorderStart-rootIndex` ， `rightNodes=inorderEnd-rootIndex`





**迭代法重建二叉树**

​		用栈保存已访问的前序序列，设置指向中序序列的元素的指针。如果栈顶元素和中序序列指针所指的元素不相等，那么当前元素为栈顶元素的左孩子，并将当前元素加入到栈中。如果相等，栈中的先序序列退栈，中序指针向后移动，直到最后一个不相等的元素。将当前元素设置为栈顶元素的右孩子，将当前元素加入到栈中。



### AC代码

**递归重建**

```java
class Solution {
    public TreeNode buildTree(int[] preorder, int[] inorder)
    {
        if(preorder.length == 0) {
            return null;
        }
        Map<Integer, Integer> indexMap = new HashMap<Integer, Integer>();
        for(int i = 0; i < inorder.length; i++) {
            indexMap.put(inorder[i], i);
        }
        int len = preorder.length;
        TreeNode root = buildTree(preorder, inorder, 0, len - 1, 0, len - 1, indexMap);
        return root;
    }
    public TreeNode buildTree(int[] preorder, int[] inorder, int preorderStart, int preorderEnd, int inorderStart, int inorderEnd, Map<Integer, Integer> indexMap)
    {
        if(preorderStart > preorderEnd) {
            return null;
        }
        TreeNode root = new TreeNode(preorder[preorderStart]);
        int rootIndex = indexMap.get(preorder[preorderStart]);
        int leftNodes = rootIndex - inorderStart, rightNodes = inorderEnd - rootIndex;
        root.left = buildTree(preorder, inorder, preorderStart + 1, preorderStart + leftNodes, inorderStart, rootIndex - 1, indexMap);
        root.right = buildTree(preorder, inorder, preorderEnd - rightNodes + 1, preorderEnd, rootIndex + 1, inorderEnd, indexMap);
        return root;
    }
}

```

**迭代重建**

```java
class Solution {
    public TreeNode buildTree(int[] preorder, int[] inorder)
    {
        if(preorder == null || preorder.length == 0) {
            return null;
        }
        int inorderIndex = 0;
        TreeNode root = new TreeNode(preorder[0]);
        Stack<TreeNode> stack = new Stack<TreeNode>();
        stack.push(root);
        for(int i = 1; i < preorder.length; i++) {
            TreeNode node = stack.peek();
            if(inorder[inorderIndex] != node.val) {
                node.left = new TreeNode(preorder[i]);
                stack.push(node.left);
            }
            else {
                while(!stack.isEmpty() && inorder[inorderIndex] == stack.peek().val) {
                    node = stack.pop();
                    inorderIndex++;
                }
                node.right = new TreeNode(preorder[i]);
                stack.push(node.right);
            }
        }
        return root;
    }
}
```

