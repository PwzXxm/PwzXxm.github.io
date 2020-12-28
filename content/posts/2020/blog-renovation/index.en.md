---
title: "Blog Renovation - From Jekyll to Hugo"
date: 2020-12-27T14:43:36+11:00
draft: false

tags: ["Blog"]
---

In the past years, the blog was generated using [Jekyll](https://jekyllrb.com/).
Recently, I decided to migrate to [Hugo](https://gohugo.io/) along with other changes, such as utilising discussion plugin [Valine](https://valine.js.org/). 

<!--more--> 

## Reasons
1. Hugo is written in Golang and it takes less time to build than Jekyll. This determines how fast the live edit will take place.
1. Some plugins in the old websites are outdated and hard to maintain.

## My Choice of Theme - LoveIt
[Lots of themes](https://themes.gohugo.io/) are available.
[LoveIt](https://themes.gohugo.io/loveit/) supports various tools and functionalities.
It is also highly configurable and customisable.
Check it out :+1:

## Valine + Valine Admin
The discussion system after the content of each post has been changed to [Valine](https://valine.js.org/).
The main reason for abandoning [Disqus](https://disqus.com/) is its accessibility from mainland China.

Valine is based on LeanCloud and it can be easily deployed as described in the [official quick start guide](https://valine.js.org/en/quickstart.html).

Valine does not have a built-in way to moderate comments.
This is when [Valine-Admin](https://github.com/DesertsP/Valine-Admin) comes into play.
It provides

- Email notification
- Comment moderation
- Spam filtering with [Akismet](https://akismet.com/)


{{< admonition tip "Failed to self-wake on LeanCloud">}}
Use [cron-job](https://cron-job.org/en/) or other third-party services.
{{< /admonition >}}

## Deploy Using GitHub Actions
There is a [guide](https://gohugo.io/hosting-and-deployment/hosting-on-github/) written by Hugo about how to host and deploy on GitHub by using a script.

I prefer to use GitHub Actions to deploy the site on `gh-pages` branch whenever the `main` branch got updated. The script below checkout the repository, setup Hugo, make it available on cache, build the site and push it to the `gh-pages` branch.

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

## Tips, Pitfalls and Final Thoughts

* While migrating from Jekyll to Hugo, the posts can be converted using these [tools](https://gohugo.io/tools/migrations/).
* Migrate Disqus comments to Valine using [disqus-to-valine](https://taosky.github.io/disqus-to-valine/).
* The lookup order for layouts and assets (css, scss) are root directory and then under `/themes/` folder. Therefore, if you want to customise anything in the theme, you can create a similar path on the root directory to overwrite the files in the theme.
* It is a bit odd how to support multilingual tags. You need to create a folder for each tag and then have a Markdown file containing its translation.

Hope you enjoy the design and the posts on PwzXxm :heart: :heart: :heart:
