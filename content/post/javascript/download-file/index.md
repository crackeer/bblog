---
title: 使用NodeJS下载文件
date: 2024-07-26
slug: md-bookmark-parse
categories:
  - IT
tags:
  - javascript
  - axios
---

# 使用NodeJS解析JSON文件中的链接

```js
function extractURLs(data) {
    if (data == null) return []
    let retData = []
    // 对象
    if (typeof data == 'object' && data.length == undefined) {
        Object.keys(data).forEach(key => {
            if (typeof data[key] == 'string') {
                if (isURL(data[key])) {
                    retData.push(data[key])
                } else {
                    try {
                        let tmp = JSON.parse(data[key])
                        retData.push(...extractURLs(tmp))
                    } catch (e) {
                    }
                }

            } else if (typeof data[key] == 'object') {
                retData.push(...extractURLs(data[key]))
            }
        })
    }
    if (typeof data == 'object' && data.length != undefined) {
        for (let i in data) {
            retData.push(...extractURLs(data[i]))
        }
    }
    return retData
}
function isURL(str) {
    return str.indexOf("http://") == 0 || str.indexOf("https://") == 0
}
```

# 使用`axios`下载文件

```js
var download = async (url, dir) => {
    if (url.length < 1) {
        return
    }
    const fileName = dir + '/' + url.split('/').slice(-1)[0]
    console.log("downlaod=>", url, fileName)
    try {
        const res = await axios.get(url, {
            responseType: 'arraybuffer', // 特别注意，需要加上此参数
        });

        return fs.writeFileSync(fileName, res.data);
    } catch (error) {
        console.log(error)
    }
};
```