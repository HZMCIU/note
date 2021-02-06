### [二维数组中的查找](https://leetcode-cn.com/problems/er-wei-shu-zu-zhong-de-cha-zhao-lcof/)

## 题目

在一个 $n * m $的二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个高效的函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

## 思路

由题意可得，矩阵从上到下，从左到右，都是递增的。在**一维数组**中，递增序列可以使用 **二分查找** 快速定位元素，但题目中给出的是二维矩阵，且虽然二维矩阵在内存中的表示是一维形式的，但这个数组也并不是递增的，也无法应用二分查找

常用的快速查找算法有，二叉树搜索，哈希等。二叉搜索树有 **左子结点小于根节点，右子节点大于根节点** 的特点，也即，根节点到左子节点为递减序列，根节点到右子节点为递增序列，**递减序列反过来就是递增序列了**。这就符合题目给出的条件了，从**右上角**出发开始按照二叉搜索树的方法进行搜索即可。



## AC代码

```java
class Solution {
    public boolean findNumberIn2DArray(int[][] matrix, int target)
    {
        if(matrix.length == 0)
            return false;
        int rows = matrix.length, cols = matrix[0].length;
        int row = 0, col = cols - 1;
        while(row < rows && col >= 0) {
            if(matrix[row][col] == target) {
                return true;
            }
            else if(matrix[row][col] > target) {
                col -= 1;
            }
            else if(matrix[row][col] < target) {
                row += 1;
            }
        }
        return false;
    }
}
```

