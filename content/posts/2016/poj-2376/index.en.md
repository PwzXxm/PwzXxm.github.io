---
title: "POJ 2376 Cleaning Shifts"
date: 2016-03-16
draft: false

tags: ["Greedy", "POJ"]
---

\\(N\\) (\\(1 \le N \le 25,000\\)) cows, each cow only available for a interval of time.
\\(T\\) (\\(1 \le T \le 1,000,000\\)) shifts.
Find minimum number of cows to complete \\(T\\) shifts.

Link: http://poj.org/problem?id=2376


### Notes
- Each shift must has at least one cow assigned to it.
- A cow finishes after the end time. That is, if there are two cows, start and end at \\((1, 3)\\) and \\((4, 10)\\) respectively. It is considered as an continuous internal and accepted case for \\(T = 10\\).
- There can not have any gap between these cows's working intervals.
- Use `scanf()` for input otherwise it will run out of the time limit.

<br>
<br>
<br>
<br>
<br>

### Solution
Sort cows by ending time. Using greedy that for each interval, find the cow which has latest end time and before the current end time. As the vector is sorted, the first cow we find is the answer.


```cpp
#include<cstdio>
#include<vector>
#include<algorithm>
using namespace std;
typedef pair<int, int> P;


vector<P> v;
int N, T, ans = 0;

struct cmp {
	bool operator()(const P &l, const P &r) {
		return l.second > r.second;
	}
};
void solve() {
	sort(v.begin(), v.end(),cmp());
	int cur = 1;
	bool find = true;
	while (cur <= T) {
		if ((v.size() == 0) || !find || (v[0].second < cur)) { ans = -1; return ; }
		for (int i = 0; i < v.size(); i++) {
			if (v[i].first <= cur) {
				ans++;
				cur = v[i].second+1;
				printf("%d %d\n\n", v[i].first, v[i].second);
				v.erase(v.begin()+i);
				find = true;
				break;
			}
			find = false;
		}
	}
	return ;
}

int main(void) {
	scanf("%d %d", &N, &T);
	int start, end;
	for (int i = 0; i < N; i++) {
		scanf("%d %d", &start, &end);
		v.push_back(P(start, end));
	}

	solve();
	printf("%d\n", ans);

	return 0;
}
```
