---
title: "POJ 3050 Hopscotch"
date: 2016-03-14T22:22:00+11:00
draft: false

tags: ["POJ"]
---

There is a 5 * 5 array filled with integers. You can only go up, down, left and right. You can start on any point in the array and can only move 5 times. Therefore, you will get 6 integers.

Find the number of distinct integers you can constructed.

Link: http://poj.org/problem?id=3050

<br>
<br>
<br>
<br>
<br>

### Solution
I use a set to avoid same sequences. Since there are only 6 steps and the array is only 5*5, dfs each point, add into the set.

I used `to_string()` at first but got compile error on POJ, then I use `stringstream` but got TLE. DO NOT USE `sstream`, it's just too slow! Slower than molasses!

Finally, I got AC.


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
