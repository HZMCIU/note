### [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/)

### 题意

求解最长的字母不重复的子串

#### 思路

双指针+`vis`数组

#### 总结

+ 标程2中，`while`循环中使用`if`，就不必判断`r`越界了。我的代码中`while`套`while`两个`while`都需要判断`r`是否越界，繁琐且容易出错
+ 标程1中，左边界不是1个单位1个单位移动，而是使用`map`来减少不必要的移动。map中存储的是<Character,Integer>键值对，分别对应了字符以及字符对应的下标。当s.charAt(r)已经在子串中出现时，直接`l=map.get(s.charAt(l))+1` 。因为子串只有将`s.charAt(l)`去除，向右继续添加字符才不会出现重复。
+ map中存储的下一个字符的坐标，避免了`s.charAt(r)`中的元素在子串前出现，对`l`加1的情况的出现。

#### 代码

```java
import java.util.Set;

class Solution {
    public int lengthOfLongestSubstring(String s) {
        int res=0;
        int vis[]=new int[500];
        int l=0,r=0;
        while(r<s.length()&&l<s.length()){
            while(r<s.length()&&vis[s.charAt(r)]==0){
                vis[s.charAt(r)]=1;
                res=Math.max(res,r-l+1);
                r++;
            }
            vis[s.charAt(l)]=0;
            l++;
        }
        return res;
    }
}
```

#### 标程

```java
public class Solution {
    public int lengthOfLongestSubstring(String s) {
        int n = s.length(), ans = 0;
        Map<Character, Integer> map = new HashMap<>(); // current index of character
        // try to extend the range [i, j]
        for (int j = 0, i = 0; j < n; j++) {
            if (map.containsKey(s.charAt(j))) {
                i = Math.max(map.get(s.charAt(j)), i);
            }
            ans = Math.max(ans, j - i + 1);
            map.put(s.charAt(j), j + 1);
        }
        return ans;
    }
}
```



```java
public class Solution {
    public int lengthOfLongestSubstring(String s) {
        int n = s.length();
        Set<Character> set = new HashSet<>();
        int ans = 0, i = 0, j = 0;
        while (i < n && j < n) {
            // try to extend the range [i, j]
            if (!set.contains(s.charAt(j))){
                set.add(s.charAt(j++));
                ans = Math.max(ans, j - i);
            }
            else {
                set.remove(s.charAt(i++));
            }
        }
        return ans;
    }
}
```




