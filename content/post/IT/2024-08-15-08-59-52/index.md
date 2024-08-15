---
title: Git删除大文件+记录
date: 2024-08-15
slug: 2024-08-15-08-59-52
categories:
  - IT
tags:
  - git
---


删除git中大文件+记录

- https://blog.csdn.net/HappyRocking/article/details/89313501

```bash
git rev-list --all | xargs -rL1 git ls-tree -r --long | sort -uk3 | sort -rnk4 | head -10
git filter-branch --tree-filter "rm -f {filepath}" -- --all
git push -f --all
```


