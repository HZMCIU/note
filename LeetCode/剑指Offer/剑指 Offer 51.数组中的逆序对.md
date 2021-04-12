### [数组中的逆序对](https://leetcode-cn.com/problems/shu-zu-zhong-de-ni-xu-dui-lcof/)

### 题目

在数组中的两个数字，如果前面一个数字大于后面的数字，则这两个数字组成一个逆序对。输入一个数组，求出这个数组中的逆序对的总数。

### 解题思路

#### **归并排序**

归并排序将数组分割为若干**有序的子段**，并进行两两“向上”合并。

在一次归并过程中，第一段数组和第二段数组**均为有序的**，只需要统计归并过程中数组中==“失序”==的数组元素就能够得到逆序对数。假设`p1`和`p2`分别指向第一段数组A和第二段数组B的起始位置，且数组AB归并到数组C中。则存在两种不同的统计方式。

+ 统计方式1：倘若$A[p1]<B[p2]$，选择$A[p1]$作为下一个归并到数组C中的元素，易知$A[p1]>B[mid+1\cdots p2-1]$，所以一共有$p2-(mid+1)$个逆序的数。当$A或B$中元素归并完毕时，对剩余元素计算逆序数对，应进行分类讨论。
	+ $p1=mid 且 p2<right$，此刻的右半部分数组元素$B[p2\cdots right]$还没有进行合并，这几个元素为归并后数组的**最大值**，不存在逆序数对。
	+ $p1<left 且 p2=right$，此刻的左半部分数组元素$A[p1\cdots mid]$尚未归并，为归并后数组的**最大值**，**与右半部分的所有元素构成逆序数对。**
+ 统计方式2：倘若$A[p1]>B[p2]$，选择$B[p2]$作为下一个归并到数组C中段元素，易知$A[p1 \cdots mid]>B[p2]$，所以一共有$mid-p1+1$个逆序的元素。当$A或B$中元素归并完毕时，对剩余元素计算逆序数对，应进行分类讨论。
	+ $p1=mid 且 p2<right$，理由同上，不存在逆序数对
	+ $p1<left 且 p2=right$， 此时，左半部分的元素$A[p1\cdots mid]$与右半部分数组全部元素构成逆序数对。<font color="red">但是当$A[p1]>B[p2]$，$mid-p1+1$已经计算了这部分的逆序数对，</font>，不需要重复计算。

#### **树状数组**

使用`二分查找+排序`来对数组进行离散化，使用桶来保存元素的信息，桶中保存元素出现的次数，前缀和即表示为所有小于该元素的个数。

从后向前进行操作，假设目前的遍历的元素为$a_i$，利用前缀和，查找所有小于$a_i$的个数，然后将$a_i$加入到树状数组中去。



### AC代码

**归并排序**

```java
class Solution {
    private static int[] temp = null;

    public static int reversePairs(int[] nums) {
        temp = new int[nums.length];
        int res = mergeSort(nums, 0, nums.length - 1);
        return res;
    }

    public static int mergeSort(int[] nums, int left, int right) {
        if (left >= right)
            return 0;
        int mid = left + (right - left) / 2;
        int leftPairs = mergeSort(nums, left, mid);
        int rightPairs = mergeSort(nums, mid + 1, right);

        int crossPairs = merge(nums, left, mid, right);

        return leftPairs + crossPairs + rightPairs;
    }

    public static int merge(int nums[], int left, int mid, int right) {
        int p1 = left, p2 = mid + 1;
        for (int i = left; i <= right; i++) {
            temp[i] = nums[i];
        }
        int cnt = left;
        int ans = 0;
        while (p1 <= mid && p2 <= right) {
            if (temp[p1] <= temp[p2]) {
                nums[cnt] = temp[p1];
                p1++;
                // 统计方法1
                ans += p2 - (mid + 1);
            } else {
                nums[cnt] = temp[p2];
                p2++;
                // 统计方法2
                // ans += (mid-p1+1);
            }
            cnt++;
        }
        if (p1 <= mid) {
            while (p1 <= mid) {
                nums[cnt++] = temp[p1++];
                // 统计方法1
                ans += (p2 - mid - 1);
            }
        }
        if (p2 <= right) {
            while (p2 <= right) {
                nums[cnt++] = temp[p2++];
                // 统计方法2
                // ans += (mid-p1+1);
            }
        }
        return ans;
    }
}
```

**树状数组**

```cpp
class Solution {
    public static int reversePairs(int[] nums) {
        int n = nums.length;
        int[] temp = new int[n];
        System.arraycopy(nums, 0, temp, 0, n);
        Arrays.sort(temp);
        for (int i = 0; i < n; i++) {
            nums[i] = Arrays.binarySearch(temp, nums[i]) + 1;
        }
        BIT bit = new BIT(nums.length);
        int ans = 0;
        for (int i = n - 1; i >= 0; i--) {
            ans += bit.query(nums[i] - 1);
            bit.update(nums[i]);
        }
        return ans;
    }
}

class BIT {
    private int[] tree;
    private int n;

    BIT(int n) {
        tree = new int[n + 1];
        this.n = n;
    }

    public int lowbit(int x) {
        return x & (-x);
    }

    public void update(int x) {
        for (int i = x; i <= n; i += lowbit(i)) {
            ++tree[i];
        }
    }

    public int query(int x) {
        int res = 0;
        for (int i = x; i > 0; i -= lowbit(i)) {
            res += tree[i];
        }
        return res;
    }
}
```