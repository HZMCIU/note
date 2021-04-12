### [剑指 Offer 43. 1～n 整数中 1 出现的次数](https://leetcode-cn.com/problems/1nzheng-shu-zhong-1chu-xian-de-ci-shu-lcof/)

### 题目
输入一个整数 n ，求$1～n$这n个整数的十进制表示中1出现的次数。
例如，输入12，1～12这些整数中包含1 的数字有1、10、11和12，1一共出现了5次。
### 思路

设整数 $n$的形式为 $n_{x}n_{x-1}\cdots n_2n_1$
+ $n_i$为当前位，记为 **cur**
+ $n_in_{i-1}\cdots n_2n_1$为低位，记为 **low**
+ $n_xn_{x-1}\cdots n_{i+2}n_{i+1}$，记为 **high**
+ $10^i$称为位因子，记为 **digit**

根据当前位**cur**的不同，分为三种情况进行计算
+ $cur=0$时 ，$1$出现的次数：$high\times digit$
	![cur=0](Pict/202103281536_剑指Offer43_1.png)
+ $cur=1$时，$1$出现的次数：$high\times digit + low + 1$
	![cur=1](Pict/202103281536_剑指Offer43_2.png)
+ $cur=2\cdots 9$时，$1$出现的次数：$(high+1)\times digit$
	![cur>1](Pict/202103281536_剑指Offer43_3.png)
	
### 总结

手动计算 $0 \sim 999$中含1的个数，然后观察得到计算的规律

### AC代码

```java
class Solution {
    public static int countDigitOne(int n) {
        int high = n / 10, low = 0, digit = 1, cur = n % 10;
        int ans = 0;
        while (high != 0 || cur != 0) {
            if (cur == 0)
                ans += high * digit;
            else if (cur == 1)
                ans += high * digit + low + 1;
            else
                ans += (high + 1) * digit;
            low += digit * cur;
            cur = high % 10;
            high /= 10;
            digit *= 10;
        }
        return ans;
    }
}
```