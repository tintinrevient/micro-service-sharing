## RabbitMQ Monitoring

为了监控RabbitMQ的健康和性能，我们可以使用如下两种协议：

* 默认 - AMQP (Advanced Message Queue Protocol)
* 插件 - REST API

下面详细讲解怎么用REST API监控RabbitMQ，以及怎么集成Prometheus和Grafana。

### 第一步：RabbitMQ REST API插件

在RabbitMQ安装目录的sbin文件夹下，开启RabbitMQ Management plugin。

```
cd /usr/local/.../rabbitmq/3.7.12/sbin
rabbitmq-plugins enable rabbitmq_management
```

重启RabbitMQ，在默认UI可以看到RabbitMQ的所有metrics信息: http://localhost:15672/#/

比如关键性能指标Queued messages：一旦Queued messages超过阀指，可以进一步检测是否是Consumer出现问题，或者是需要增加更多的Consumer。

![overview](./overview.png)

比如可以通过如下REST API对RabbitMQ的默认Core node的默认vhost - "/" 进行健康监测：

```
curl -i -u guest:guest http://localhost:15672/api/aliveness-test/%2F

```



