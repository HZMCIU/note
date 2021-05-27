### [剑指 Offer 58 - I. 翻转单词顺序](https://leetcode-cn.com/problems/fan-zhuan-dan-ci-shun-xu-lcof/)
### 题意
输入一个英文句子，翻转句子中单词的顺序，但单词内字符的顺序不变。为简单起见，标点符号和普通字母一样处理。例如输入字符串"I am a student. "，则输出"student. a am I"。
### 思路
使用双指针`i`,`j`来定位单词的两侧，使用`substring`将单词取下来加入到`StringBuilder`中
### AC代码

```java
import java.util.*;
class Solution {
    public String reverseWords(String s) {
        if (s.length() == 0) {
            return "";
        }
        s = s.trim();
        StringBuilder sb = new StringBuilder();
        int j = s.length() - 1;
        int i = j;
        while (i >= 0) {
            while (i >= 0 && s.charAt(i) != ' ') {
                i--;
            }
            sb.append(s.substring(i + 1, j + 1) + " ");
            j = i;
            while (j >= 0 && s.charAt(j) == ' ') {
                j--;
            }
            i = j;
        }
        sb.deleteCharAt(sb.length() - 1);
        return sb.toString();
    }
    public static void main(String[] args) {
        Solution sol = new Solution();
        System.out.println(sol.reverseWords("the sky is blue"));
        System.out.println(sol.reverseWords("  hello world!  "));
    }
}
```

