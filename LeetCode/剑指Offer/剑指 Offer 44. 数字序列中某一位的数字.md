### [剑指 Offer 44. 数字序列中某一位的数字](https://leetcode-cn.com/problems/shu-zi-xu-lie-zhong-mou-yi-wei-de-shu-zi-lcof/)

### 题意

数字以0123456789101112131415…的格式序列化到一个字符序列中。在这个序列中，第5位（从下标0开始计数）是5，第13位是1，第19位是4，等等。

请写一个函数，求任意第n位对应的数字。

### 思路

1. 先求出n所在数位的数字的位数
    ![数位数量](Pict/202103300705_剑指Offer44.png "opt title")
    观察上表，可以得出数位数量`count`,位数`width`,数字数量`base`的关系为 
    $$count=9\times base \times width$$
    
    ```java
    while (width * base * 9< n) {
      n -= 9 * base * width;
      base *= 10;
      width++;
    }
    ```
2. 求出第n位数位所在的数字
    ```java
    long num = base + (n - 1) / width;
    ```
3. 求出所求数位在哪一位
    ```java
    n = (n - 1) % (width);
    return Long.toString(num).charAt(n) - '0';
    ```
### AC代码

```java
class Solution {
  public static int findNthDigit(int n) {
    long base = 1;
    int width = 1;
    while (width * base * 9< n) {
      n -= 9 * base * width;
      base *= 10;
      width++;
    }
    long num = base + (n - 1) / width;
    n = (n - 1) % (width);
    return Long.toString(num).charAt(n) - '0';
  }
}
```

