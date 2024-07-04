---
title: gorm使用
slug: gorm-usage
date: 2024-06-30
categories:
  - Golang
tags:
  - gorm
---

# 一、介绍

- github：[https://github.com/go-gorm/gorm](https://github.com/go-gorm/gorm)
- 官网：[https://gorm.io/](https://gorm.io/)
- 纯go版本的sqlite驱动：[https://github.com/glebarez/sqlite](https://github.com/glebarez/sqlite)

## 工具
- 生成struct的工具：https://gorm.io/gen/

# 二、用法

## 1. `desc`获取表字段

```go
fields := []map[string]interface{}{}
// Sqlite
if err := req.DB.Raw(fmt.Sprintf("PRAGMA TABLE_INFO (%s)", req.Table)).Scan(&fields).Error; err != nil {
  return nil, err
}
// MySQL
if err := gormDB.Raw("desc " + table).Find(&fields).Error; err != nil {
  return
}
```

## 2. `show create table`

```go
data := map[string]interface{}{}
// SQLite
gormDB.Table("sqlite_master").Where(map[string]interface{}{
  "type": "table",
  "name": req.Table,
}).Scan(&data)
return data["sql"], nil
// MySQL
if err := req.DB.Raw("show create table " + req.Table).Scan(&data).Error; err != nil {
    return nil, err
}
if value, ok := data["Create Table"]; ok {
    if stringValue, ok := value.(string); ok {
       return stringValue, nil
    }
}
```

## 3. `show tables`

```go

list := []map[string]interface{}{}
retData := []string{}

// SQLite
if req.IsSQLite() {
  req.DB.Table("sqlite_master").Where(map[string]interface{}{
    "type": "table",
  }).Find(&list)
  for _, value := range list {
    for key, value := range value {
      if key == "name" {
        retData = append(retData, value.(string))
      }
    }
  }
  return retData, nil
}

// MySQL
if err := req.DB.Raw("show tables").Scan(&list).Error; err != nil {
  return nil, err
}
for _, value := range list {
  for _, value := range value {
    retData = append(retData, value.(string))
  }
}

```