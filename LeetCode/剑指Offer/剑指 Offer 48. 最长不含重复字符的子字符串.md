### [剑指 Offer 48. 最长不含重复字符的子字符串](https://leetcode-cn.com/problems/zui-chang-bu-han-zhong-fu-zi-fu-de-zi-zi-fu-chuan-lcof/)

### 题目

请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。

### 思路

#### 动态规划

$dp[j]$代表以 $s[j]$结尾的不包含重复字母的子串的最大长度。 $s[i]$ 为$s[0.j-1]$ 中和$s[j]$相同的字符。

存在如下状态转移方程
$$
dp[j]=\left\{
\begin{array}{rcl}
   dp[j-1]+1,\quad  dp[j-1]<j-i \quad 字符s[j]在dp[j-1]字符串区间之外 \\
   j-i,\quad dp[j-1]\ge j-i \quad 字符s[j]在dp[j-1]字符串区间内
\end{array}
\right .
$$
使用哈希表，获得重复字符`s[i]`出现的位置

#### 双指针

使用哈希表获得最近一次重复字符`s[i]`出现的位置。

当右侧添加一个新的元素时，如果左侧出现过重复的字符，那么就将左指针更新到左侧重复字符的后一个位置，计算此时子串的最大值。

### AC代码

**动态规划**
```java
class Solution {
    public int lengthOfLongestSubstring(String s) {
        HashMap<Character,Integer> dict=new HashMap<Character,Integer>();
        int n=s.length();
        int tmp=0,ans=0;
        for (int j=0; j<n; j++) {
            int i=dict.getOrDefault(s.charAt(j),-1);
            dict.put(s.charAt(j),j);
            tmp=tmp<j-i?tmp+1:j-i;
            ans=Math.max(ans, tmp);
        }
        return ans;
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.lengthOfLongestSubstring("abcabcbb"));
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

