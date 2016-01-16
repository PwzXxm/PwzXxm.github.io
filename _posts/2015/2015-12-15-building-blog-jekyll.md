---
layout: post
title: "Using Jekyll + Github Pages to build a blog"
date: 2015-12-15
tags:
- blog
---

## Why Jekyll and Github Pages
[Jekyll](https://jekyllrb.com/) is an static site generator, it is simple to use with YAML front matter. It is quite convenient to blog with markdown and Jekyll supports it build-in. [Github Pages](https://pages.github.com/) provide the space to host the website for free. Both of them are well-documented, and works well with each other. One thing that makes they works well but not perfect is that although Github Pages can generate the website using Jekyll but as it generates in safe mode, it does not support Jekyll plugin. However, the good news is we can generate the site locally and then push it to Github. It sounds like not convenient but we can write a bash script to do so automatically in one step. We will talk about it later.


## Preparations
1. Know [YAML front matter](http://jekyllrb.com/docs/frontmatter/) is something you can put at the front of a script and it can automatically
    - have part of the layout and tags you defined before
    - define variables ([Liquid]tags(http://liquidmarkup.org/))
2. If you don't know HMTL, CSS or JavaScript, you would better check out [W3School](http://www.w3schools.com/) and at least know the basic of them.
3. Be able to using `git` commands, if not please check [Git tutorial](http://rogerdudler.github.io/git-guide/) or search on Google. You could use a desktop version instead of command lines, but I think it's better to try comment line once because it may help you to have a better understanding of how it works.

## Set up repository
Following the steps on [Github Pages](https://pages.github.com/) to initiate the repository. **Caution: If you are building user/organisation pages, please use `master` branch, if you are building project pages, please use `gh-pages` instead.**

## Install and Initiate
Steps are shown [here](https://help.github.com/articles/using-jekyll-with-pages/).

After installation, to initiate a basic theme Jekyll website at current folder, simply run

```
Jekyll new .
git init
```

If you have a error says the directory is not empty, just move all files to other directory and move them back after initiation.

## Running Jekyll and Test Websites Locally
If you use `bundler`, you need to use `bundle exec jekyll server` or `bundle exec jekyll serve`.<br>For those who don't, please use `jekyll server` or `jekyll serve`.

Leave command window as it is running and then open your browser and navigate to `http://localhost:4000` and you can see your site locally.

## Configuring
### \_config.yml file
`_config.yml` contains settings for the website, check out details at the official website [here](http://jekyllrb.com/docs/configuration/).

Variables | Usage
---|---
title | The title of the website, by default it will shown at the website and the search result in a search engine
email | It is used in the contact list if you choose to use it
description | By default it is used in the meta tag in the head and shown in the footer
baseurl | the subpath of your site, e.g. `/blog` will have `www.pwzxxm./com/blog`
url | the base hostname and protocol for the site, e.g. `http://www.pwzxxm.com`
github\_username<br>twitter\_username | shown in the contact list in the footer if you wish
markdown | which markdown engine you want to use, e.g. `kramdown` `redcarpet`
highlighter | which syntax highlighter you want to use, e.g. `pygments` `rouge`
permalink | set to `pretty` will have url like `site_url/time/title` <br> you can set your own like `/:title/` [See details](http://jekyllrb.com/docs/permalinks/)
pagination | the number of posts you want to display on each page

### Host your website using custom domain
- you need to buy a domain from a domain registrar, like [Godaddy](https://godaddy.com).
- add a `CNAME` file which contains your custom domain name in the root of your repository.
- If your custom domain is a subdomain (like `www.pwzxxm.com` or `blog.pwzxxm.com`), then you need to add a `CNAME` record in your domain provider or DNS server provider if you are using custom DNS service.
- If your domain is an apex domain (only have one dot in your custom domain), you need to set up `A`, `ALIAS` or `ANAME` records. Add `192.30.252.153` and `192.30.252.154` to your records.
- [Find more details](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/)

### Pagination
There are two basic scripts can do pagination on [Jekyll official documentation](http://jekyllrb.com/docs/pagination/).
However, I found this pagination from [Timble](http://www.timble.net/blog/2015/05/07/better-pagination-for-jekyll.html) which is awesome.

### Multi-language site
Check out [Jekyll Multi Language Plugin](http://jekyll-langs.liaohuqiu.net/).

### Build the site locally if you use plugins
The problem is Github build Jekyll websites in safe mode so the plugin won't work. However, we can create a 'dummy' repository to generate the site first and then move the content in `_site` folder to the original repository.

1. generate the site locally using `bundle exec jekyll serve build` or `jekyll build` in the 'dummy' repository.
2. copy all files to the actual repository excludes `README.md.`
3. cut the files under  `_site` folders to the root path of the repository.
4. `touch .nojekyll` to disable github to generate the site
5. commit all changes.

Here is a bash script:

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

To use it, simply copy it to a `yourchoice.sh` file, change the paths in the file and give it permission to run, and run it.

## This Site
If you like the style or you want to know the codes behind it, just check out:

- [Pwzxxm.github.io](https://github.com/PwzXxm/PwzXxm.github.io)
- [local site](https://github.com/PwzXxm/local-site).

You can grap and use any code from my site as you wish. However, the content of this site is copyright, if you want to use any posts please contact me.








