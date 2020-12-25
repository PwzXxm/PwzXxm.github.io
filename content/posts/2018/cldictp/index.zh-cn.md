---
title: "CLDictP: 命令行英文词典工具"
date: 2018-07-04
draft: false

tags: ["Perl"]
---

CLDictP是一个用Perl，韦氏词典API写的命令行英文词典工具。

这是我第一个用Perl写的小项目。每次想用[Quizlet](https://quizlet.com/)做Flashcard（抽认卡？）来记单词的时候，因为想有的地方要加粗之类的，手动很麻烦。而且查单词的时候打开在线词典，太懒了，就想着写一个小工具吧。

它使用了如下韦氏词典API:

- 韦氏学习词典

- 韦氏大学词典

每个词条包括:

- 音标
- 词性
- 语法
- 释义
- 常用用法
- 例句

所有搜索过的单词存在一个集合里，保存在`searched.txt`里。

新的搜索结果会使用特定格式被保存在`quizlet.txt`里：

- 单词和定义之间：`$`
- 卡片与卡片之间：`---`

## 用法

1. 获得API密匙：[DictionaryAPI](https://www.dictionaryapi.com/)
2. 在`api_template.json`中加入获得的密匙，更改文件名为`api.json`
3. 安装依赖模块：

    ``` bash
    $ cpan Term::ANSIColor Term::ReadKey LWP::UserAgent LWP::Protocol::https Readonly XML::LibXML JSON::XS Data::Dumper Set::Light
    ```

4. 运行脚本：

    ``` bash
    $ perl dict.pl
    ```

5. 使用`Ctrl+D`退出

## 演示

![demo_gif](CLDictP_demo.gif)

## 源码

源码在[Github](https://github.com/PwzXxm/CLDictP)