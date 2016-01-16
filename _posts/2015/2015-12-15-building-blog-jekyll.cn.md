---
layout: post
title: "使用Jekyll＋Github Pages搭建博客"
date: 2015-12-15
tags:
- blog
---

## 为什么选择 Jekyll 和 Github Pages
[Jekyll](http://jekyll.bootcss.com/)是一个静态网页生成器，使用YAML头信息可以很方便地使用各种布局，内置markdown，新的文章只需加入文件夹即可。[Github Pages](https://pages.github.com/)可以提供免费空间，免费无限流量来给网页当虚拟主机。他们俩配合起来相当默契，而且网上也有很多资料。但是有一点美中不足的是Github Pages是在安全模式下运行的，也就是说它并不支持Jekyll的插件。然而我们可以在本地带着插件生成好网站再放到Github上。虽然听起来不太方便，但是有脚本让我们一步实现。这点我们后面详细说。

## 准备
1. 了解[YAML front matter](http://jekyllrb.com/docs/frontmatter/)可以让包含头文件的文件自动：
    - 拥有部分或全部布局及定义的重复标签
    - 变量 ([Liquid](http://liquidmarkup.org/))
2. 如果完全不了解HTML, CSS和JavaScript, 请查看[W3School](http://www.w3schools.com/)，至少了解基本用法。
3. 了解`git`命令，如果不请查看[Git tutorial](http://rogerdudler.github.io/git-guide/)或者其他资料。希望能至少使用命令行一次了解流程，这对以后会有所帮助。

## 创建仓库
详细步骤在[这里](https://pages.github.com/)。

**如果是个人／机构网站，请使用`master`分支，如果是项目网站，请使用`gh-pages`分支**

## 安装和初始化
步骤在[Github help pages](https://help.github.com/articles/using-jekyll-with-pages/)有详细解释。

完成安装后，初始化Jekyll在当前文件夹使用基本主题，运行

```
Jekyll new .
git init
```

如果出现类似`directory is not empty`之类的错误，先把文件夹下的内容移动到该文件夹外的临时文件夹内，运行命令后再放回原来的文件即可。

## 本地运行Jekyll和测试网站
如果您是`bundler`使用者，请运行`bundle exec jekyll server`或者`bundle exec jekyll serve`.<br>如果不是，请运行`jekyll server`或者`jekyll serve`。

让命令运行(不要用ctrl+c终止命令)，打开网页浏览器，在地址栏输入`http://localhost:4000`，就能看见网站啦。

## 配置
### \_config.yml文件
`_config.yml`文件包含了网站设定，[官网](http://jekyll.bootcss.com/docs/configuration/)上有详细阐述。下面介绍基本用法:

变量 | 用法
---|---
title | 网站名，默认下将是网站在搜索引擎出现的名字
email | 在contac-list中显示的邮箱地址, 默认下出现在页脚
description | 网站描述，默认下将出现在页脚
baseurl | 网站的子路径, 例如设置成`/blog`，完整url将会变成`www.pwzxxm./com/blog`
url | 主机名和使用协议，完整url, 例如`http://www.pwzxxm.com`
github\_username<br>twitter\_username | 用于链接Github和Twitter, 默认下出现在页脚
markdown | 使用的markdown引擎, e.g. `kramdown` `redcarpet`
highlighter | 语法高亮引擎, e.g. `pygments` `rouge`
permalink | 设置为`pretty`url将变成这样`site_url/time/title` <br>可以自定义例如`/:title/` [查看详情](http://jekyllrb.com/docs/permalinks/)
pagination | 每页显示多少篇文章

### 使用自定义域名
官网提供了两个基本版的页数标示，[点这里](http://jekyll.bootcss.com/docs/pagination/)。 然而网上有适配移动端的[Timble](http://www.timble.net/blog/2015/05/07/better-pagination-for-jekyll.html)，非常赞。

### 多语言支持
请查看[Jekyll Multi Language Plugin](http://jekyll-langs.liaohuqiu.net/)。

### 如使用插件，在本地生成网站
简单的说就是另外创建一个“僵尸”仓库，先生成网站，再把`_site`文件夹下的文件放到原根目录然后禁止Github再次生成网站。

1. 在“僵尸”文件夹下执行`bundle exec jekyll serve build` or `jekyll build`。
2. 复制当前文件夹下所有文件到原仓库(****.github.io), 除了`README.md`。
3. 剪切原仓库的`_site`文件夹下所有文件到原仓库根目录。
4. `touch .nojekyll`禁止Github生成网站。
5. 提交所有到Github。

这是bash脚本：

```bash
#!/bin/bash

comment="$1"
push_commit="git commit -a -m '$comment'"

# commit and push changes
eval 'cd ~/git/local'  # modify PATH here
eval 'bundle exec jekyll build'
eval 'git add .'
eval $push_commit
eval 'git push --all origin'

# copy remove in pwzxxm.github.io
eval 'cd ~/git/PwzXxm.github.io' # modify PATH here
eval 'cp ./README.md ~/git/' # modify where you want to temporally put the README.md
eval 'rm -rf ./*'
eval 'cp -r ~/git/local/* ./' # modify PATH here
eval 'cp -r _site/* ./'
eval 'rm -rf _site/*'
eval 'cp ~/git/README.md ./' # put the file back
eval 'touch .nojekyll'

# commit and push changes
eval 'git add .'
eval $push_commit
eval 'git push --all origin'
echo "Done"
```

要使用它，复制上面代码到以`.sh`结尾的bash脚本文件中，修改路径，给权限，运行即可。

## 本站代码
如果想使用本站布局或想知道背后的代码，请访问

- [Pwzxxm.github.io](https://github.com/PwzXxm/PwzXxm.github.io)
- [local site](https://github.com/PwzXxm/local-site).

您可以使用关于本站的任何代码，但禁止转载本站内容。如有需要，请联系我。