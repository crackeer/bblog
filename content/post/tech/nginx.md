---
title: nginx常见配置
description: 重写path、设置跨域、设置简单的密码验证
slug: nginx-config
date: 2024-06-26
categories:
  - IT
tags:
  - nginx

---

# 一、去掉url的前缀

```nginx
server {
    listen       8080;
    server_name  localhost;
    root /root/your/path/out;
    location ~/page/(.*)$ { #前缀去掉
        rewrite ^\/page\/(.*)$ /$1.html break;
    }
}
```

# 二、不存在的文件，重定向

```nginx

server {
    listen       8080;
    server_name  localhost;
    root /root/your/path/out;
    location ~/(.*)$ {
        if (!-e $request_filename) {
            rewrite ^(.*)$ /$1.html break;
        }
    }
}
```

# 三、设置跨域

```nginx
server {
    listen       8080;
    server_name  localhost;

    add_header 'Access-Control-Allow-Origin' "$http_origin";
    add_header 'Access-Control-Allow-Headers' 'accept,os,accesstoken,content-Type,X-Requested-With,Authorization,apptype,appkey,devid,token,uid,versioncode,versionname,mfg,x-request-id,x-request-uid';
    add_header 'Access-Control-Max-Age' '2592000';
    add_header 'Access-Control-Allow-Methods' 'GET, PUT, OPTIONS, POST, DELETE';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'X-Content-Type-Options' 'nosniff';
    add_header 'X-XSS-Protection' '1; mode=block';
    add_header 'X-Frame-Options' 'SAMEORIGIN';
}
```

# 四、设置登录密码验证
