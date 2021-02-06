### [斐波那契数列](https://leetcode-cn.com/problems/fei-bo-na-qi-shu-lie-lcof/)

写一个函数，输入 n ，求斐波那契（Fibonacci）数列的第 n 项。斐波那契数列的定义如下：

F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
斐波那契数列由 0 和 1 开始，之后的斐波那契数就是由之前的两数相加而得出

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1



### 思路

使用**模运算**构成一个环，压缩求解数组的空间

### AC代码

```java
class Solution {
    public int fib(int n)
    {
        int []arr = new int[] {0, 1, 0};
        for(int i = 2; i <= n; i++) {
            arr[i % 3] = arr[(i - 1) % 3] + arr[(i - 2) % 3];
            arr[i % 3] = arr[i % 3] % 1000000007;
        }
        return arr[n % 3];
    }
}
```

