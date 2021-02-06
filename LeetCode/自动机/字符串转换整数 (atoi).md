#### [字符串转换整数 (atoi)](https://leetcode-cn.com/problems/string-to-integer-atoi/)

### 解题思路

1. **模拟**

   模拟

2. **自动机**

|           |       |        |           |       |
| --------- | ----- | ------ | --------- | ----- |
|           | ‘ ’   | +/-    | number    | other |
| start     | start | signed | in_number | end   |
| signed    | end   | end    | in_number | end   |
| in_number | end   | end    | in_number | end   |
| end       | end   | end    | end       | end   |

### AC代码

**模拟**

```cpp
class Solution {
public:
    int myAtoi(string str) {
        int pos=0;
        while(pos<str.size()&&str[pos]==' ')
            pos++;
        if(pos==str.size())
            return 0;
        bool negtive=false;

        if(str[pos]=='-')
        {
            negtive=true;
            pos++;
        }
        else if(str[pos]=='+')
        {
            negtive=false;
            pos++;
        }
        else if(!isdigit(str[pos]))
            return 0;
        int ans=0;

        while(pos<str.size()&&isdigit(str[pos]))
        {
            int digit=str[pos]-'0';
            if(ans>(INT_MAX-digit)/10)
                return negtive?INT_MIN:INT_MAX;
            ans=ans*10+digit;
            pos++;
        }
        return negtive?-ans:ans;
    }
};
```



**自动机**



```cpp
class Automaton
{
public:
    string state="start";
    unordered_map<string,vector<string>> table=
    {
        //__,+-,digit,other
        {"start",{"start","signed","in_number","end"}},
        {"signed",{"end","end","in_number","end"}},
        {"in_number",{"end","end","in_number","end"}},
        {"end",{"end","end","end","end"}}
    };
    int sign=1;
    long long ans=0;

    int get(char ch)
    {
        if(isspace(ch))
            return 0;
        else if(ch=='-'||ch=='+')
            return 1;
        else if(isdigit(ch))
            return 2;
        else 
            return 3;
    }

    void process(char ch)
    {
        state=table[state][get(ch)];
        if(state=="signed")
        {
            if(ch=='+')
                sign=1;
            else if(ch=='-')
                sign=-1;
        }
        else if(state=="in_number")
        {
            ans=ans*10+ch-'0';
            ans=sign==1?min((long long)INT_MAX,ans):min(-(long long)INT_MIN,ans);
        }
    }
};

class Solution {
public:
    int myAtoi(string str) {
        Automaton automaton;
        for(char ch:str)
        {
            automaton.process(ch);
        }
        return automaton.sign*automaton.ans;
    }
};
```



<span style="border-style:dashed">123</span>           