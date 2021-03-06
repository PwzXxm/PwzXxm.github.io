---
title: "POJ 3187 Backward Digits Sums"
date: 2016-03-14
draft: false

tags: ["POJ"]
---

有特定顺序1到\\(N\\)个数字(\\(1\le N \le 10\\))，将相邻的两个数字相加得到下一行，直到只剩下一个数字。类似于杨辉三角形。
$$ 1, 2, 3 $$
$$ 3, 5 $$
$$ 8 $$

给定\\(N\\)和最后的和sum，求字典序最小的一组整数。

链接：http://poj.org/problem?id=3187

### 助攻:
- 注意题目是问1到\\(N\\)个整数，不是从1到10内找出所有排列。
- STL中`next_permutation()`的结果默认是升序排列的。

<br>
<br>
<br>
<br>
<br>

### 题解:
用`next_permutation()`生成所有可能的排列，模拟计算三角形。因为排列本来就按字典序排列，找到的第一个解就是题目的解。


```cpp
#include<iostream>
#include<algorithm>
using namespace std;

int n, sum, ans[11], s[11];

void solve() {
	for (int i = 1; i <= n; i++) ans[i-1] = i;
	if (n == 1 && ans[0] == sum) {
		cout << sum << endl;
		return;
	}
	do {
		for (int i = 0; i < n-1; i++)
			s[i] = ans[i]+ans[i+1];
		for (int i = n-2; i >= 0; i--) {
			for (int j = 0; j < i; j++)
				s[j] = s[j]+s[j+1];
		}
		if (s[0] == sum) {
			for (int i = 0; i < n; i++) cout << ans[i] << " ";
			cout << endl;
			return;
		}
	} while (next_permutation(ans, ans+n));
}

int main(void) {
	cin >> n >> sum;
	solve();
	return 0;
}
```
