---
title: 使用JS和浏览器交互
description: 爬虫，或者截图
date: 2024-08-14
slug: 2024-08-14-14-06-42
categories:
 - javascript
tags:
 - puppeteer
---

# 使用puppeteer爬网页内容

```js
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();
    let res1 = await page.goto('https://baidu.cn/gXQQ4RdB', {
        waitUntil: 'networkidle2',
    });
    let c = await page.setCookie({
      name : "admintoken",
      value : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
      path : "/",
      domain : ".realsee.com",
      expires : 1656070075
   })
    console.log("Finished");
    const aHandle = await page.evaluateHandle(() => window.shareConfig);
    console.log(await aHandle.jsonValue());
})();
```

## 使用pageres截图

```js
const Pageres = require('pageres');

(async () => {
	await new Pageres({delay: 2}).src('https://sindresorhus.com', ['1280x1024', '1920x1080'])
		.src('data:text/html,<h1>Awesome!</h1>', ['1024x768'])
		.dest(__dirname)
		.run();

	console.log('Finished generating screenshots!');
})();
```