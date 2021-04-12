### [剑指 Offer 33. 二叉搜索树的后序遍历序列](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-hou-xu-bian-li-xu-lie-lcof/)

### 题目

输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历结果。如果是则返回 `true`，否则返回 `false`。假设输入的数组的任意两个数字都互不相同。

### 思路

#### 递归分治

**1. 中序后序建树**
二叉搜索树的中序序列是有序递增的，故将数组进行排序可得到中序序列。使用**中序后序遍历序列**可以唯一确定一颗二叉树，如果无法构建二叉树，说明不是二叉树的后序遍历序列。

**2.递归划分**
* 二叉树的后序遍历序列为“左子树 右子树 根”，左子树中的所有结点的值小于根，右子树的所有节点大于根。
* 根据这个性质，划分左子树和右子树，验证左子树中所有节点都小于根，右子树所有结点都大于根。
* 假设后序序列`postorder[i,j]`，`postorder[j]`为树的根节点
    * 找到第一个结点`postorder[m]>postorder[j]`，则`postorder[i,m-1]`为左子树结点，`postorder[m,j-1]`为右子树结点
    * 验证所有`postorder[m,j-1]>postorder[j]`，如果满足条件，则继续递归验证，否则该序列不是二叉搜索树

#### [[剑指 Offer 07. 重建二叉树|单调栈]]

* 二叉搜索树的后序序列为 “根 右子树 左子树”，相当于在先序遍历中先遍历右子树，再遍历左子树
    * 在遍历过程中，访问右子树时，后序序列中的值越来越大。当值变小时，便开始访问左子树
* 根据后序遍历过程中数值变化的规律，使用单调栈来模拟访问的过程
    * 当前元素`postorder[i]`大于栈顶元素时，说明正在访问右子树，将元素加入到栈中。
    * 当前元素`postorder[i]`小于栈顶元素时，说明正在访问左子树，将栈中所有大于`postorder[i]`的元素弹出（右子树中的结点）。并将`postorder[i]`加入到栈中。
    * <font color="red">**使用`prev`记录上一个根节点元素，初始化为正无穷。如果`postorder[i]>prev`，那么说明不是后序遍历序列。**</font>
    
### AC代码

**递归分治**

```java
class Solution {
    public boolean verifyPostorder(int[] postorder) {
        return verify(postorder, 0, postorder.length - 1);
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.verifyPostorder(new int[] {1, 6, 3, 2, 5}));
        System.out.println(sol.verifyPostorder(new int[] {1, 3, 2, 6, 5}));
    }
    public boolean verify(int[] postorder, int l, int r) {
        if (l>=r) {
            return true;
        }
        int m = l;
        while (m < r && postorder[m] <= postorder[r]) {
            m++;
        }
        int ptr = m;
        while (ptr < r && postorder[ptr] > postorder[r]) {
            ptr++;
        }

        return ptr == r && verify(postorder, l, m - 1) && verify(postorder, m, r - 1);
    }
}
```


**单调栈**

```java
import java.util.*;
class Solution {
    public boolean verifyPostorder(int[] postorder) {
        Stack<Integer> stack = new Stack<Integer>();

        int prev = Integer.MAX_VALUE;
        for (int i = postorder.length - 1; i >= 0; i--) {
            if (prev < postorder[i]) {
                return false;
            }
            while (!stack.isEmpty() && stack.peek() > postorder[i]) {
                prev = stack.pop();
            }
            stack.push(postorder[i]);
        }
        return true;
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.verifyPostorder(new int[] {1, 6, 3, 2, 5}));
        System.out.println(sol.verifyPostorder(new int[] {1, 3, 2, 6, 5}));
    }
}
```
