# 枚举实现的原理

+ 使用`enum`定义的枚举类型，在编译过程中，编译器会生成一个与`enum`类同名的普通类，该类继承`java.lang.Enum`抽象类，且该类的类型为final，无法被继承。
 ^f70295
+ 枚举类型中的枚举常量，在编译过程中，编译器会在与枚举类型同名的普通类中，定义同名的静态实例对象。定义方式为`public static final Day MONDAY`。其中`MONDAY`就是枚举类型中定义的枚举常量。
+ 编译会在与枚举类同名的普通类中插入两个静态方法`values()`和`valueOf()`


# 枚举常用的方法

+ `ordinal()` 返回枚举常量的序数，枚举常量在枚举声明中的位置，其中初始常量序数为零

+ `values()` 获取枚举中的所有枚举常量，并作为数组返回

+ `valueOf()` 根据名称来获取枚举常量

+ `getDeclaringClass()`  返回与此枚举常量的枚举类型相对应的 Class 对象

+ `getEnumConstants()` 返回该枚举类型的所有元素，如果Class对象不是枚举类型，则返回null

  ```java
  Class clasz=day.getDeclaringClass();
  Day[] days=(Day[])clasz.getEnumConstants();
  System.out.println(Arrays.toString(days));
  ```

# 枚举的进阶用法

使用关键字`enum`定义的枚举类，除了不能使用继承(因为编译器会自动为我们继承`Enum`抽象类而Java只支持单继承，因此枚举类是无法手动实现继承的)，可以把`enum`类当成常规类，也就是说我们可以向`enum`类中添加方法和变量，甚至是`main`方法。 ^48226b

+ 可以向枚举中添加方法，添加变量，自定义构造方法。可以用于向枚举常量添加说明性文字。枚举常量定义结束后，记住要用分号结束。

  ```java
  enum Day {
      MONDAY("星期一");
  
      // 枚举中定义变量
      private String desc;
  
      // 枚举中自定义构造函数
      private Day(String desc)   {
          this.desc=desc;
      }
  
      // 覆盖父类方法
      public String toString() {
          return desc;
      }
  
      // 枚举类中运行main方法
      public static void main(String[] args) {
          Day day = Day.MONDAY;
          System.out.println(day);
      }
  }
  ```

+ 覆盖`enum`类方法。只有`toString()` 方法没有`final`修饰，只能覆盖`toString()`方法

+ 定义抽象方法。`enum`类允许我们为其定义抽象方法，然后使每个枚举实例都实现该方法，以便产生不同的行为方式，注意`abstract`关键字对于枚举类来说并不是必须的

  ```java
  enum Day {
      FIRST {
          @Override
          public String getInfo() {
              return "FIRST TIME";
          }
      },
      SECOND {
          @Override
          public String getInfo() {
              return "SECOND TIME";
          }
      };
      // 枚举类中定义抽象方法
      abstract public  String getInfo() ;
      public static void main(String[] args) {
          Day day = Day.FIRST;
          System.out.println(day.getInfo());
      }
  }
  ```

+ `enum`不可以继承，但是可以实现多个接口

  ```java
  public enum Meal {
      APPETIZER(Food.Appetizer.class), 
      MainCourse(Food.Appetizer.class);
  
      // 继承Food接口的枚举类的所有枚举常量
      private Food[] values;
      // 自定义构造函数
      private Meal(Class<? extends Food> kind) {
          // 获取枚举类的所有枚举常量
          values = kind.getEnumConstants();
      }
  
      public void show() {
          System.out.println(Arrays.toString(values));
      }
  
      public static void main(String[] args) {
          Meal appetizer = Meal.APPETIZER;
          appetizer.show();
      }
  
      public interface Food {
          // 枚举类型实现接口
          enum Appetizer implements Food {
              SALAD, SOUP, SPRINT_ROLLS;
          }
  
          enum MainCourse implements Food {
              LASAGNE, BURRITO, PAD_THAI, LENTILS, HUMMOUS, VINDALOO;
          }
      }
  }
  ```

  

# 枚举与Switch



# 枚举与单例

序列化可能会破坏单例模式，比较每次反序列化一个序列化的对象实例时都会创建一个新的实例。使用枚举类能够比较简洁地完成这个问题。

我们也可以像常规类一样编写`enum`类，为其添加变量和方法，访问方式也更简单，使用`SingletonEnum.INSTANCE`进行访问，这样也就避免调用`getInstance()`方法，更重要的是使用枚举单例的写法，我们完全不用考虑序列化和反射的问题。枚举序列化是由JVM保证的，每一个枚举类型和定义的枚举变量在JVM中都是唯一的，在枚举类型的序列化和反序列化上，Java做了特殊的规定：在序列化时Java仅仅是将枚举对象的name属性输出到结果中，反序列化的时候则是通过`java.lang.Enum`的`valueOf`方法来根据名字查找枚举对象。同时，编译器是不允许任何对这种序列化机制的定制的并禁用了`writeObject`、`readObject`、`readObjectNoData`、`writeReplace`和`readResolve`等方法，从而保证了枚举实例的唯一性

```java
public enum  SingletonEnum {
    INSTANCE;
    private String name;
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
}
```



[^1]:[深入理解JavaEnum类型](https://blog.csdn.net/javazejian/article/details/71333103)
[^2]: [深入理解Java Enum 类型](https://www.cnblogs.com/zhanqing/p/11076646.html)

