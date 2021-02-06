### [Two Sum](https://leetcode.com/problems/two-sum/)

### 题意

### 思路

HashTable的使用

### 代码

```java
import java.util.Hashtable;

class Solution {
    public int[] twoSum(int[] nums, int target) {
        Hashtable<Integer,Integer> map=new Hashtable<Integer, Integer>();
        int half=0;
        int [] res=new int[2];
        for(int i=0;i<nums.length;i++){
            if(nums[i]==target/2){
                res[half++]=i;
            }
            map.put(nums[i],i);
        }
        if(half==2){
            return res;
        }
        for(int i=0;i<nums.length;i++){
            if(map.containsKey(target-nums[i])){
                res[0]=i;
                res[1]=map.get(target-nums[i]).intValue();
                if(res[1]!=res[0]){
                    break;
                }
            }
        }
        return res;
    }
    public static void main(String[] args){
        Solution solution=new Solution();
        int[] nums=new int[]{2, 11, 7, 15};
        int target=9;
        int [] res=solution.twoSum(nums,target);
        System.out.println(res[0]+"  "+res[1]);
    }
}
```

### 标程

```java
public int[] twoSum(int[] nums, int target) {
    Map<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        int complement = target - nums[i];
        if (map.containsKey(complement)) {
            return new int[] { map.get(complement), i };
        }
        map.put(nums[i], i);
    }
    throw new IllegalArgumentException("No two sum solution");
}
```

