---
title: Redis那些事儿
date: 2024-08-17
slug: 2024-08-17-07-21-56
categories:
  - IT
tags:
  - redis
---

# Redis 

> 命令参考:http://doc.redisfans.com/

# 单线程为何那么快

1. redis 是存储在内存上的，读写的话不会受到硬盘 I/O 速度的限制
2. 多路 IO 复用模型，非阻塞 IO 解释：多路：多网络连接 复用：复用同一个线程
3. 数据结构简单，对数据操作也简单
4. 采用单线程，避免了不必要的上下文切换和竞争条件，也不存在多进程或者多线程导致的切换而消耗 CPU，不用去考虑各种锁的问题，不存在加锁释放锁操作，没有因为可能出现死锁而导致的性能消耗；
5. 使用底层模型不同，它们之间底层实现方式以及与客户端之间通信的应用协议不一样，Redis 直接自己构建了 VM 机制 ，因为一般的系统调用系统函数的话，会浪费一定的时间去移动和请求；

# 支持的数据结构，底层实现

> https://zhuanlan.zhihu.com/p/145384563

# 持久化：AOF、RDB

> https://www.cnblogs.com/itdragon/p/7906481.html

# redis 使用，单机版、哨兵模式、集群

1. https://www.cnblogs.com/zhonglongbo/p/13128955.html

# 与 memcache 对比

# 实现分布式锁

1. https://juejin.cn/post/6844903830442737671

# 缓存雪崩、缓存穿透、缓存击穿

1. 缓存雪崩，是指在某一个时间段，缓存集中过期失效。
2. 缓存击穿，是指一个 key 非常热点，在不停的扛着大并发，大并发集中对这一个点进行访问，当这个 key 在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一个屏障上凿开了一个洞
3. 缓存穿透，是指查询一个数据库一定不存在的数据。正常的使用缓存流程大致是，数据查询先进行缓存查询，如果 key 不存在或者 key 已经过期，再对数据库进行查询，并把查询到的对象，放进缓存。如果数据库查询对象为空，则不放进缓存。

# Redis 的应用场景

> 热点数据缓存、发布订阅、队列、分布式锁、登录 Token

# Redis 支持的数据类型（必考）

> https://www.cnblogs.com/ysocean/p/9080942.html

- String，字符串
- Hash，HashMap
- List, 列表
- Set，集合
- ZSet，有序集合

# Redis 的数据过期策略 + Redis 的 LRU 过期策略的具体实现

1. https://zhuanlan.zhihu.com/p/152643114
2. https://www.cnblogs.com/xuliangxing/p/7151812.html

# 如何解决 Redis 缓存雪崩，缓存穿透问题

1. 缓存雪崩，是指在某一个时间段，缓存集中过期失效。
2. 缓存击穿，是指一个 key 非常热点，在不停的扛着大并发，大并发集中对这一个点进行访问，当这个 key 在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一个屏障上凿开了一个洞
3. 缓存穿透，是指查询一个数据库一定不存在的数据。正常的使用缓存流程大致是，数据查询先进行缓存查询，如果 key 不存在或者 key 已经过期，再对数据库进行查询，并把查询到的对象，放进缓存。如果数据库查询对象为空，则不放进缓存。

# Redis的管道pipeline

# Redis 集群

> https://juejin.im/entry/596343056fb9a06bc340ac15

# redis 支持的数据类型

> https://www.cnblogs.com/dijia478/p/8058775.html

# redis 分布式锁解决方案

> https://www.cnblogs.com/cxyyh/p/11132161.html > https://cloud.tencent.com/developer/news/241627

# 悲观锁、乐观锁

> https://blog.csdn.net/yanghan1222/article/details/80449528

# redis 过期策略

> https://www.cnblogs.com/zjoch/p/11149278.html

​- redis 的过期策略就是：定期删除 + 惰性删除

# 内存淘汰机制

- `noeviction`：当内存不足以容纳新写入数据时，新写入操作会报错。这个一般很少用。
- `allkeys-lru`：当内存不足以容纳新写入数据时，在键空间中，移除最近最少使用的 key，这个是最常用的。
- `allkeys-random`：当内存不足以容纳新写入数据时，在键空间中，随机移除某个 key。
- `volatile-lru`：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，移除最近最少使用的 key。
- `volatile-random`：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，随机移除某个 key。
- `volatile-ttl`：当内存不足以容纳新写入数据时，在设置了过期时间的键空间中，有更早过期时间的 key 优先移除。

