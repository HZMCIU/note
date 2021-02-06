## [替换空格](https://leetcode-cn.com/problems/ti-huan-kong-ge-lcof/)

请实现一个函数，把字符串 `s` 中的每个空格替换成"%20"。

### 思路

1. 由于Java中的String类是不可变的，故使用`StringBuilder`动态构造字符串
2. 分配足够大的静态字符数组，长度为\\(3\times length\\) 

## AC代码

StringBuilder构造字符串

```java
class Solution {
    public String replaceSpace(String s)
    {
        int length = s.length();
        char []ch = new char[3 * length];
        int size = 0;
        for(int i = 0; i < length; i++) {
            char c = s.charAt(i);
            if(c == ' ') {
                ch[size++] = '%';
                ch[size++] = '2';
                ch[size++] = '0';
            }
            else {
                ch[size++] = c;
            }
        }
        return new String(ch, 0, size);
    }
}

```

分配静态数组

```java
class Solution {
    public String replaceSpace(String s)
    {
        StringBuilder sb = new StringBuilder();
        for(char c : s.toCharArray()) {
            if(c == ' ') {
                sb.append("%20");
            }
            else {
                sb.append(c);
            }
        }
        return sb.toString();
    }
}
```

