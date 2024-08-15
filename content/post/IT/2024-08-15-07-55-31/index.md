---
title: Docsify文档生成工具折腾之旅
date: 2024-08-15
slug: 2024-08-15-07-55-31
categories:
  - IT
tags:
  - docsify
---

# Docsify

大道至简，第一次看到这个完全由前端渲染的文档生成工具，就喜欢上了，配合Github Pages，简直完美,这是它的官网：https://docsify.js.org/#/

# 一、用到的JS+CSS列表如下

## 1. 核心文件啊

| 文件| 说明| 下载 |
| -- | -- |--|
|docsify@4.js|核心`docsify.js`文件|暂无|
|vue.css / theme-simple.css | 主题css文件 | 暂无|
|docsify-tabs@1.js | 插件展示Tab切换 |暂无|
|docsify-copy-code.js | code代码复制按钮插件|暂无|
|zoom-image.min.js | 图片缩放插件 | 暂无|
|docsify-hide-code.min.js | code代码过长？该插件可隐藏 | 暂无 |

## 2. 代码高亮
可根据自己的编程喜好自行选配啊，以下为我本人的选择
```text
prism-go.min.js
prism-json.min.js
prism-textile.min.js
prism-ini.min.js
prism-php.min.js
prism-javascript.min.js
prism-bash.min.js
prism-nginx.min.js
prism-toml.min.js
prism-docker.min.js
```

## 3. 可选插件
一开始我装上了，后面又干掉了，花里胡哨，简单最好了
- 字数统计插件
- 文档搜索插件
- 增加上一页 / 下一页

# 二、配置

```js
window.$docsify = {
    name: "RDBook", // 文档名字，展示在sidebar顶部，没有的话则不会展示
    homepage: 'README.md', // 目录的主markdown文件名字
    basePath: "/docs", // markdown文档的前缀路径
    loadNavbar: 'navbar.md', // 加载顶部的的
    loadSidebar: false, // 加载左侧文档目录的文件名，如果为false，则不加载目录，只展示当前MD文件的瞄点
    hideSidebar: true, // 是否隐藏左边的目录，针对只想展示单页markdown（）
    subMaxLevel: 2, // 生成文档锚点的最大深度
    repo: 'https://github.com/crackeer', // 右上角github地址
    auto2top: true,
    themeColor: '#0066CC',
    tabs: {
        persist: true,      // default
        sync: true,      // default
        theme: 'classic', // default
        tabComments: true,      // default
        tabHeadings: true       // default
    },
    hideCode: { // 代码隐藏配置
        scroll: false, // Enable scrolling
        height: 220 // Max height，超过该高度，则隐藏
    }
}
```

# 三、样式调整

- 主体背景色
- Table border
- 图片居中展示
- a链接：去下划线
- a链接：hover变色
- MD文档宽度

**最终css文件内容如下：**
```css
@media screen and (max-width: 500px) {
    :root {
        --content-max-width: 100%!important;
    }
}
@media screen and (min-width: 500px) {
    :root {
        --content-max-width: 85%!important;
    }
}

:root {
    --var-bg-color: #0066CC!important;
    --heading-color: var(--var-bg-color);
    --copycode-background: var(--var-bg-color);
    --code-inline-color: red!important;
    --code-inline-background: white!important;
    --link-color: var(--var-bg-color);
    --link-text-decoration-color--hover: gray!important;
    --sidebar-nav-strong-margin: 0px!important;
    --sidebar-nav-strong-padding: 10px 0px 8px 0px!important;
    --sidebar-nav-strong-font-size: 16px!important;
}

a {
    text-decoration: none !important;
}

a:hover {
    color: red !important;
}

body {
    --docsifytabs-border-color: var(--var-bg-color);
    --docsifytabs-tab-highlight-color: var(--var-bg-color);
    --sidebar-nav-link-color--active: var(--var-bg-color);
}

img:not(.emoji) {
    margin: 0 auto;
    display: block;
    width: 50%;
}

table tr,
table tbody {
    border: 1px solid #CCCCCC!important;
}
```

> 备注：做完这些调整，舒坦了，可以开开心心写文档了



