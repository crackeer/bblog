---
title: Nsq测试环境构建，golang消费
date: 2025-03-05
slug: nsq-test
categories:
  - Golang
  - Nsq
tags:
  - Golang
  - Nsq
  - 队列
---

# 一、 安装 nsq

## 1. 下载 nsq 镜像

```shell
docker pull nsqio/nsq
```

## 2. compose 文件

```yml
vrsion: "3"
services:
  nsqlookupd:
    image: nsqio/nsq
    command: /nsqlookupd
    ports:
      - 4160:4160
      - 4161:4161
  nsqd:
    image: nsqio/nsq
    command: /nsqd --lookupd-tcp-address=nsqlookupd:4160 --lookupd-http-address=192.168.10.9:4161
    depends_on:
      - nsqlookupd
    ports:
      - 4150:4150
      - 4151:4151
  nsqadmin:
    image: nsqio/nsq
    command: /nsqadmin --lookupd-http-address=nsqlookupd:4161
    depends_on:
      - nsqlookupd
    ports:
      - 4171:4171
```

## 3. 启动

```shell
docker-compose up -d
```

# 二、 Golang 代码测试

## 1. 生产者

```go
package main

import (
	"fmt"
	"log"

	"github.com/nsqio/go-nsq"
)

func main() {
	// Instantiate a producer.
	config := nsq.NewConfig()
	producer, err := nsq.NewProducer("192.168.2.189:4150", config)
	if err != nil {
		log.Fatal(err)
	}

	topicName := "TOPIC_DATA_FILEPATH_440000dzHc"

	// Synchronously publish a single message to the specified topic.
	// Messages can also be sent asynchronously and/or in batches.
	for i := 0; i < 10; i++ {
		messageBody := []byte(fmt.Sprintf("Message %d", i+1))
		err = producer.Publish(topicName, messageBody)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println("Message published successfully")

	}

	// Gracefully stop the producer when appropriate (e.g. before shutting down the service)
	producer.Stop()
}
```

## 2. 消费者

```go
package main

import (
	"fmt"
	"time"

	"github.com/nsqio/go-nsq"
)

type GdNsqConfig struct {
	Host      string `json:"host"`
	Port      string `json:"port"`
	Topic     string `json:"topic"`
	Channel   string `json:"channel"`
	NotifyURL string `json:"notify_url"`
}

var (
	nsqConfig *GdNsqConfig = &GdNsqConfig{
		Host:      "192.168.2.189",
		Port:      "4150",
		Topic:     "TOPIC_DATA_FILEPATH_440115cVHz",
		Channel:   "test",
	}
)

func checkError(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func main() {

	config := nsq.NewConfig()
	consumer, err := nsq.NewConsumer(nsqConfig.Topic, nsqConfig.Channel, config)
	checkError(err)

	consumer.AddHandler(&myMessageHandler{})
	err = consumer.ConnectToNSQD(fmt.Sprintf("%s:%s", nsqConfig.Host, nsqConfig.Port))
	checkError(err)
	ticker := time.NewTicker(100 * time.Second)
	select {
	case <-ticker.C:
		fmt.Println("ticker stop")
	}
	consumer.Stop()
}

type myMessageHandler struct{}

// HandleMessage implements the Handler interface.
func (h *myMessageHandler) HandleMessage(m *nsq.Message) error {

	fmt.Println(string(m.Body))

	return nil
}
```
