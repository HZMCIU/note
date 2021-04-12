### [剑指 Offer 59 - II. 队列的最大值](https://leetcode-cn.com/problems/dui-lie-de-zui-da-zhi-lcof/)
#单调队列

### 题目

请定义一个队列并实现函数 `max_value` 得到队列里的最大值，要求函数`max_value`、`push_back` 和 `pop_front` 的**均摊**时间复杂度都是O(1)。

若队列为空，`pop_front` 和 `max_value` 需要返回 -1

### 思路

使用 **单调队列** 存储所有可能的最大值。 单调队列非严格递增，可以出现重复的值。
* 因为可能存在多个最大值，若队列单调递增，只能包含一个最大值，当最大值从队列中弹出时，单调队列中的值也会被弹出。此刻，如果队列还含有最大值，而单调队列中却不包含最大值，这就会造成错误。

### AC代码

```java
class MaxQueue {
    Deque<Integer> deque;
    Queue<Integer> queue;
    public MaxQueue() {
        deque = new LinkedList<>();
        queue = new LinkedList<>();
    }

    public int max_value() {
        return deque.isEmpty() ? -1:deque.peekFirst();
    }

    public void push_back(int value) {
        queue.add(value);
        // 单调队列中非严格递增
        while (!deque.isEmpty() && deque.peekLast() < value) {
            deque.pollLast();
        }
        deque.addLast(value);
    }

    public int pop_front() {
        if (queue.isEmpty()) {
            return -1;
        }
        if (deque.peekFirst().equals(queue.peek())) {
            deque.pollFirst();
        }
        return queue.poll();
    }
}

```
