---
title: 一段解析markdown中链接的JS代码
date: 2024-07-20
slug: md-bookmark-parse
categories:
  - IT
tags:
  - javascript
  - markdown

---

我们先有这样一段markdown文本，我们想从中提取出链接，以及它的分类

```md
# 社区

- [数字尾巴](https://www.dgtle.com/)
- [少数派](https://sspai.com/)
- [v2ex](https://v2ex.com/)
- [过早客](https://www.guozaoke.com/)
- [迪卡](https://dizkaz.com/)
- [值得一读的技术博客](https://daily-blog.chlinlearn.top/blogs/1)
- [下载无损Music](https://tools.liumingye.cn/music/#/)

# 学习

- [vocabulary词汇](https://www.vocabulary.com/lists/)
- [一个免费的纪录片网站](https://ihavenotv.com/)

```

然后，我就有了这样的代码，我觉得十分优雅，所以就记录下来了
```js
var tagRegex = /^#([\S\s]+)/;
var hrefRegex = /^\-\s\[([\S\w\s\W]*)\]\((\S+)\)/;
function parseBookmark(text) {
    let data = text.split('\n')
    let current_tag = '未知'
    let links = []
    for (let i = 0; i < data.length; i++) {
        let tags = data[i].match(tagRegex)
        if (tags !=null && tags.length != undefined && tags.length > 1) {
            current_tag = tags[1].trim()
        }
        let href = data[i].match(hrefRegex)
        if (href != null && href.length != undefined && href.length > 2) {
            links.push({
                title : href[1].trim(),
                href : href[2].trim(),
                tag : current_tag
            })
        }
    }
    return links
}
```

最后，我们看下最终的成品网站：[https://jstool.pages.dev/bookmark](https://jstool.pages.dev/bookmark)