---
title: "博客装修啦 - 从 Jekyll 到 Hugo"
date: 2020-12-28T17:54:42+11:00
draft: false

tags: ["Blog"]
---

过去几年这个博客一直用的 [Jekyll](https://jekyllrb.com/) 来生成。
最近我决定把它迁移到 [Hugo](https://gohugo.io/) 上，把评论系统也换成了 [Valine](https://valine.js.org/)。

<!--more--> 

## 原因
1. Hugo 使用 Golang 写的，生成速度比 Jekyll 快很多。这决定了编辑的时候多久能在本地看到效果。
1. 老版本上一些插件很久没有更新，变得很难维护。

## 我的主题选择 - LoveIt
官网上有[很多主题](https://www.gohugo.org/theme/)可以选择。
[LoveIt](https://github.com/dillonzq/LoveIt/blob/master/README.zh-cn.md) 支持很多好用的工具和功能。整个主题也很容易自定义。快看看吧 :+1:

## Valine + Valine Admin
每篇文章下面的评论系统换成了 [Valine](https://valine.js.org/)。
放弃 [Disqus](https://disqus.com/) 的原因主要是有些地方对它的限制。
Valine 基于 LeanCloud, 按照官网的[快速开始](https://valine.js.org/quickstart.html)只需要几步就能轻松部署。

Valine 并没有内置的评论管理系统。这就需要在 LeanCloud 上部署另一个服务———— [Valine-Admin](https://github.com/DesertsP/Valine-Admin)。它支持

- 新评论邮件提醒
- 评论管理
- 垃圾评论过滤（通过 [Akismet](https://akismet.com/)）

{{< admonition tip "LeanCloud 上出现因为流控原因唤醒失败">}}
使用 [cron-job](https://cron-job.org/en/) 或其他第三方服务。
{{< /admonition >}}

## 使用 GitHub Actions 进行部署
Hugo 的[官网](https://gohugo.io/hosting-and-deployment/hosting-on-github/)上有关于如何在 GitHub 上进行通过脚本进行部署的例子。

我更喜欢用 CI，比如 GitHub Actions 来部署。每次在 `main` 分支上有改动就能自动部署到 `gh-pages` 分支上。下面这个 yaml 文件描述了部署过程。

```yaml
name: deploy

on:
  push:
    branches:
      - main  # Set a branch to deploy

jobs:
  deploy:
    runs-on: ubuntu-18.04
    steps:
      - uses: actions/checkout@v2
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: 'latest'
          extended: true

      - uses: actions/cache@v2
        with:
          path: /tmp/hugo_cache
          key: ${{ runner.os }}-hugomod-${{ hashFiles('**/go.sum') }}
          restore-keys: |
            ${{ runner.os }}-hugomod-

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          cname: example.com # CHANGE THIS
```

## 一些经验和踩过的坑

* 在从 Jekyll 迁移到 Hugo 的时候，文章可以使用一些[自动化工具](https://gohugo.io/tools/migrations/)。
* 之前在 Disqus 的评论可以通过 [disqus-to-valine](https://taosky.github.io/disqus-to-valine/) 来迁移。
* 模板（layouts）和样式（css、scss）的查找顺序是先查看根目录，再查看 `themes` 下的目录。所以如果想对主题有什么更改，可以在根目录下创建相似的路径，然后自定义。
* 对于标签（tags）的多语言支持有点奇怪。你需要在 `/content/tags/` 目录下对于每一个标签创建一个文件夹，在文件夹下创建对应语言的 `.md` 文件，里面写上翻译。

希望新博客的样式和内容你们能够喜欢 :heart: :heart: :heart:
