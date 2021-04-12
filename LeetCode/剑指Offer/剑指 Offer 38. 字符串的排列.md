### [剑指 Offer 38. 字符串的排列](https://leetcode-cn.com/problems/zi-fu-chuan-de-pai-lie-lcof/)

### 题目

输入一个字符串，打印出该字符串中字符的所有排列。

你可以以任意顺序返回这个字符串数组，但里面不能有重复元素。

### 思路

* DFS生成字符串的全排列
    * 确定第$i$个字符时，将$x \in [i,n]$个字符交换
    * 确定第$i$ 个字符时，将$vis[x]=false\ and x\neq i$ 字符交换
* 剪枝去重
    * 字符串每个位置设置一个`HashSet`，确保每种字符只在当前位置固定一次
    * 也可将最后生成的字符串加入到`HashSet`中去重

### AC代码

```java
import java.util.*;

class Solution {
    private List<String> res = new LinkedList<String>();
    private char[] chs;
    public String[] permutation(String s) {
        chs = s.toCharArray();
        dfs(0);
        return res.toArray(new String[res.size()]);
    }
    public void dfs(int x) {
        if (x == chs.length) {
            res.add(String.valueOf(chs));
            return ;
        }
        HashSet<Character> set = new HashSet<Character>();
        for (int i = x; i < chs.length; i++) {
            if (set.contains(chs[i])) {
                continue;
            }
            set.add(chs[i]);
            swap(x, i);
            dfs(x + 1);
            swap(x, i);
        }
    }
    public void swap(int a, int b) {
        char tmp = chs[a];
        chs[a] = chs[b];
        chs[b] = tmp;
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(Arrays.toString(sol.permutation("abc")));
    }
}

```

