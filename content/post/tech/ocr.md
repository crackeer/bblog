---
title: 搭建自己的OCR服务
description: 如何自己搭建一个OCR识别服务，其实很简单啊
slug: ocr-service
date: 2024-06-26
categories:
  - IT
tags:
  - OCR

links:
  - title: OCR-百度百科
    website: https://baike.baidu.com/item/光学字符识别/4162921
  - title: tesseract-ocr
    website: https://github.com/tesseract-ocr/tesseract
    image: https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png


---

# 一、在线的OCR网站

- https://www.imagetotext.io/

# 二、OCR识别软件testract-ocr

> 备注：目前暂不支持中文文本识别

## 1. github地址

- https://tesseract-ocr.github.io/

## 2. 本地bin安装使用

安装文档：[https://tesseract-ocr.github.io/tessdoc/Installation.html](https://tesseract-ocr.github.io/tessdoc/Installation.html)

## 3. golang中使用

参照github：[https://github.com/otiai10/gosseract](https://github.com/otiai10/gosseract)

## 4. nodejs中使用

参照：[Tesseract.js多线程实现ocr文字识别](https://blog.csdn.net/weixin_43935293/article/details/130509565)
参照：[Node.js 如何实现OCR文字识别](https://blog.csdn.net/weixin_50814640/article/details/129449486)