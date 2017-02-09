---
layout: "post"
title: "POJ 3268 Silver Cow Party"
date: "2016-05-14"
tags:
- POJ
- Graph
---

There are one cow from each N (\\(1 \le N \le 1000\\)) farms want to go to the number X farm to have a party, hurrah! One cow from each farm need to go to the party and go back. There are M (\\(1 \le M \le 100,000\\)) weighted (represents time) one-direction roads connects pairs of roads. Cows are smart though, they want to go via the shortest path. The question is, what is the longest time the cow will take.

Link: [http://poj.org/problem?id=3268]

<br>
<br>
<br>
<br>
<br>

###Solution
First thought is Floyd algorithm, but look at the data for vertex `N` is no larger than 1000. We know the complexity of Floyd is \\(V^3\\) which is 1e9 in this case. This will definitely not work.

It is easy to find out that if you consider each cow goes back to their farm after the party. It becomes that from one source what’s the shortest path to each vertex. Sounds familiar? We can use Dijkstra for this part since the complexity is \\(O(\left|E\right|log\left|V\right|\\)), worst case \\(O(\left|E\right|+|V|log|V|)\\).

But how can we find the shortest path when each cow goes for the party?

We can reverse each edge and do Dijkstra from the source X again and it will be our answer for this part.

<br>

###Code
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
