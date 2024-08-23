---
title: 我最近喜欢上了shell编程
description: "主要是想要推荐一下这个插件Codeium AI Coding Autocomplete and Chat"
date: 2024-08-23
slug: 2024-08-23-07-54-35
categories:
  - shell
---

# 背景

前一段时间我听v友安利，在vscode山安装了写代码自动完成插件

![](images/2024-08-23-08-02-03.png)

发现它的自动补全功能非常好用，工作中golang是我的主力开发语言，很多情况下，我都会优先使用golang完成我的工作，shell脚本使用的并不多

机缘巧合，有一次，我不得不使用shell来写一个优化我工作流的脚本，之前写shell脚本非常痛苦，对shell语法不熟，每次现写，都要现百度，才能找到我想要的语法。而这次，神奇的是，在我敲打几个字符之后，该插件就自动给我补全了一大堆逻辑，不到几分钟的时间，我就完成了一个脚本。而后，该脚本给我节省了大量的debug部署代码的时间。

# 好奇，工作流是什么

这个工作流是这样的，我们有一台test服务器，服务器上部署了我司全量服务，于是乎，当这台服务器给到其他人使用的时候，难免会遇到各种问题。定位问题、调试问题、解决问题，就需要一个强有力的后台汇聚各种信息到一起进行决策。

于是乎，我们的8874运维后台就出来了，至于为啥叫8874后台，因为啊，这个后台是web服务，服务的端口是8874，叫着叫着也就顺口了。

前面讲的都是废话，现在我们来看一下工作流，我们的这个后台啊，更新频繁，需要添加各种各样的功能，每次修改完代码，都需要

1. 打包程序以及资源文件
2. 上传到服务器
3. 解压到指定位置
4. 重启服务

执行这4步操作，是不是可以写一个脚本，自动化执行这4步操作呢
于是乎，这个脚本就在该插件的帮助下

# 这牛掰的脚本长啥样呢

脚本没有什么特别之处，但就是节省了我大量的部署时间

```sh
#!/bin/sh


function scp_and_install() {
    echo "scp_and_install ---> $1"
    echo "scp program_name.tar to ${1}..."
    ssh root@$1 "rm -rf /root/tmp && mkdir -p /root/tmp"
    scp -O program_name.tar root@$1:/root/tmp
    echo 'scp ok'

    echo 'tar -xf program_name.tar...'
    ssh root@$1 "rm -rf /root/tmp/dist"
    ssh root@$1 "tar -xf /root/tmp/program_name.tar -C /root/tmp/ --warning=no-unknown-keyword"
    echo 'tar ok'

    echo 'sh /root/tmp/dist/install.sh'
    ssh root@$1 "sh /root/tmp/dist/install.sh"
    echo 'install ok'

    echo 'systemctl restart program_name'
    ssh root@$1 "systemctl restart program_name"
    echo 'systemctl ok'
    echo ''
}

CURRENT_DIR=$(dirname "$0")
PWD=$(pwd)
echo 'building program_name...'
GOOS=linux sh $CURRENT_DIR/build.sh
echo 'build ok'

FILE=$PWD/config/test-ip-all.txt
if [ "0${1}" != "0" ]; then
    FILE=$PWD"/config/test-ip-"${1}".txt"
fi

LIST=$(cat $FILE)
echo ''

for i in ${LIST}; do
    scp_and_install $i
done

echo "all finish"
rm -rf program_name.tar program_name
```

# 更多脚本

## hugo博客自动生成post

```sh
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <category> <title>"
    exit
fi
CATEGORY=$1
TITLE=$2
SLUG=$(date +%Y-%m-%d-%H-%M-%S)
DATE=$(date +%Y-%m-%d)
mkdir -p ./content/post/$CATEGORY/$SLUG

YAML=$(cat content.template)
cp content.template ./content/post/$CATEGORY/$SLUG/index.md

if [ "$(uname)" = "Darwin" ]; then
    sed -i '' 's/SLUG/'${SLUG}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/DATE/'${DATE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/CATEGORY/'${CATEGORY}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i '' 's/TITLE/'${TITLE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
else
    sed -i 's/SLUG/'${SLUG}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/DATE/'${DATE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/CATEGORY/'${CATEGORY}'/g' ./content/post/$CATEGORY/$SLUG/index.md
    sed -i 's/TITLE/'${TITLE}'/g' ./content/post/$CATEGORY/$SLUG/index.md
fi


echo "File created: ./content/post/$CATEGORY/$SLUG/index.md"
code . ./content/post/$CATEGORY/$SLUG/index.md
hugo server
```

## 列举出hugo博客下的所有文章

```sh
#!/bin/bash

function print_file_title() {
    TITLE=$(grep -m 1 'title:' $1 | head -n 1 | cut -d':' -f2 | xargs)
    if [ ! -z "$TITLE" ]; then
        echo $TITLE"(${1})"
    fi
}

FILES=$(find ./ -name "*.md")
for file in $FILES
do
    print_file_title $file
done
```