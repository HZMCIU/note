### [用两个栈实现队列](https://leetcode-cn.com/problems/yong-liang-ge-zhan-shi-xian-dui-lie-lcof/)

用两个栈实现一个队列。队列的声明如下，请实现它的两个函数 `appendTail `和 `deleteHead `，分别完成在队列尾部插入整数和在队列头部删除整数的功能。(若队列中没有元素，`deleteHead `操作返回 -1 )

### 思路

维护两个栈`in`和`out`，分别支持插入操作和删除操作。插入元素时，将元素插入到`in`栈中；删除元素时，弹出`out`栈顶的元素；如果栈`out`为空，而`in`非空，则将`out`栈中的元素弹出，加入到`in`栈中

### AC代码

```java
class CQueue {

    Stack<Integer> in;
    Stack<Integer> out;
    public CQueue()
    {
        in = new Stack<Integer>();
        out = new Stack<Integer>();
    }

    public void appendTail(int value)
    {
        in.push(value);
    }

    public int deleteHead()
    {
        if(!out.isEmpty()) {
            return out.pop();
        }
        else if(out.isEmpty() && !in.isEmpty()) {
            while(!in.isEmpty()) {
                out.push(in.pop());
            }
            return out.pop();
        }
        return -1;
    }
}
```

