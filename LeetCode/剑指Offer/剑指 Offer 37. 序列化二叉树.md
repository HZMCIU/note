### [剑指 Offer 37. 序列化二叉树](https://leetcode-cn.com/problems/xu-lie-hua-er-cha-shu-lcof/)

### 题意

请实现两个函数，分别用来序列化和反序列化二叉树。

### 思路

本题使用 **层序遍历** 进行序列化和反序列化。但是使用常用的层序遍历（不将`null`加入到数组中），无法正确还原二叉树。
![二叉树](Pict/202104011705_剑指Offer37.png "二叉树")

例如，上图二叉树，层序遍历的序列为 `[1,2,3,4,5]`，但是如果也使用层序遍历还原二叉树，无法正确还原二叉树。如下图所示
![还原错误](Pict/202104011733_剑指Offer37.svg "还原错误")

原因在于 **还原2号结点的子节点时，无法判断2号结点的子节点是否为`null`**。故在层序遍历进行序列化时，需要将`null`子节点也加入到序列化数组中。例如，上图二叉树，层序遍历的序列为 `[1,2,3,null,null,4,5,null,null,null,null]`

1. 序列化
    层序遍历二叉树，序列化数组中加入为`null`的结点
2. 反序列化
    * 设置指针`ptr=1`指向序列化数组。设置队列`que`保存 **已加入二叉树，但子节点尚未确定**的结点
    * 每将一个队首结点的（左右）子节点加入到二叉树中，`ptr+=1`。如果子节点非空，将子节点加入到队列中。
### AC代码

```java
public class Codec {

    // Encodes a tree to a single string.
    public String serialize(TreeNode root) {
        if (root == null) {
            return "[]";
        }
        Queue<TreeNode> que = new LinkedList<TreeNode>();
        que.add(root);
        StringBuilder sb = new StringBuilder("[");
        while (!que.isEmpty()) {
            TreeNode temp = que.poll();
            if (temp == null) {
                sb.append("null,");
            } else if (temp != null) {
                sb.append(temp.val + ",");
                que.add(temp.left);
                que.add(temp.right);
            }
        }
        sb.deleteCharAt(sb.length() - 1);
        sb.append(']');
        return sb.toString();
    }

    // Decodes your encoded data to tree.
    public TreeNode deserialize(String data) {
        if (data.equals("[]")) {
            return null;
        }
        String [] vals = data.substring(1, data.length() - 1).split(",");
        TreeNode root = new TreeNode(Integer.parseInt(vals[0]));
        int ptr = 1;
        Queue<TreeNode> que = new LinkedList<TreeNode>();
        que.add(root);
        while (!que.isEmpty()) {
            TreeNode tmp = que.poll();
            if (vals[ptr].equals("null")) {
                tmp.left = null;
            } else {
                tmp.left = new TreeNode(Integer.parseInt(vals[ptr]));
                que.add(tmp.left);
            }
            ptr++;
            if (vals[ptr].equals("null")) {
                tmp.right = null;
            } else {
                tmp.right = new TreeNode(Integer.parseInt(vals[ptr]));
                que.add(tmp.right);
            }
            ptr++;
        }
        return root;
    }
    public static void main(String[] args) {

    }
}
```
