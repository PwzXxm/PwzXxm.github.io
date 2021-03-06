---
title: "POJ 3187 Backward Digits Sums"
date: 2016-03-14
draft: false

tags: ["POJ"]
---

There are 1 to \\(N\\) digits (\\(1\le N \le 10\\)) in certain order. Add adjacent numbers together to get the next line, until the there is only one number left.(Just like Pascal's triangle)
For example, there are 3 integers:
$$ 1, 2, 3 $$
$$ 3, 5 $$
$$ 8 $$

So, given \\(N\\) and the final sum, find the lexicographically least ordering of integers.

Link: http://poj.org/problem?id=3187

### Notes:
- Be aware of that the question is asking 1 to \\(N\\) digits, so we don't have to test all possible permutations from 1 to 10.

- The results of `next_permutation()` in STL are in ascending order in default.

<br>
<br>
<br>
<br>
<br>

### Solution:
Use `next_permutation()` to check all possibilities and stimulate the triangle additions. Since the permutation is already in lexicographical order, when we get the find the first result, it is the final answer.


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
