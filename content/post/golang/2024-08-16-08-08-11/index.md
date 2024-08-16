---
title: Golang一些基础知识
date: 2024-08-16
slug: 2024-08-16-08-08-11
categories:
  - golang
---

# 有趣的知识点
* https://blog.csdn.net/qq_43716830/article/details/124405506

# new() 与 make() 的区别

> new 的作用是初始化一个指向类型的指针(*T)，make 的作用是为 slice，map 或 chan 初始化并返回引用(T)

# gc垃圾回收，三色标记

> https://juejin.im/post/5d56b47a5188250541792ede

# 逃逸分析

> https://blog.csdn.net/weixin_44065217/article/details/122482368
> 逃逸分析是编译器用来确定由程序创建的值所处位置的过程。具体来说，编译器执行静态代码分析，以确定是否可以将值放在构造函数的栈(帧)上，或者该值是否必须“逃逸”到堆上。在Go中，没有关键字或函数可以用于在此决策中指导编译器。只有通过你写的代码来分析这一点

* 逃逸分析的好处是为了减少gc的压力，不逃逸的对象分配在栈上，当函数返回时就回收了资源，不需要gc标记清除。
* 逃逸分析完后可以确定哪些变量可以分配在栈上，栈的分配比堆快，性能好
* 同步消除，如果你定义的对象的方法上有同步锁，但在运行时，却只有一个线程在访问，此时逃逸分析后的机器码，会去掉同步锁运行。

# 调度模型、调度器，GMP，netpoller

1. https://wudaijun.com/2018/01/go-scheduler/
2. https://zhuanlan.zhihu.com/p/108603451
3. http://hushi55.github.io/2015/12/08/golang-G-P-M
4. https://pandaychen.github.io/2020/02/28/GOMAXPROCS-POT/

# chan原理

* https://blog.csdn.net/weixin_42309691/article/details/125694412
* https://www.cnblogs.com/haiyux/p/15161495.html

```go
type hchan struct {
    qcount uint // 队列中的总元素个数
    dataqsiz uint // 环形队列大小，即可存放元素的个数
    buf unsafe.Pointer // 环形队列指针
    elemsize uint16 //每个元素的大小
    closed uint32 //标识关闭状态
    elemtype *_type // 元素类型
    sendx uint // 发送索引，元素写入时存放到队列中的位置

    recvx uint // 接收索引，元素从队列的该位置读出
    recvq waitq // 等待读消息的goroutine队列
    sendq waitq // 等待写消息的goroutine队列
    lock mutex //互斥锁，chan不允许并发读写
}
```

# init函数要点知识

> https://blog.csdn.net/liuyuede123/article/details/127394496

* init函数先于main函数自动执行，不能被其他函数调用；
* init函数没有输入参数、返回值；
* 每个包可以有多个init函数；
* 包的每个源文件也可以有多个init函数，这点比较特殊；
* 同一个包的init执行顺序，golang没有明确定义，编程时要注意程序不要依赖这个执行顺序。
* 不同包的init函数按照包导入的依赖关系决定执行顺序。

# 值类型和引用类型

* 值类型 ： 基本数据类型int、float、bool、string以及数组和struct
* 值类型：变量直接存储，内存通常在栈中分配。
* 引用类型：指针、slice、map、chan等都是引用类型
* 引用类型：变量存储的是一个地址，这个地址存储最终的值。内存通常在堆上分配。通过GC回收

# rune和byte的区别

* https://www.jianshu.com/p/4fbf529926ca

# 调度器

* [GO SCHEDULER](https://www.dazhuanlan.com/2019/12/12/5df121e8a157b/)
* [Golang调度器源码分析](http://ga0.github.io/golang/2015/09/20/golang-runtime-scheduler.html)


# map的底层实现

* 参考[Go语言map底层实现](https://i6448038.github.io/2018/08/26/map-secret/)
* [大话图解golang map源码详解](https://www.linkinstar.wiki/2019/06/03/golang/source-code/graphic-golang-map/)
* [https://github.com/qcrao/Go-Questions/tree/master/map](https://github.com/qcrao/Go-Questions/tree/master/map)
* [https://github.com/cch123/golang-notes/blob/master/map.md](https://github.com/cch123/golang-notes/blob/master/map.md)
* [https://draveness.me/golang-hashmap](https://draveness.me/golang-hashmap)
* [https://lukechampine.com/hackmap.html](https://lukechampine.com/hackmap.html)

# `defer` / `panic` / `recover`

> 在golang当中，defer代码块会在函数调用链表中增加一个函数调用。这个函数调用不是普通的函数调用，而是会在函数正常返回，也就是return之后添加一个函数调用。因此，defer通常用来释放函数内部变量

* 当defer被声明时，其参数就会被实时解析

> 函数返回的过程是这样子的：先给返回值赋值，然后调用defer表达式，最后才是返回到调用函数中。

* defer执行顺序为先进后出


# 私有仓库不支持https，如何拉取

> https://www.cnblogs.com/hiwz/p/12652153.html

# Gorm使用sqlite(纯GO)

> https://github.com/go-gorm/sqlite

```go
import (
  "github.com/glebarez/sqlite"
  "gorm.io/gorm"
)

db, err := gorm.Open(sqlite.Open("gorm.db"), &gorm.Config{})
```

# go http请求代理

- https://www.php.cn/faq/535203.html