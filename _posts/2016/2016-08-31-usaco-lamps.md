---
layout: post
title: USACO Party Lamps
date: '2016-08-31'
tags: [USACO]
lang: en
---

A set of N \\((10 \le N \le 100)\\) lamps, numbered from 1 to N.

Four types of button:

Button type | Usage
--- | ---
1 | flip all lamps (On to Off, Off to On)
2 | flip odd numbered lamps (e.g. 1, 3, 5)
3 | flip even numbered lamps (e.g. 2, 4, 6)
4 | flip \\(3k+1 \; with \; k \ge 0\\) numbered lamps (e.g. 1, 4, 7)

<br>

Given C (number of button presses, \\(0 \le C \le 10000\\)) and final state of some of the lamps, find all possible distinct configuration.

At the start, all lamps are ON and \\(C = 0\\).
<br>
<br>
<br>
<br>
<br>

###Solution
From the description, we can know that:

1. Every 6 lamps is a loop, because the least common multiple of 1, 2, 3 (button 1 changes every lamps, button 2 changes one of 2 lamps and button 3 changes one of 3 lamps) is 6.

2. If you press the same button twice, it has the same affect that if you don't press the button. In logic symbols,  \\( \sim(\sim p) = p \\). A button only can be switched on or off, and there are 4 types of buttons. Therefore, there are \\( 2^4 = 16 \\) possibilities.

Then

- for \\(C = 0\\), check current state
- for \\(C = 1\\), press each button once
- for \\( C \ge 2 \\), check every 16 possibilities.

It is a good opportunity to practice `bitset` though. Take care that bitset does not have build-in sort supported in `set` and I don't know how to let `set` :(

<br>

###Code
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
