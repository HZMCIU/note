#### [Z 字形变换](https://leetcode-cn.com/problems/zigzag-conversion/)

### 解题思路

1. 逐行访问

   首行和尾行中每个字符间距为$2\times numRow-2$

   中间行的字符间距为$2\times numRow-2-k$ 或$k$

2. **逐列访问**

   **模拟访问**



### AC代码

逐行访问

```cpp
class Solution {
public:
    string convert(string s, int numRows) {

        if(numRows>=s.size()||numRows==1)
            return s;
        string ans="";

        for(int i=0;i<s.size();i+=(2*numRows-2))
        {
            ans+=s[i];
        }

        int step=2*numRows-2;
        for(int i=1;i<numRows-1;i++)
        {
            step-=2;
            bool even=true;
            for(int j=i;j<s.size();j+=(even==false?step:(2*numRows-2-step)))
            {
                ans+=s[j];
                even=!even;
            }
        }

        for(int i=numRows-1;i<s.size();i+=(2*numRows-2))
        {
            ans+=s[i];
        }

        return ans;
    }
};
```



逐列访问



```cpp
class Solution {
public:
    string convert(string s, int numRows) {
        if(numRows==1)
            return s;

        vector<string> rows(min(numRows,int(s.size())));

        int curRow=0;
        bool goDown=false;
        for(char c:s)
        {
            rows[curRow]+=c;
            if(curRow==0||curRow==numRows-1)
                goDown=!goDown;
            curRow+=goDown?1:-1; //想上走的时候，最后一行没有访问
        }

        string ans;
        for(string row:rows)
            ans+=row;
        
        return ans;
    }
};
```

