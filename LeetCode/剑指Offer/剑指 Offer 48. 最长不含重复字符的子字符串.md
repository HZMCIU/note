### [剑指 Offer 48. 最长不含重复字符的子字符串](https://leetcode-cn.com/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof/)

### 题目

请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。

### 思路

#### 动态规划

* $dp[j]$代表以 $s[j-1]$结尾的不包含重复字母的子串的最大长度。 $s[i]$ 为$s[0.j-1]$ 中和$s[j]$相同的字符。
    * 存在如下状态转移方程
        $$
        dp[j]=\left\{
        \begin{array}{rcl}
           dp[j-1]+1,&  j-1-dp[j-1]>i \quad 字符s[j-1]在dp[j-1]的子串区间之外 \\
           j-i,& j-1-dp[j-1]\le i\quad 字符s[j-1]在dp[j-1]的子串区间内 \\
           dp[j-1]+1, & i=-1,s[j-1]为字符串第一个字符,dp[j-1]=0
        \end{array}
        \right .
        $$
    * 状态转移方程中$j=0$ 可以合并到$dp[j-1]<j-i$
        $$
        dp[j]=\left\{
        \begin{array}{rcl}
           dp[j-1]+1,&  j-1-dp[j-1]>i \\
           j-i,& j-1-dp[j-1]\le i
        \end{array}
        \right .
        $$

    * 求解$dp[j]$只需要$dp[j-1]$，所以可以使用一个变量`tmp`模拟$dp$ 数组，优化空间复杂度

* 使用哈希表，获得重复字符`s[i]`出现的位置

#### 双指针

* 使用哈希表获得最近一次重复字符`s[i]`出现的位置。
* 当右侧添加一个新的元素时，如果左侧出现过重复的字符，那么就将左指针更新到左侧重复字符的后一个位置，计算此时子串的最大值。
* `l=max(dict.getOrDefault(s.charAt(r),-1)+1,l)`，左指针只能向右移动，max函数防止指针向左移动

### AC代码

**动态规划**
```java
class Solution {
    public static int lengthOfLongestSubstring(String s) {
        HashMap<Character, Integer> dict = new HashMap<Character, Integer>();
        int tmp = 0, res = 0;
        for (int j = 1; j <= s.length(); j++) {
            int i = dict.getOrDefault(s.charAt(j - 1), -1);
            tmp = j - 1 - tmp > i ? tmp + 1 : j - 1 - i;
            res = Math.max(tmp, res);
            dict.put(s.charAt(j - 1), j - 1);
        }
        return res;
    }
    public static void main(String[] args) {
        System.out.println(lengthOfLongestSubstring("abcabcbb"));
        System.out.println(lengthOfLongestSubstring("bbbbbb"));
        System.out.println(lengthOfLongestSubstring("pwwkew"));
    }
}
```

**双指针**

```java
class Solution {
    public int lengthOfLongestSubstring(String s) {
        HashMap<Character,Integer> dict=new HashMap<Character,Integer>();
        int n=s.length();
        int i=0,ans=0;
        for (int j=0; j<n; j++) {
            if (dict.containsKey(s.charAt(j))) {
                i=Math.max(i,dict.get(s.charAt(j))+1);
            }
            dict.put(s.charAt(j),j);
            ans=Math.max(j-i+1,ans);
        }
        return ans;
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.lengthOfLongestSubstring("abcabcbb"));
        System.out.println(sol.lengthOfLongestSubstring("pwwkew"));
        System.out.println(sol.lengthOfLongestSubstring("bbbbbbb"));
        System.out.println(sol.lengthOfLongestSubstring("abba"));
    }
}

```

