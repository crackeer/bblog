---
title: SQLite速查
date: 2024-08-15
slug: 2024-08-15-09-03-19
categories:
  - IT
tags:
  - sqlite
---

## SQLite速查表

> https://geektutu.com/post/cheat-sheet-sqlite.html
> SQLite教程：https://www.runoob.com/sqlite/sqlite-tutorial.html

## SQLite使用

- 删除Table

```sql
DROP TABLE table_name;
drop table if exists table_name;
```

- 修改table名字

```sql
ALTER TABLE UserInfo RENAME TO NewUserInfo;
```

- 增加字段

```sql
ALTER TABLE UserInfo ADD COLUMN Sex Text NOT NULL;
```

- 查看数据表字段

```sql
PRAGMA TABLE_INFO (UserInfo);
```

- 删除表字段:https://blog.csdn.net/gyymen/article/details/53534267