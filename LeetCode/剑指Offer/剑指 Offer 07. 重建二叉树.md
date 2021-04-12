### [重建二叉树](https://leetcode-cn.com/problems/zhong-jian-er-cha-shu-lcof/)

输入某二叉树的前序遍历和中序遍历的结果，请重建该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。

### 思路

**递归法重建二叉树**

1. `Map<Integer,Integer>`来确定根节点在中序序列中的位置，以区分左右子树，`indexMap.put(inorder[i],i)`
2. 计算左右子树的的结点个数，`leftNodes=inorderStart-rootIndex` ， `rightNodes=inorderEnd-rootIndex`

**迭代法重建二叉树**

用栈保存已访问的前序序列，设置指向中序序列的元素的指针。如果栈顶元素和中序序列指针所指的元素不相等，那么当前元素为栈顶元素的左孩子，并将当前元素加入到栈中。如果相等，栈中的先序序列退栈，中序指针向后移动，直到最后一个不相等的元素。将当前元素设置为栈顶元素的右孩子，将当前元素加入到栈中。

堆栈`stack`维护先序序列，且栈中的元素是暂未访问右孩子的结点。而`inorder`数组维护的是已经访问左孩子，即将访问右孩子的结点。如果`stack`的栈顶元素和`inorder`出现重合，说明重合结点的左子树已经遍历完成，下一步开始遍历右子树。栈中元素开始退栈，`inorder`数组指针右移，直至二者不出现重合元素，然后遍历右子树。

> 我们用一个栈 `stack `来维护「当前节点的所有还没有考虑过右儿子的祖先节点」，栈顶就是当前节点。也就是说，**只有在栈中的节点才可能连接一个新的右儿子**。同时，我们用一个指针 `index `指向中序遍历的某个位置，初始值为 0。`index `对应的节点是「**当前节点不断往左走达到的最终节点**」
>
> 我们遍历 10，这时情况就不一样了。我们发现 `index `恰好指向当前的栈顶节点 4，也就是说 4 没有左儿子，**那么 10 必须为栈中某个节点的右儿子**。那么如何找到这个节点呢？<span style="color:red;">栈中的节点的顺序和它们在前序遍历中出现的顺序是一致的，而且每一个节点的右儿子都还没有被遍历过，那么这些节点的顺序和它们在中序遍历中出现的顺序一定是相反的。</span>
>
> 因此我们可以把 `index `不断向右移动，并与栈顶节点进行比较。如果 `index `对应的元素恰好等于栈顶节点，那么说明我们在中序遍历中找到了栈顶节点，所以将 `index `增加 1 并弹出栈顶节点，直到 `index `对应的元素不等于栈顶节点。按照这样的过程，<span style="color:red">我们弹出的最后一个节点 `x` 就是 `10 `的双亲节点，这是因为 `10` 出现在了 x 与 x 在栈中的下一个节点的中序遍历之间，因此 10 就是 x 的右儿子。</span>
>

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

