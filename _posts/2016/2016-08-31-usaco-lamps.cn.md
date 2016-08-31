---
layout: post
title: USACO Party Lamps
date: '2016-08-31'
tags: [USACO]
---

### 题意
有 N \\((10 \le N \le 100)\\) 盏亮瞎眼的灯，从 1 到 N 编号。

有四种按钮：

按钮 | 用途
--- | ---
1 | 反转所有的灯（开变为关，关变为开）
2 | 反转编号为奇数的灯（如 1，3，5）
3 | 反转编号为偶数的灯（如 2，4，6）
4 | 反转编号为 \\(3k+1 \; 当 \; k \ge 0\\) 的灯 （如 1，4，7）

<br>

给出 C（按下按钮的次数, \\(0 \le C \le 10000\\)）和一些灯最后的状态，找出所有组不同的灯的状态。

开始时所有灯都开着，\\(C = 0\\)。
<br>
<br>
<br>
<br>
<br>

### 题解
从题意中，我们可以知道：

1. 每6个灯是一组，因为按钮作用1，2，3的最小公倍数是6（按钮1改变每个灯，按钮2和3改变每2个灯中的一个，按钮4改变每3个灯中的1个）。

2. 如果按下同一个按钮两次，效果和不按该按钮相同。用逻辑符号表示，\\( \sim(\sim p) = p \\)。一个按钮只有开或关两种可能，一共4种按钮。所以，一共有 \\( 2^4 = 16 \\) 种可能。

那么，

- 当 \\(C = 0\\)，检查当前状态是否符合条件。
- 当 \\(C = 1\\)，按下每个按钮一次。
- 当 \\( C \ge 2 \\), 检查所有16种可能。

这是个练习 `bitset` 的好机会。原来是想把 `bitset` 放进 `set` 里的，后来发现 `set` 不支持对 `bitset` 进行排序。如果有谁知道怎么让它支持对 `bitset` 进行排序的，麻烦告诉我一下～

<br>

### 代码
```cpp
/*
ID: cepheid1
LANG: C++11
TASK: lamps
*/

#include<fstream>
#include<algorithm>
#include<bitset>
#include<vector>
#include<map>
#include<set>
#include<string>
using namespace std;
ifstream fin("lamps.in");
ofstream fout("lamps.out");

/* convert bitset to store in map and set to get ordered */
set<short> st;
map<short, string>mp;

bitset<6> bt; // simulates 6 lamps
bitset<4> light; // simulates 4 buttons
bool on[7], off[7];

int N, C, a;

bool chk_on() {
	for (int i = 0; i < 6 ; i++) {
		if (on[i] && !(bt[6-i-1])) return false;
	}
	return true;
}

bool chk_off() {
	for (int i = 0; i < 6 ; i++) {
		if (off[i] && (bt[6-i-1])) return false;
	}
	return true;
}

void op(int x) {
	switch(x) {
		case 1:
			bt.flip();
			break;
		case 2:
			for (int i = 1; i < 6; i+=2) bt.flip(i);
			break;
		case 3:
			for (int i = 0; i < 6; i+=2) bt.flip(i);
			break;
		case 4:
			bt.flip(2);
			bt.flip(5);
			break;
		default:
			break;
	}
}

int main(void) {
	fin >> N >> C;
	while (fin >> a && a != -1) {
	    if (a%6 == 0) on[5] = true;
        else on[(a%6-1)] = true;
	}
	while (fin >> a && a != -1) {
		if (a%6 == 0) off[5] = true;
        else off[(a%6-1)] = true;
	}
	fin.close();

	bt.set();

	if (C == 0) {
		if (chk_on() && chk_off()) {
			if (!st.count(bt.to_ulong())) {
				mp[(short)bt.to_ulong()] = bt.to_string();
				st.insert((short)bt.to_ulong());
			}
		}
	} else if (C == 1) {
		for (int i = 0; i < 4; i++) {
			bt.set();
			op(i);
			if (chk_on() && chk_off()) {
				if (!st.count(bt.to_ulong())) {
					mp[(short)bt.to_ulong()] = bt.to_string();
					st.insert((short)bt.to_ulong());
				}
			}
		}
	} else {
		for (int i = 0; i < 16; i++) {
			bt.set();
			light = i;
			for (int j = 0; j < 4; j++) {
				if (light[j]) op(j+1);
			}
			if (chk_on() && chk_off()) {
				if (!st.count(bt.to_ulong())) {
					mp[(short)bt.to_ulong()] = bt.to_string();
					st.insert((short)bt.to_ulong());
				}
			}
		}
	}

	if (st.empty()) {
		fout << "IMPOSSIBLE\n";
	} else {
		int len = 0;
		string s;
		for (auto i : st) {
			len = 0;
			s = "";
			while (len <= N) {
				s += (mp[i]);
				len += (mp[i]).size();
			}
			fout << s.substr(0, N) << endl;
		}
	}
	fout.close();
	return 0;
}
```
