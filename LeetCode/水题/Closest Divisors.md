### [Closest Divisors](https://leetcode-cn.com/problems/closest-divisors/)

### 错误

枚举$[1,\sqrt{n}]$ 处的数据，而不是枚举$[\sqrt{n},n]$处的数据。$[1,\sqrt{n}]$的数据量更加小。

### AC代码

```java
class Solution {

    int[] ans = new int[2];
    int diff = -1;

    public int[] closestDivisors(int num) {

        find(num + 1);
        find(num + 2);

        return this.ans;

    }

    public void find(int num) {

        int a = (int) Math.ceil(Math.sqrt(num));

        int p = 0, q = 0;

        for (int i = 1; i <= a; i++) {
            if ((num) % i == 0) {
                p = i;
                q = num / i;
                if (diff == -1)
                    diff = Math.abs(p - q);
                if (Math.abs(p - q) <= diff) {
                    this.ans[0] = p;
                    this.ans[1] = q;
                    // System.out.println(p + "  " + q);
                    diff = Math.abs(this.ans[0] - this.ans[1]);
                }
            }
        }

    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        int[] ans = solution.closestDivisors(123);
        System.out.println(ans[0] + "  " + ans[1]);
    }
}
```



