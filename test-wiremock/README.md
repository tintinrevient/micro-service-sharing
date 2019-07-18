## WireMock - 对第三方API的Mock

如果在单元测试中，需要对第三方API或者依赖的其他微服务API的Mock，则需要用到WireMock。

使用WireMock的具体步骤如下：

1. 在pom.xml中引入如下依赖：
```
<dependency>
    <groupId>com.github.tomakehurst</groupId>
    <artifactId>wiremock-jre8</artifactId>
    <version>2.23.2</version>
    <scope>test</scope>
</dependency>
```

2. 在单元测试中，对下游微服务API的Mock：
```
@RunWith(SpringRunner.class)
@SpringBootTest
public class DownstreamServiceControllerTests {

    @Rule
    public WireMockRule wireMockRule = new WireMockRule(6061);

    @Before
    public void setUp() {
        stubFor(get(urlEqualTo("/review/1"))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withHeader(CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                        .withBody("{\"id\":1,\"subject\":\"cup review\",\"comment\":\"a good cup\",\"user\":1,\"product\":1,\"ignore\":true}")));
    }
}
```

3. 这时在如下单元测试的时候，请求http://localhost:6061/review/1 ，则会调用stub的canned response：
```
@Test
public void aggregate() {

    Review expectedReview = new Review();
    expectedReview.setId(1l);
    expectedReview.setSubject("cup review");
    expectedReview.setComment("a good cup");
    expectedReview.setUser(1l);
    expectedReview.setProduct(1l);

    assertThat(restTemplate.getForEntity("http://localhost:6061/review/1", Review.class).getBody()).isEqualTo(expectedReview);
}
```

这里需要注意的是，对下游服务返回的JSON怎么反序列化为POJO，其中的原则是Postel's Law：

> "TCP implementations should follow a general principle of robustness: be conservative in what you do, be liberal in what you accept from others."

所以为了对接受的JSON数据更tolerant，需要在POJO的定义中，加入如下配置。这时，如果返回的JSON中存在未知的属性，convert成POJO时，也不会报错。

```
@JsonIgnoreProperties(ignoreUnknown = true)
public class Review {

}
```

