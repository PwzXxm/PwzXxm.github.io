---
title: "POJ 3050 Hopscotch"
date: 2016-03-14T22:22:00+11:00
draft: false

tags: ["POJ"]
---

给一个5*5的数组，在里面填了整数。可选任意点作为起点，走动5次，只能往上下左右走，得到6个数字。

求有多少个不同的数字组合。

链接：http://poj.org/problem?id=3050

<br>
<br>
<br>
<br>
<br>

### 题解
用set来去重，因为只有6步和5*5的数组，dfs各个起点，加入set。

一开始用了`to_string()`结果CE，用了`stringstream`TLE。这次终于知道`sstream`多慢了。。。简直龟速。。。


```cpp
#include<iostream>
#include<set>
#include<string>
using namespace std;

set<string> ans;
int m[5][5];
const int dx[] = { 1, -1, 0, 0 };
const int dy[] = { 0, 0, 1, -1 };
string s;

void dfs(int x, int y, int n) {
	if (n == 0) {
		ans.insert(s);
		return;
	}
	for (int i = 0; i < 4; i++) {
		int tx = x+dx[i];
		int ty = y+dy[i];
		if (tx >= 0 && tx < 5 && ty >= 0 && ty < 5) {
			string str = s;
			s += m[tx][ty];
			dfs(tx, ty, n-1);
			s = str;
		}
	}
	return ;
}

int main(void) {
	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++)
			cin >> m[i][j];
	}

	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++) {
			s = "";
			dfs(i, j, 6);
		}
	}

	cout << ans.size() << endl;
	return 0;
}
```
