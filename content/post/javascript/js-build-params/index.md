---
title: 按照JSON模版构建参数
date: 2024-07-30
slug: js-build-params
categories:
  - IT
tags:
  - javascript
  - lodash
---

# 使用loadash提取参数

```js

var lodash = require('lodash')
var buildParams = (data, struct) => {
    if (typeof struct == "string") {
        if (lodash.startsWith(struct, "@")) {
            return lodash.get(data, struct.substring(1))
        }    }
   
    if (typeof struct == 'object' && struct.length == undefined) {
        let retData = {}
        Object.keys(struct).forEach(key => {
            retData[key] = buildParams(data, struct[key])
        })
        return retData
    }
    if (typeof struct == 'object' && struct.length != undefined) {
        let retData = []
        for (var i in struct) {
            retData.push(buildParams(data, struct[i]))
        }
        return retData
    }
    return struct
}

```

# 使用该函数

```js

var inputJSON = {
    'abc': 32673,
    "666": 767,
    "simple": {
        "kud": 99
    }
}

var template = {
    "abb": true,
    "hhh": "@abc",
    "bbb": {
        "yyy": "@simple.kud"
    },
    "list" : [
        "@abc", "@abc"
    ]
}

let retData = buildParams(inputJSON, template)
console.log(retData)
```