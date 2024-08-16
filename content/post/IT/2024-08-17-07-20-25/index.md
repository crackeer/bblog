---
title: Kafka那些事儿
date: 2024-08-17
slug: 2024-08-17-07-20-25
categories:
  - IT
tags:
  - kafka
---

# kafka 有哪些特点

- 高吞吐量、低延迟：kafka 每秒可以处理几十万条消息，它的延迟最低只有几毫秒，每个 topic 可以分多个 partition, consumer group 对 partition 进行 consume 操作。
- 可扩展性：kafka 集群支持热扩展
- 持久性、可靠性：消息被持久化到本地磁盘，并且支持数据备份防止数据丢失
- 容错性：允许集群中节点失败（若副本数量为 n, 则允许 n-1 个节点失败）
- 高并发：支持数千个客户端同时读写

# kafka 使用场景

- 日志收集：一个公司可以用 Kafka 可以收集各种服务的 log，通过 kafka 以统一接口服务的方式开放给各种 consumer，例如 hadoop、HBase、Solr 等。
- 消息系统：解耦和生产者和消费者、缓存消息等。
- 用户活动跟踪：Kafka 经常被用来记录 web 用户或者 app 用户的各种活动，如浏览网页、搜索、点击等活动，这些活动信息被各个服务器发布到 kafka 的 topic 中，然后订阅者通过订阅这些 topic 来做实时的监控分析，或者装载到 hadoop、数据仓库中做离线分析和挖掘。
- 运营指标：Kafka 也经常用来记录运营监控数据。包括收集各种分布式应用的数据，生产各种操作的集中反馈，比如报警和报告。
- 流式处理：比如 spark streaming 和 Flink

# kafka 架构说明

- Producer ：消息生产者，就是向 kafka broker 发消息的客户端。
- Consumer ：消息消费者，向 kafka broker 取消息的客户端。
- Topic ：可以理解为一个队列，一个 Topic 又分为一个或多个分区。
- Consumer Group：这是 kafka 用来实现一个 topic 消息的广播（发给所有的 consumer）和单播（发给任意一个 consumer）的手段。一个 topic 可以有多个 Consumer Group。
- Broker ：一台 kafka 服务器就是一个 broker。一个集群由多个 broker 组成。一个 broker 可以容纳多个 topic。
- Partition：为了实现扩展性，一个非常大的 topic 可以分布到多个 broker 上，每个 partition 是一个有序的队列。partition 中的每条消息都会被分配一个有序的 id（offset）。将消息发给 consumer，kafka 只保证按一个 partition 中的消息的顺序，不保证一个 topic 的整体（多个 partition 间）的顺序。
- Offset：kafka 的存储文件都是按照 offset.kafka 来命名，用 offset 做名字的好处是方便查找。例如你想找位于 2049 的位置，只要找到 2048.kafka 的文件即可。当然 the first offset 就是 00000000000.kafka。

# kafka 分区目的

分区对于 Kafka 集群的好处是：实现负载均衡。分区对于消费者来说，可以提高并发度，提高效率。

# kafka 如何做到消息有序？

kafka 中的每个 partition 中的消息在写入时都是有序的，而且单独一个 partition 只能由一个消费者去消费，可以在里面保证消息的顺序性。但是分区之间的消息是不保证有序的。

# kafka 如何做到高可靠性

[链接](https://www.iteblog.com/archives/2560.html)

# kafka 数据一致性原理

一致性就是说不论是老的 Leader 还是新选举的 Leader，Consumer 都能读到一样的数据。

![](https://cdn.nlark.com/yuque/0/2020/png/372959/1589632278875-d1fb3404-a68a-4be8-846c-742919f5e5c2.png#align=left&display=inline&height=402&margin=%5Bobject%20Object%5D&originHeight=402&originWidth=1420&size=0&status=done&style=none&width=1420)

> 假设分区的副本为 3，其中副本 0 是 Leader，副本 1 和副本 2 是 follower，并且在 ISR 列表里面。虽然副本 0 已经写入了 Message4，但是 Consumer 只能读取到 Message2。因为所有的 ISR 都同步了 Message2，只有 High Water Mark 以上的消息才支持 Consumer 读取，而 High Water Mark 取决于 ISR 列表里面偏移量最小的分区，对应于上图的副本 2，这个很类似于木桶原理。

> 这样做的原因是还没有被足够多副本复制的消息被认为是“不安全”的，如果 Leader 发生崩溃，另一个副本成为新 Leader，那么这些消息很可能丢失了。如果我们允许消费者读取这些消息，可能就会破坏一致性。试想，一个消费者从当前 Leader（副本 0） 读取并处理了 Message4，这个时候 Leader 挂掉了，选举了副本 1 为新的 Leader，这时候另一个消费者再去从新的 Leader 读取消息，发现这个消息其实并不存在，这就导致了数据不一致性问题。

> 当然，引入了 High Water Mark 机制，会导致 Broker 间的消息复制因为某些原因变慢，那么消息到达消费者的时间也会随之变长（因为我们会先等待消息复制完毕）。延迟时间可以通过参数 replica.lag.time.max.ms 参数配置，它指定了副本在复制消息时可被允许的最大延迟时间。

# ISR、OSR、AR 指的是啥？

- ISR：In-Sync Replicas 副本同步队列
- OSR：Out-of-Sync Replicas
- AR：Assigned Replicas 所有副本

> ISR 是由 leader 维护，follower 从 leader 同步数据有一些延迟（具体可以参见 图文了解 Kafka 的副本复制机制），超过相应的阈值会把 follower 剔除出 ISR, 存入 OSR（Out-of-Sync Replicas ）列表，新加入的 follower 也会先存放在 OSR 中。AR=ISR+OSR。

# LEO、HW、LSO、LW 指的是啥？

- LEO：是 LogEndOffset 的简称，代表当前日志文件中下一条
- HW：水位或水印（watermark）一词，也可称为高水位(high watermark)，通常被用在流式处理领域（比如 Apache Flink、Apache Spark 等），以表征元素或事件在基于时间层面上的进度。在 Kafka 中，水位的概念反而与时间无关，而是与位置信息相关。严格来说，它表示的就是位置信息，即位移（offset）。取 partition 对应的 ISR 中 最小的 LEO 作为 HW，consumer 最多只能消费到 HW 所在的位置上一条信息。
- LSO：是 LastStableOffset 的简称，对未完成的事务而言，LSO 的值等于事务中第一条消息的位置(firstUnstableOffset)，对已完成的事务而言，它的值同 HW 相同
- LW：Low Watermark 低水位, 代表 AR 集合中最小的 logStartOffset 值。

# kafka 新建的分区会在哪个目录下创建

我们知道，在启动 Kafka 集群之前，我们需要配置好 `log.dirs` 参数，其值是 Kafka 数据的存放目录，这个参数可以配置多个目录，目录之间使用逗号分隔，通常这些目录是分布在不同的磁盘上用于提高读写性能。当然我们也可以配置 `log.dir` 参数，含义一样。只需要设置其中一个即可。
如果 `log.dirs` 参数只配置了一个目录，那么分配到各个 Broker 上的分区肯定只能在这个目录下创建文件夹用于存放数据。
但是如果 `log.dirs` 参数配置了多个目录，那么 Kafka 会在哪个文件夹中创建分区目录呢？答案是：Kafka 会在含有分区目录最少的文件夹中创建新的分区目录，分区目录名为 Topic 名+分区 ID。注意，是分区文件夹总数最少的目录，而不是磁盘使用量最少的目录！也就是说，如果你给 `log.dirs` 参数新增了一个新的磁盘，新的分区目录肯定是先在这个新的磁盘上创建直到这个新的磁盘目录拥有的分区目录不是最少为止。

# kafka 的 rebalance

在 Kafka 中，当有新消费者加入或者订阅的 topic 数发生变化时，会触发 Rebalance(再均衡：在同一个消费者组当中，分区的所有权从一个消费者转移到另外一个消费者)机制，Rebalance 顾名思义就是重新均衡消费者消费。Rebalance 的过程如下：

- 第一步：所有成员都向 coordinator 发送请求，请求入组。一旦所有成员都发送了请求，coordinator 会从中选择一个 consumer 担任 leader 的角色，并把组成员信息以及订阅信息发给 leader。
- 第二步：leader 开始分配消费方案，指明具体哪个 consumer 负责消费哪些 topic 的哪些 partition。一旦完成分配，leader 会将这个方案发给 coordinator。coordinator 接收到分配方案之后会把方案发给各个 consumer，这样组内的所有成员就都知道自己应该消费哪些分区了。

所以对于 Rebalance 来说，Coordinator 起着至关重要的作用

# kafka 如何实现高吞吐

- 顺序读写；
- 零拷贝
- 文件分段
- 批量发送
- 数据压缩。

# kafka 集群高可用和稳定性

> [Kafka](https://www.iteblog.com/archives/tag/kafka/)通过多副本复制技术，实现 kafka 集群的高可用和稳定性。每个 partition 都会有多个数据副本，每个副本分别存在于不同的 broker。所有的数据副本中，有一个数据副本为 Leader，其他的数据副本为 follower。在 kafka 集群内部，所有的数据副本皆采用自动化的方式进行管理，并且确保所有的数据副本的数据皆保持同步状态。不论是 producer 端还是 consumer 端发往 partition 的请求，皆通过 leader 数据副本所在的 broker 进行处理。当 broker 发生故障时，对于 leader 数据副本在该 broker 的所有 partition 将会变得暂时不可用。Kafka 将会自动在其他数据副本中选择出一个 leader，用于接收客户端的请求。这个过程由 kafka controller 节点 broker 自动完成，主要是从 Zookeeper 读取和修改受影响 partition 的一些元数据信息。在当前的 kafka 版本实现中，对于 zookeeper 的所有操作都是由 kafka controller 来完成的（serially 的方式）。

> 在通常情况下，当一个 broker 有计划地停止服务时，那么 controller 会在服务停止之前，将该 broker 上的所有 leader 一个个地移走。由于单个 leader 的移动时间大约只需要花费几毫秒，因此从客户层面看，有计划的服务停机只会导致系统在很小时间窗口中不可用。（注：在有计划地停机时，系统每一个时间窗口只会转移一个 leader，其他 leader 皆处于可用状态。）

> 然而，当 broker 非计划地停止服务时（例如，kill -9 方式)，系统的不可用时间窗口将会与受影响的 partition 数量有关。假如，一个 2 节点的 kafka 集群中存在 2000 个 partition，每个 partition 拥有 2 个数据副本。当其中一个 broker 非计划地宕机，所有 1000 个 partition 同时变得不可用。假设每一个 partition 恢复时间是 5ms，那么 1000 个 partition 的恢复时间将会花费 5 秒钟。因此，在这种情况下，用户将会观察到系统存在 5 秒钟的不可用时间窗口。

> 更不幸的情况发生在宕机的 broker 恰好是 controller 节点时。在这种情况下，新 leader 节点的选举过程在 controller 节点恢复到新的 broker 之前不会启动。Controller 节点的错误恢复将会自动地进行，但是新的 controller 节点需要从 zookeeper 中读取每一个 partition 的元数据信息用于初始化数据。例如，假设一个 kafka 集群存在 10, 000 个 partition，从 zookeeper 中恢复元数据时每个 partition 大约花费 2ms，则 controller 的恢复将会增加约 20 秒的不可用时间窗口。

> 通常情况下，非计划的宕机事件发生的情况是很少的。如果系统可用性无法容忍这些少数情况的场景，我们最好是将每个 broker 的 partition 数量限制在 2, 000 到 4, 000，每个 kafka 集群中 partition 的数量限制在 10, 000 以内。

# Kafka 中的分区器、序列化器、拦截器是否了解？它们之间的处理顺序是什么？

拦截器->序列化器->分区器

# Kafka 生产者客户端中使用了几个线程来处理？分别是什么？

2 个，主线程和 Sender 线程。主线程负责创建消息，然后通过分区器、序列化器、拦截器作用之后缓存到累加器 RecordAccumulator 中。Sender 线程负责将 RecordAccumulator 中消息发送到 kafka 中.

# “消费组中的消费者个数如果超过 topic 的分区，那么就会有消费者消费不到数据”这句话是否正确？如果不正确，那么有没有什么 hack 的手段？

不正确，通过自定义分区分配策略，可以将一个 consumer 指定消费所有 partition。


# 消费者提交消费位移时提交的是当前消费到的最新消息的 offset 还是 offset+1?

offset+1

# kafka 分区数量可以减少吗？

我们可以使用 bin/kafka-topics.sh 命令对 Kafka 增加 Kafka 的分区数据，但是 Kafka 不支持减少分区数。
Kafka 分区数据不支持减少是由很多原因的，比如减少的分区其数据放到哪里去？是删除，还是保留？删除的话，那么这些没消费的消息不就丢了。如果保留这些消息如何放到其他分区里面？追加到其他分区后面的话那么就破坏了 Kafka 单个分区的有序性。如果要保证删除分区数据插入到其他分区保证有序性，那么实现起来逻辑就会非常复杂。

# kafka 缺点

- 由于是批量发送，数据并非真正的实时；
- 对于 mqtt 协议不支持；
- 不支持物联网传感数据直接接入；
- 仅支持统一分区内消息有序，无法实现全局消息有序；
- 监控不完善，需要安装插件；
- 依赖 zookeeper 进行元数据管理；

# Kafka 中的 message 消息存放结构

> https://blog.csdn.net/hyj_king/article/details/105710993

# Kafka 3.3 使用 KRaft 共识协议替代 ZooKeeper

> https://zhuanlan.zhihu.com/p/583907614

