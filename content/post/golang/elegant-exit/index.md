---
title: golang协程优雅推出
slug: golang-elegant-exit
date: 2024-07-17
categories:
  - Golang
tags:
  - 协程
---


golang优雅退出，配合`context.WithCancel` / `os.Signal` / `sync.WaitGroup` 使用，这篇文章就来介绍一下吧，话不多说，直接上代码

```go
package main

import (
    "context"
    "fmt"
    "os"
    "os/signal"
    "sync"
    "syscall"
)
func main() {
    root := context.Background()
    ctx, cancel := context.WithCancel(root)
    globalWg := new(sync.WaitGroup)

    // 启动endless任务
    go runEndlessTask(ctx, globalWg)

    // 监听退出信号
    signalChan := make(chan os.Signal, 1)
    signal.Notify(signalChan, syscall.SIGTERM, syscall.SIGINT, syscall.SIGQUIT, os.Interrupt)
    select {
    case <-signalChan:
        container.LogError(nil, "receive kill signal")
    }

    // 发送取消信号
    cancel()

    // 等待所有协程退出
    globalWg.Wait()

    fmt.Println("all goroutines exit")
}

func runEndlessTask(ctx context.Context, wg *sync.WaitGroup) {
    defer wg.Done()
    globalWg.Add(1)
// endless loop
loop:
    for {
        select {
        case <-ctx.Done():
            log.Info("runTask1 exit")
            break loop
        default:
          // handle something
        }
    }
    globalWg.Done()
}
```