### [剑指 Offer 14- I. 剪绳子](https://leetcode-cn.com/problems/jian-sheng-zi-lcof/)

### 题意

给你一根长度为 n 的绳子，请把绳子剪成整数长度的 m 段（m、n都是整数，n>1并且m>1），每段绳子的长度记为 `k[0],k[1]...k[m-1] `。请问 `k[0]*k[1]*...*k[m-1]` 可能的最大乘积是多少？例如，当绳子的长度是8时，我们把它剪成长度分别为2、3、3的三段，此时得到的最大乘积是18。

### 思路

假设将长度为$n$的绳子分解为$a$段，即，$n=n_1+n_2+\cdots+n_a$ 。本题等价于求解$\max(n_1\times n_2 \times \cdots \times n_a)$

由算数几何均值不等式可得，
$$
\frac{1}{a}\times (n_1+n_2+\cdots+n_a) \ge \sqrt[a]{n_1\cdot n_2\cdots n_a} \quad 当且仅当 n_1=n_2=\cdots=n_a时取等
$$
故 $\max(n_1\times n_2 \times \cdots \times n_a)=\left(\frac{n}{a}\right)^{a}$ ，$a$段绳子的单端长度为$x$ ,即$n=ax$。等式转化为
$$
\max(n_1,n_2,\cdots,n_a)=\left(\frac{n}{a}\right)^{a}=f(x)=\left(x^{\frac{1}{x}}\right)^n
$$
$令g(x)=x^{\frac{1}{x}}$ ，先对$g(x)$求对数，再求导得
$$
g'(x)=g(x) \times \frac{1-\ln x}{x^2}
$$
令$g'(x)=0$ 得$x=e=2.7$，$x$为整数值，故由两个待选值2,3。通过举例来进行判定，$6=2+2+2,  2*2*2=8$  ，$6=3+3,3*3=9$ ，$8<9$ ，故$x=3$为所求得x得整数解。<font color="red">即要将绳子尽可能多地分解为长度为3的片段</font>。

+ 如果长度$n>4$ ，将绳子切出长度为3的片段
+ 如果长度$n=4$，分解为长度为$(2,2)$的片段，是比分解为长度为$(1,3)$片段更优的解
+ 如果长度$n<4$，直接分解为$(1,n-1)$两个片段

### AC代码

```java
class Solution {
    public int cuttingRope(int n) {
        if (n < 4)
            return n - 1;
        int a = n / 3, b = n % 3;
        if (b == 0)
            return (int) Math.pow(3, a);
        else if (b == 1)
            return (int) Math.pow(3, a - 1) * 4;
        else
            return (int) Math.pow(3, a) * 2;
    }
}
```

