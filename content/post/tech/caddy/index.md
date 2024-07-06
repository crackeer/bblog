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

# 一、caddy 官方网站

- [https://caddyserver.com/docs/](https://caddyserver.com/docs/)

# 二、使用方式

## 1. 反向代理

```json
{
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
                                }，
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
                                            "dial": "localhost:9393"
                                        }
                                    ]
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

## 2. 静态资源

```json
{
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
                        }
                    ]
                }
            }
        }
    }
}
```

## 2. 正向代理

```json
{
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