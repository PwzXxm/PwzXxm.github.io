# Notify Me on Slack when the GitHub Pull Request Merged


Tired of refreshing the GitHub web pages and waiting for the PR from colleagues to be merged.
Try to dump these things out of my head to concentrate on real work.

## Steps
There are only three steps and step 2 is optional.

1. Creating a Slack App via https://api.slack.com/messaging/webhooks. What you want is the Webhook URLs under **Incoming Webhooks** which starts with `https://hooks.slack.com/services/`, so that you can send the notification message to it.
2. Aware of the [Rate Limit of GitHub API](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api) and create a personal access token or creating GitHub Apps depending on your needs.
3. With help of ChatGPT and a few fixes, we derived at this script

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

After aliasing, you could do `ntfslk https://github.com/owner/repo/pull/123 &` to put it in the background.
When the script scans and finds out the PR is merged, a notification will pop up in the channel.

{{<image src="/notify-me-on-slack-when-the-github-pull-request-merged/msg.png" caption="Slack Message Example" alt="slack message example image">}}

If you need to mention someone in the channel, put `<@userID>` in the text. You could find the user ID or member ID in the Profile -> "three dots" -> Copy member ID.
