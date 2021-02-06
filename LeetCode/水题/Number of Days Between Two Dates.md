#### [Number of Days Between Two Dates](https://leetcode-cn.com/problems/number-of-days-between-two-dates/)

### 思路

暴力算出两个日期和1971.1.1相差天数，然后和将两个天数相减。

### 总结

如果直接比较两个日期相差的天数，逻辑会很麻烦。使用直接计算某一日期相差的天数，利用稍大的计算量换取简洁的代码。

### AC代码

```java
class Solution {
    int[] month1 = { 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
    int[] month2 = { 0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

    public int daysBetweenDates(String date1, String date2) {
        return Math.abs(calDate(date1) - calDate(date2));
    }

    public int calDate(String date) {
        String[] d = date.split("-");
        int year = Integer.valueOf(d[0]), month = Integer.valueOf(d[1]), day = Integer.valueOf(d[2]);
        System.out.println(year + " " + month + " " + day);
        int days = 0;
        for (int i = 1971; i < year; i++) {
            if ((i % 4 == 0 && i % 100 != 0) || (i % 400 == 0)) {
                days += 366;
            } else {
                days += 365;
            }
        }

        for (int i = 1; i < month; i++) {
            if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                days += month2[i];
            } else {
                days += month1[i];
            }
        }
        days += day;
        return days;
    }

    public static void main(String[] args) {
        Solution solution = new Solution();
        System.out.println(solution.daysBetweenDates("2019-12-31", "2020-01-15"));
    }
}
```

