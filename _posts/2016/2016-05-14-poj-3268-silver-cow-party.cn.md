---
layout: "post"
title: "POJ 3268 Silver Cow Party"
date: "2016-05-14"
tags:
- POJ
- Graph
---

###题意
有 N (\\(1 \le N \le 1000\\)) 个农场， 每个农场有1只奶牛去X号农场参加派对。每只奶牛都要走最短路来回。一共有 M (\\(1 \le M \le 100,000\\))单向道路，每条道路的权值为所用的时间。求往返所用的最长时间。

链接：[http://poj.org/problem?id=3268]

<br>
<br>
<br>
<br>
<br>

###题解
第一反应Floyd，观察`N`数据范围，复杂度 \\(V^3\\)，果断弃。

从X号农场会到各个农场比较容易，只要跑一次Dijkstra就好了。复杂度 \\(O(\left|E\right|log\left|V\right|\\))，最坏情况\\(O(\left|E\right|+|V|log|V|)\\)。

但是如何求各个农场到X的最短距离呢？

我们可以把每条边反转，跑一次Dijkstra就好啦～

所以跑两次Dijkstra就能AC啦。

<br>

###代码
```cpp
#include<iostream>
#include<queue>
#include<algorithm>
#include<cstring>
#include<functional>
#include<vector>
using namespace std;
const int maxn = 1000+5;
const int INF = 0x3f3f3f3f;
typedef pair<int, int> P; // first: shortest path, second: vertex num;

struct edge {
	int to, cost;
};

vector<edge> G1[maxn];
vector<edge> G2[maxn];

int n, m, x;
int go[maxn], back[maxn];

void dijkstra (int s, int *d, vector<edge> *G) {
	priority_queue<P, vector<P>, greater<P> > q;
	q.push(P(0, s));

	while (!q.empty()) {
		P p = q.top();
		q.pop();
		int v = p.second;

		if (d[v] < p.first) continue;
		for (int i = 0; i < G[v].size(); i++) {
			edge e = G[v][i];
			if (d[e.to] > d[v] + e.cost) {
				d[e.to] = d[v] + e.cost;
				q.push(P(d[e.to], e.to));
			}
		}
	}
}

int main(void) {
	while (cin >> n >> m >> x) {
		int u;
		for (int i = 1; i <= n; i++) {
			G1[i].clear();
			G2[i].clear();
		}

		for (int i = 1; i <= m; i++) {
			edge a;
			cin >> u >> a.to >> a.cost;
			G1[u].push_back(a);
		}

		fill(back, back+n+1, INF);
		back[x] = 0;
		dijkstra(x, back, G1);

		for (int i = 1; i <= n; i++) {
			edge a;
			for (int j = 0; j < G1[i].size(); j++) {
				a.to = i;
				a.cost = G1[i][j].cost;
				G2[G1[i][j].to].push_back(a);
			}
		}

		fill(go, go+n+1, INF);
		go[x] = 0;
		dijkstra(x, go, G2);

		int ans = -1;
		for (int i = 1; i <= n; i++) {
			go[i] += back[i];
			if (ans < go[i]) ans = go[i];
		}

		cout << ans << endl;
	}
	return 0;
}

```