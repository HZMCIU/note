### [剑指 Offer 56 - I. 数组中数字出现的次数](https://leetcode-cn.com/problems/shu-zu-zhong-shu-zi-chu-xian-de-ci-shu-lcof/)

### 题意

一个整型数组 `nums` 里除两个数字之外，其他数字都出现了两次。请写程序找出这两个只出现一次的数字。要求时间复杂度是O(n)，空间复杂度是O(1)。

### 思路

数组中只有一个数出现了一次，其余数全部出现两次，那么对全体数组元素进行异或，得到的结果就是出现只出现一次的数。  **如果能够将数组分为两组，每组中只有一个元素出现一次，其余元素均只出现一次**。

将数组元素进行分组，假设只出现一次的元素分别为$a,b$ 
* 对数组所有元素进行异或，得到$x$ ，$x=a \oplus b$ ，其余的元素因为两次异或全部抵消了
* 找到$x$ 最低为1的位$x_{i}$，也即`lowbit(x)`，$x_{i}=1$ 说明 $a_{i}\neq b_{i}$ 。 **<font color="red">根据第$i$ 位取值的不同，对数组中的元素进行分类</font>**
    * $a_{i}\neq b_{i}$ ，所以$a,b$ 会被分到不同的组中
    * 出现两次的元素不会被分到不同的组中，而是会被分到同一组中，因为他们最低位相同
    * $lowbit(x)=-x\&x$ [[剑指 Offer 51.数组中的逆序对#树状数组|lowbit]]

### AC代码

```java
class Solution {
    public static int[] singleNumbers(int[] nums) {
        int n = 0;
        for (int i = 0; i < nums.length; i++ ) {
            n ^= nums[i];
        }
        int div = (-n) & n;
        int a = 0, b = 0;
        for (int i = 0; i < nums.length; i++) {
            if ((nums[i] & div) != 0) {
                a ^= nums[i];
            } else {
                b ^= nums[i];
            }
        }
        return new int[] {a, b};
    }
    public static void main(String[] args) {
        System.out.println(Arrays.toString(singleNumbers(new int[] {4, 1, 4, 6})));
        System.out.println(Arrays.toString(singleNumbers(new int[] {6, 5, 5, 9, 10, 9, 4, 10})));
    }
}
```
