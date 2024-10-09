---
title: "GitHub Pull Request 合并时在 Slack 上通知我"
date: 2024-10-08T18:21:55+08:00
draft: false

tags: ["Practice"]
---

厌倦了刷新 GitHub 网页和等待同事的 PR 合并。
试着把这些事情从我脑子里赶走，集中精力做真正的工作。

## 步骤
只需要三步

1. 通过 https://api.slack.com/messaging/webhooks 创建 Slack 应用程序。您需要的是在 **Incoming Webhooks** 下的 以 `https://hooks.slack.com/services/` 开头的 Webhook URL，以便向其发送通知消息。
2. 注意 [GitHub API 的速率限制](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api)，并根据需要创建个人访问令牌或创建 GitHub 应用程序。
3. 借助 ChatGPT 和一些修正，我们得到了以下脚本

```python
import requests
import argparse
import time
import re

# Could be none or personal access token https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api
GITHUB_TOKEN="<your_github_token>"
# On how to get webhooks token https://api.slack.com/messaging/webhooks
SLACK_WEBHOOK="https://hooks.slack.com/services/XXXXXXXXXXX/YYYYYYYYYY/ZZZZZZZZZZZZZZ"
WAIT_DURATION_SEC=600

def parse_args():
    parser = argparse.ArgumentParser(description='Check if a GitHub pull request was merged and send a Slack message.')
    parser.add_argument('pr_url', help='GitHub pull request URL.')
    return parser.parse_args()

def parse_pr_url(pr_url):
    """
    Parses the PR URL and returns the owner, repository, and PR number.

    Example URL: https://github.com/owner/repo/pull/123
    """
    pattern = r'https?://github\.com/(?P<owner>[^/]+)/(?P<repo>[^/]+)/pull/(?P<pr_number>\d+)'
    match = re.match(pattern, pr_url)
    if match:
        return match.group('owner'), match.group('repo'), int(match.group('pr_number'))
    else:
        raise ValueError('Invalid GitHub pull request URL.')

def check_if_pr_merged(owner, repo, pr_number, github_token=None):
    url = f'https://api.github.com/repos/{owner}/{repo}/pulls/{pr_number}'
    headers = {'Accept': 'application/vnd.github.v3+json'}
    if github_token:
        headers['Authorization'] = f'token {github_token}'
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        pr_data = response.json()
        return pr_data.get('merged', False)
    else:
        print(f'Error fetching PR data: {url} {response.status_code} {response.reason}')
        return False

def send_slack_message(slack_webhook_url, message):
    payload = {'text': message}
    response = requests.post(slack_webhook_url, json=payload)
    if response.status_code != 200:
        print(f'Error sending Slack message: {slack_webhook_url} {response.status_code} {response.reason}')

def main():
    args = parse_args()
    try:
        owner, repo, pr_number = parse_pr_url(args.pr_url)
    except ValueError as e:
        print(e)
        return

    print(f"Monitoring PR #{pr_number} in repository '{owner}/{repo}' for merge status.")

    while True:
        is_merged = check_if_pr_merged(owner, repo, pr_number, GITHUB_TOKEN)

        if is_merged:
            message = f'Pull request {args.pr_url} has been merged.'
            send_slack_message(SLACK_WEBHOOK, message)
            break
        else:
            time.sleep(WAIT_DURATION_SEC)

if __name__ == '__main__':
    main()
```

保存脚本并进行别名后，您可以使用 

```bash
ntfslk https://github.com/owner/repo/pull/123 &
```

将其置于后台，当扫描到 PR 合入时就会收到消息。

{{<image src="/notify-me-on-slack-when-the-github-pull-request-merged/msg.png" caption="消息示例" alt="slack message example image">}}

如果您需要提及频道中的某个人，请在`<@userID>`。您可以在简介->“三个点”->复制成员 ID 中找到用户 ID 或成员 ID。