### [剑指 Offer 64. 求1+2+…+n](https://leetcode-cn.com/problems/qiu-12n-lcof/)
### 题目

求 `1+2+...+n` ，要求不能使用乘除法、for、while、if、else、switch、case等关键字及条件判断语句（A?B:C）。

### 思路

使用 **逻辑短路** 和 **递归**　来解决

### AC代码

```java
class Solution {
    public static int sumNums(int n) {
        int ret = 0;
        boolean flag = (n > 0) && (ret = sumNums(n - 1)) > 0;
        return n + ret;
    }
    public static void main(String[] args) {
        System.out.println(sumNums(9));
    }
}
```

