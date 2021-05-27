### [剑指 Offer 66. 构建乘积数组](https://leetcode-cn.com/problems/gou-jian-cheng-ji-shu-zu-lcof/)

### 题目

给定一个数组 `A[0,1,…,n-1]`，请构建一个数组 `B[0,1,…,n-1]`，其中 `B[i]` 的值是数组 `A` 中除了下标 `i` 以外的元素的积, 即 `B[i]=A[0]×A[1]×…×A[i-1]×A[i+1]×…×A[n-1]`。不能使用除法。

### 思路

将表格根据主对角线分为上三角和下三角两部分，主对角线为1，迭代计算上三角和下三角，即可不适用乘法获得乘积

![乘积表](./Pict/202104121326_剑指Offer66.png "opt title")

* 迭代计算表格的上三角
    * `res[i]=res[i]*a[i-1];res[0]=1`
* 迭代计算表格下三角，使用辅助变量 `tmp`
    * `res[i]*=tmp;tmp*=a[i]`

### AC代码

```java
class Solution {
    public static int[] constructArr(int[] a) {
        int n = a.length;
        if (n == 0) {
            return new int[0];
        }
        int [] res = new int[n];
        res[0] = 1;
        for (int i = 1; i < n; i++) {
            res[i] = res[i - 1] * a[i - 1];
        }
        int tmp = 1;
        for (int i = n - 1; i >= 0; i--) {
            res[i] *= tmp;
            tmp *= a[i];
        }
        return res;
    }
    public static void main(String[] args) {
        System.out.println(Arrays.toString(constructArr(new int[] {1, 2, 3, 4, 5})));
    }
}
```

