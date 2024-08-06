---
title: NodeJS快速查询MySQL
date: 2024-08-06
slug: 2024-08-06-17-10-02
categories:
  - nodejs
tags:
  - mysql
---


# 一、Install 

> https://github.com/ali-sdk/ali-rds

```sh
npm install ali-rds
```

# 二、使用

## 1.连接数据库

```js
const rds = require('ali-rds');
const db = rds({
    host: '10.26.62.5',
    port: '10656',
    user: 'root',
    password: 'simple',
    database: 'database', 
})
```

## 2. Select查询

```js
let res = await db.select('work', {
    where : {
        status : 1
    },
    limit : 3,
    columns: ['author', 'title'],
    orders: [['id', 'desc']]
})
let list = JSON.parse(JSON.stringify(res))
```

## 3. Insert插入

```js
const row = {
  name: 'fengmk2',
  otherField: 'other field value',
  createdAt: db.literals.now, // `now()` on db server
  // ...
};
const result = await db.insert('table-name', row);
console.log(result);
```

## 4. Update更新

```js
let res = await db.update("simple_table", {
    config : JSON.stringify(config),
    status : 5,
    source : '',
    description : '',
    name : templateName,
}, {
    where : {
        id : styleID
    }
})
let list = JSON.parse(JSON.stringify(res))
```

## 5. 直接执行SQL

```js
let res = await db.query("UPDATE work SET `status` = 2 WHERE id = 21875631 AND project_id = 'auto3d-lheHqcLzSWv-w4BY4r9lT9';")
```