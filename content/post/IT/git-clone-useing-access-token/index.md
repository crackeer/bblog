---
title: gitlab使用accessToken克隆代码
date: 2025-02-27
slug: git-clone-useing-access-token
categories:
  - IT
---

# 生成AccessToken

[![pE36wCj.png](https://s21.ax1x.com/2025/02/27/pE36wCj.png)](https://imgse.com/i/pE36wCj)


# 删除之前过期的token

```bash
git config --global --unset url."https://TOKEN_USER:TOKEN_VALUE@git.test.com/abcdef".insteadof
```


# 新增token

```bash
git config --global url."https://NEW_TOKEN_USER:NEW_TOKEN_VALUE@git.test.com/abcde".insteadof git@git.test.com:abcde
``
