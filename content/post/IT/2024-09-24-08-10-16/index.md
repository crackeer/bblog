---
title: 树莓派折腾
date: 2024-09-24
slug: 2024-09-24-08-10-16
categories:
  - IT
---

# 一、没有屏幕如何连接Wifi

> 创建文件:`wpa_supplicant.conf`,文件内容如下，将该文件拷贝到树莓派的SD卡上

```conf
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="CMCC-xVZ5"
    psk="fhnuqzxe"
    priority=99
}
```

# 二、apt update很慢

> 参照：https://blog.csdn.net/qq_29855577/article/details/104719891