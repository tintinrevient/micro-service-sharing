## Spring Boot Test

### 测试金字塔

![pyramid](./pix/pyramid.png)

测试金字塔包含的两个原则：
1. Write tests with different granularity
2. The more high-level you get the fewer tests you should have

### 单元测试

![unit-test](./pix/unit-test.png)

单元测试有两种类型：
1. Solitary unit test
2. Sociable unit test

这两种类型的区别是基于collaborators (e.g. other classes that are called by your class under test)的mock或stub：
1. Solitary unit test - mock或stub所有的collaborators
2. Sociable unit test - 允许调用真实的collaborators

对于单元测试，在Spring Boot中有两种测试方法：

1. Unit Testing with Mockito using MockitoRunner
```
@RunWith(MockitoJUnitRunner.class)
@Mock UserRepository - Create a mock for UserRepository
@InjectMocks UserService - Inject the mocks as dependencies into UserService
```

2. Unit Test launching the complete Spring Context using @MockBean
```
@RunWith(SpringRunner.class) - Spring Runner is used to launch up a spring context in unit tests.
@SpringBootTest - This annotation indicates that the context under test is a @SpringBootApplication.
@MockBean UserRepository - @MockBean annotation creates a mock for UserRepository. This mock is used in the Spring Context instead of the real UserRepository.
@Autowired UserService - Pick the UserService from the Spring Context and autowire it in.
```

对于HTTP测试，也有两种测试方法：

1. MockMvc (org.springframework.test.web.servlet.MockMvc) - 也就是mock一个dispatcher servlet，不启动servlet container，没有实际的网络连接，从server-side测试web应用

2. TestRestTemplate (org.springframework.boot.test.web.client.TestRestTemplate) - 实际启动一个servlet container，从client-side测试web应用


至于mock和stub的区别，可以参见：https://martinfowler.com/articles/mocksArentStubs.html

### 集成测试

Integration tests live at the boundary of your service，有如下几种情况：

* Calls to your services' REST API
* Reading from and writing to databases
* Calling other microservices
* Reading from and writing to queues
* Writing to the filesystem

例如和文件系统/数据库的集成：
![db](./pix/db.png)

例如测试REST API/HTTP集成：
![http](./pix/http.png)

### UI测试

![ui](./pix/ui.png)

UI测试包含如下几种类型：
1. Behaviour
2. Layout
3. Usability


对于Behaviour测试来说：
* Angular，React和Vue.js有自己单元测试的工具和helpers
* 纯Javascript可以用Mocha或者Jasmine来做单元测试
* 对于JSP等Server-side rendered的界面，可用Selenium

### 一些工具

1. Layout测试 - https://github.com/otto-de/jlineup
2. End-to-End测试 - https://nightwatchjs.org/ (UI向)，https://github.com/rest-assured/rest-assured (REST API向)
3. CDC测试 - https://github.com/pact-foundation
4. BDD - https://cucumber.io/

### Spring Boot Starter Test包含什么

The spring-boot-starter-test “Starter” (in the test scope) contains the following provided libraries:

* JUnit 4: The de-facto standard for unit testing Java applications.
* Spring Test & Spring Boot Test: Utilities and integration test support for Spring Boot applications.
* AssertJ: A fluent assertion library.
* Hamcrest: A library of matcher objects (also known as constraints or predicates).
* Mockito: A Java mocking framework.
* JSONassert: An assertion library for JSON.
* JsonPath: XPath for JSON.


### Reference

* https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-testing.html