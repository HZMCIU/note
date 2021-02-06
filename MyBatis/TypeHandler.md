[toc]

# 使用默认TypeHandler实现枚举映射

MyBatis内置了两个枚举转换器分别是：`org.apache.ibatis.type.EnumTypeHandler`和`org.apache.ibatis.type.EnumOrdinalTypeHandler`。

1. **`EnumTypeHandler`**: 该转换器完成枚举实例和实例名称的相互转化
2. **`EnumOrdinalTypeHandler`**: 该转换器将完成枚举实例和相对应的ordinal值的相互转化

在`application.yml`中配置相应的`TypeHandler`即可设置

```yaml
mybatis:
	configuration:
		default-enum-type-handler: org.apache.ibatis.type.EnumOrdinalTypeHandler
```



# 自定义TypeHandler实现枚举映射

Mybatis提供`org.apache.ibatis.type.BaseTypeHandler` 用于我们自己拓展类型转化器。[^1]  继承 `BaseTypeHandler` ，需要实现四个方法[^3]。

1. `void setNonNullParameter(PreparedStatement ps, int i, T parameter, JdbcType jdbcType)`  

   用于定义设置参数时，该如何把Java类型的参数转换为对应的数据库类型

2. `T getNullableResult(ResultSet rs, String columnName)` .

   用于定义通过字段名称获取字段数据时，如何把数据库类型转换为对应的Java类型

3. `T getNullableResult(ResultSet rs, int columnIndex)` 

   用于定义通过字段索引获取字段数据时，如何把数据库类型转换为对应的Java类型

4. `T getNullableResult(CallableStatement cs, int columnIndex)` 

   用定义调用存储过程后，如何把数据库类型转换为对应的Java类型

## 实现自定义枚举的过程 [^2]

+ 继承`BaseTypeHandler<T>` 

  ```java
  //TypeHandler所要处理的Jdbc类型
  @MappedJdbcTypes(JdbcType.INTEGER)
  //TypeHandler所要处理的Java类型
  @MappedTypes(value = Gender.class)
  public class GenderEnumHandler extends BaseTypeHandler<Gender> {
      @Override
      public void setNonNullParameter(PreparedStatement ps, int i, Gender gender, JdbcType jdbcType) throws SQLException {
          ps.setInt(i,gender.getCode());
      }
      @Override
      public Gender getNullableResult(ResultSet rs , String s) throws SQLException {
          int code=rs.getInt(s);
          return Gender.getGender(code);
      }
  
      @Override
      public Gender getNullableResult(ResultSet rs,int i) throws SQLException {
          int code=rs.getInt(i);
          return Gender.getGender(code);
      }
      @Override
      public Gender getNullableResult(CallableStatement cs,int i) throws SQLException {
          int code=cs.getInt(i);
          return Gender.getGender(code);
      }
  }
  ```

+ 在配置文件中启用 `TypeHandler`

  +  在`Spring Boot`的配置文件增加`type-handlers-package`的配置

    ```properties
    mybatis.type-handlers-package=com.xxx.typehandler
    ```

  +  在`Spring Boot`指定MyBatisConfig文件的路径，之后在MyBatisConfig中配置`typeHandlers`

    ```xml
    <configuration>
        <typeHandlers>
            <package name="com.xxx.typehandler"/>
        </typeHandlers>
    </configuration>
    ```

    ```properties
    mybatis.config-location=classpath:mybatis-config.xml
    ```

    > 如果在`application.properties`文件指定了`mybatis.configuration` ，又同时配置`mybatis.config-location`,则需要把`application.properties`的`mybatis.configuration`的配置移到`mybatis-config.xml`文件里。否则启用会校验失败

  + 限定`JavaType` 和 `JdbcType`

    + XML配置文件

      在类型处理器的配置元素（typeHandler 元素）上增加一个 javaType 属性（比如：javaType="String"）

      在类型处理器的配置元素上增加一个 jdbcType 属性（比如：jdbcType="VARCHAR"）

    + Map处理类

      在类型处理器的类上（TypeHandler class）增加一个 @MappedTypes 注解来指定与其关联的 Java 类型列表。 如果在 javaType 属性中也同时指定，则注解方式将被忽略。

      在类型处理器的类上增加一个 @MappedJdbcTypes 注解来指定与其关联的 JDBC 类型列表。 如果在 jdbcType 属性中也同时指定，则注解方式将被忽略。

[^1]: [MyBatis TypeHandler的笔记](https://zhuanlan.zhihu.com/p/67407074)
[^2]:[Springboot整合Mybatis使用TypeHandler来转换数据库中的数据](https://www.cnblogs.com/dyf-stu/p/10162301.html)
[^3]:[如何在MyBatis中优雅的使用枚举](https://segmentfault.com/a/1190000010755321)

