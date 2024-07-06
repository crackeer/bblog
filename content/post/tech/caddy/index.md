---
title: caddy使用
description: caddy常见使用方式, 反向代理, 静态资源
slug: caddy
date: 2024-07-05
categories:
  - IT
tags:
  - caddy

links:
  - title: caddyserver
    description: caddy docs
    website: https://caddyserver.com/docs/
---

# 一、caddy官方网站

- [https://caddyserver.com/docs/](https://caddyserver.com/docs/)

# 二、使用方式

## 1. 

```json fold="true"
{
    "admin": {
        "disabled": false,
        "listen": "0.0.0.0:2019",
        "enforce_origin": false,
        "origins": [
            ""
        ]
    },
    "apps": {
        "http": {
            "servers": {
                "static": {
                    "idle_timeout": 30000000000,
                    "listen": [
                        "0.0.0.0:80"
                    ],
                    "max_header_bytes": 10240000,
                    "read_header_timeout": 10000000000,
                    "routes": [
                        {
                            "match": [
                                {
                                    "host": [
                                        "simple.com"
                                    ]
                                }
                            ],
                            "handle": [
                                {
                                    "handler": "reverse_proxy",
                                    "upstreams": [
                                        {
                                            "dial": "localhost:9393"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "match": [
                                {
                                    "path_regexp": {
                                        "name": "iss",
                                        "pattern": "^/iss-vr-index"
                                    }
                                }
                            ],
                            "handle": [
                                {
                                    "handler": "reverse_proxy",
                                    "upstreams": [
                                        {
                                            "dial": "10.26.52.27:11111"
                                        }
                                    ]
                                }
                            ]
                        },
                        {
                            "match": [
                                {
                                    "host": [
                                        "www.simple.com"
                                    ]
                                }
                            ],
                            "handle": [
                                {
                                    "handler": "file_server",
                                    "root": "/your/patc",
                                    "browse": {
                                        "template_file": ""
                                    }
                                }
                            ],
                            "terminal": true
                        },
                        {
                            "match": [
                                {
                                    "header": {
                                        "proxy": [
                                            "simple"
                                        ]
                                    }
                                }
                            ],
                            "handle": [
                                {
                                    "handler": "reverse_proxy",
                                    "dynamic_upstreams": {
                                        "source": "a",
                                        "name": "proxy.host.com"
                                    },
                                    "headers": {
                                        "request": {
                                            "add": {
                                                "Host": [
                                                    "proxy.host.com"
                                                ]
                                            }
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                }
            }
        }
    }
}

```

## 2. 是谁
