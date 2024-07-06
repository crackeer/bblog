---
title: axios解决整数溢出
slug: axios-bigint
date: 2024-07-04
categories:
  - IT
tags:
  - node
  - axios
---

# 1. 引入json-bigint库文件

- npm包引入：[json-bigint](https://www.npmjs.com/package/json-bigint)
- 浏览器引入：[https://www.jsdelivr.com/package/npm/json-bigint-browser](https://www.jsdelivr.com/package/npm/json-bigint-browser)

# 2. 增加默认转换器

```js
// import = json-bigint-browser.min.js
axios.defaults.transformResponse = [function(data) {
    try {
        let result = JSONbig.parse(data)
        console.log(result)
        return result
    } catch (err) {
        console.log(err)
        return {
            data
        }
    }
}]
```