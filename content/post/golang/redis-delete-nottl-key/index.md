---
title: Golang扫描并删除Redis中没有设置过期时间的Key
date: 2025-02-26
slug: redis-delete-nottl-key
tags:
  - golang
  - redis
description: 在使用 Redis 做缓存时，会遇到一些没有设置过期时间的 Key，这些 Key 会一直存在于 Redis 中，导致 Redis 的内存占用越来越高，影响 Redis 的性能。
categories:
  - golang
  - redis
---

# 问题描述

在使用 Redis 做缓存时，会遇到一些没有设置过期时间的 Key，这些 Key 会一直存在于 Redis 中，导致 Redis 的内存占用越来越高，影响 Redis 的性能。

# 解决方案

使用 Golang 扫描 Redis 中的 Key，判断 Key 是否有过期时间，如果没有过期时间，则删除 Key。

# 代码实现

使用 Golang 的 Redis 客户端库，扫描 Redis 中的 Key，判断 Key 是否有过期时间，如果没有过期时间，则删除 Key。

```go
package main

import (
	"context"
	"fmt"
	"strings"
	"time"

	redisV8 "github.com/go-redis/redis/v8"
)

type RedisConfig struct {
	Host           string `json:"host"`
	Port           string `json:"port"`
	Password       string `json:"password"`
	DB             int    `json:"db"`
	ConnectTimeout int    `json:"connect_timeout"`
	ReadTimeout    int    `json:"read_timeout"`
	WriteTimeout   int    `json:"write_timeout"`
}

func InitRedis() *redisV8.Client {
	redisConfig := &RedisConfig{}
	return redisV8.NewClient(&redisV8.Options{
		DB:           redisConfig.DB,
		Addr:         fmt.Sprintf("%s:%s", redisConfig.Host, redisConfig.Port),
		DialTimeout:  time.Duration(redisConfig.ConnectTimeout*1000) * time.Millisecond,
		ReadTimeout:  time.Duration(redisConfig.ReadTimeout*1000) * time.Millisecond,
		WriteTimeout: time.Duration(redisConfig.WriteTimeout*1000) * time.Millisecond,
		Password:     redisConfig.Password,
	})
}

func main() {

	redisClient := InitRedis()

	var cursor uint64

	for {
		time.Sleep(time.Second * 1)

		var keys []string
		var err error

		keys, cursor, err = redisClient.Scan(context.TODO(), cursor, "", 1000).Result()
		if err != nil {
			fmt.Println("encounter err when checking scan with " + err.Error())
			continue
		}

		for _, key := range keys {
			handleKey(redisClient, key)
		}
		if cursor == 0 {
			break
		}
	}
}

func handleKey(client *redisV8.Client, key string) string {
	if ttl, err := client.TTL(context.TODO(), key).Result(); err == nil {
		if ttl.Seconds() < 0 && ttl.Seconds() == -1 {
			deleteResult, _ := client.Del(context.TODO(), key).Result()
			return 
		}
	}
}

```
