---
title: 磁盘快满了，使用shell找出大文件
date: 2024-08-01
slug: 2024-08-01-22-04-31
categories:
  - IT
tags:
  - shell
---

# 1. 首先使用`df -h`查看磁盘空间

![image.png](https://ossk.cc/file/dc9a8bae9f85a802e37ca.png)

# 2. 查看对应的文件夹占用空间

- 例如查看当前文件夹占用空间:`du -h --max-depth=1 ./`

![image.png](https://ossk.cc/file/92d2c86c31e0d1bbe626e.png)

- 按照文件占用大小空间进行**排序**

```sh
du -h --max-depth=1 ./ | sort -rh
```

![image.png](https://ossk.cc/file/21c50e7b9a6c52deb572a.png)