---
title: "力扣周赛 155 + 其他题目"
date: 2019-09-19
draft: false

tags: [LeetCode]
---

这是力扣第一周挑战，包括周赛 155 和其他一些题目。

## Weekly Contest 155
https://leetcode.com/contest/weekly-contest-155

### 1200. Minimum Absolute Difference
https://leetcode.com/contest/weekly-contest-155/problems/minimum-absolute-difference/

暴力。先遍历找到最小绝对差，接着再遍历一遍输出差值是该值的整数对。

``` cpp
class Solution {
public:
    vector<vector<int>> minimumAbsDifference(vector<int>& arr) {
        vector<vector<int>> ans;
        if (arr.size() == 1) return ans;
        sort(arr.begin(), arr.end());
        
        int mini = 0x3f3f3f3f;
        for (int i = 1; i < arr.size(); ++i) {
            mini = min(mini, abs(arr[i] - arr[i-1]));
        }
        
        for (int i = 1; i < arr.size(); ++i) {
            if (abs(arr[i]- arr[i-1]) == mini) {
                if (arr[i] < arr[i-1]) {
                    ans.push_back({arr[i], arr[i-1]});
                } else {
                    ans.push_back({arr[i-1], arr[i]});
                }
            }
        }
        return ans;
    }
};
```


### 1201. Ugly Number III
https://leetcode.com/contest/weekly-contest-155/problems/ugly-number-iii/

二分 + 容斥。能被`A`或`B`整除的数的个数等于能被`A`整除的数的个数加上能被`B`整除的数的个数，减去能被`A`，`B`同时整除的数的个数。相同的理论也可以用于三个数。

这题`n`的范围是 $[1, 2 \cdot 10^9]$，二分的时间复杂度为 $\log_2(2 \cdot 10^9)$，所以是可行的。

``` cpp
typedef long long LL;
class Solution {
    LL gcd(LL x, LL y) {
        return (y == 0 ? x : gcd(y, x % y));
    }
    
    LL lcm(LL x, LL y) {
        return x / gcd(x, y) * y;
    }
public:
    LL nthUglyNumber(LL n, LL a, LL b, LL c) {
        LL l = 1, r = 2e9, mid, cnt;
        LL lcm_ab = lcm(a, b);
        LL lcm_ac = lcm(a, c);
        LL lcm_bc = lcm(b, c);
        LL lcm_abc = lcm(lcm_ab, c);
        while (l < r) {
            mid = (l+r)/2;
            cnt = mid/a + mid/b + mid/c - mid/lcm_ab - mid/lcm_ac - mid/lcm_bc + mid/lcm_abc;
            if (cnt < n) {
                l = mid+1;
            } else {
                r = mid;
            }
        }
        
        return l;
    }
};
```


### 1202. Smallest String With Swaps
https://leetcode.com/contest/weekly-contest-155/problems/smallest-string-with-swaps/

并查集。我们可以看出如果在`(1,2)`，`(2,5)`上的元素分别可以被交换，那它们三个元素可以被任意交换，组成任意排列。

所以我们可以先把能互相交换的元素用并查集捆绑起来，最后构造答案时优先选用各个组里字典序最小的。

``` cpp
class Solution {
    const static int MAXN = 1e5+5;
    int par[MAXN];
    int rk[MAXN];
    int find(int x) {
        return (par[x] == x ? x : par[x] = find(par[x]));
    }
    
    void unite(int x, int y) {
        x = find(x); y = find(y);
        if (x == y) return ;
        if (rk[x] < rk[y]) {
            par[x] = y;
        } else {
            par[y] = x;
            if (rk[x] == rk[y]) rk[x]++;
        }
    }
    
public:
    string smallestStringWithSwaps(string s, vector<vector<int>>& pairs) {
        int n = s.size();
        for (int i = 0; i < n; ++i) {
            par[i] = i;
            rk[i] = 0;
        }
        
        for (int i = 0; i < pairs.size(); ++i) {
            unite(pairs[i][0], pairs[i][1]);
        }
        
        string ans;
        
        unordered_map<int, string> m;
        for (int i = 0; i < n; ++i) {
            m[find(i)].push_back(s[i]);
        }
        
        for (auto &x : m) {
            sort(x.second.begin(), x.second.end());
        }
        
        for (int i = 0; i < n; ++i) {
            ans += m[find(i)][0];
            m[find(i)].erase(0, 1);
        }
        
        return ans;
    }
};
```

## 1203. Sort Items by Groups Respecting Dependencies
https://leetcode.com/contest/weekly-contest-155/problems/sort-items-by-groups-respecting-dependencies/

拓扑排序两次。

首先，我们给那些单独成一组的元素进行编号（原先为`-1`）。

然后我们对于各个组进行拓扑排序。我们只关心组之间的边，忽略组内的边。

最后再循环各个组，对每个组进行一次拓扑排序，输出结果。

``` cpp
class Solution {
public:
    vector<int> sortItems(int n, int m, vector<int>& group, vector<vector<int>>& beforeItems) {
        // independent element belongs to its own group
        for (int i = 0; i < group.size(); ++i) {
            if (group[i] < 0) group[i] = m++;
        }
        
        vector<vector<int> > group_edge(m), within_group_edge(n);
        vector<int> group_deg(m), within_group_deg(n);
        
        for (int i = 0; i < n; ++i) {
            for (const auto& y : beforeItems[i]) {
                if (group[i] == group[y]) {
                    within_group_edge[y].push_back(i);
                    within_group_deg[i]++;
                } else {
                    group_edge[group[y]].push_back(group[i]);
                    group_deg[group[i]]++;
                }
            }
        }
        
        // topo sort groups
        vector<int> topo;
        queue<int> q;
        for (int i = 0; i < m; ++i) {
            if (group_deg[i] == 0) q.push(i);
        }
        
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (const auto& v : group_edge[u]) {
                group_deg[v]--;
                if (group_deg[v] == 0) {
                    q.push(v);
                }
            }
            topo.push_back(u);
        }
        
        if (topo.size() != m) return {};
        
        // topo sort within each group
        vector<int> ans;
        vector<vector<int> > group_member(m);
        
        for (int i = 0; i < n; ++i) {
            group_member[group[i]].push_back(i);
        }
        
        for (const auto& g : topo) {
            queue<int> q2;
            vector<int> topo2;
            
            for (const auto& x : group_member[g]) {
                if (within_group_deg[x] == 0) q2.push(x);
            }
            
            while (!q2.empty()) {
                int u = q2.front(); q2.pop();
                for (const auto& v : within_group_edge[u]) {
                    within_group_deg[v]--;
                    if (within_group_deg[v] == 0) {
                        q2.push(v);
                    }
                }
                topo2.push_back(u);
            }
            
            if (topo2.size() != group_member[g].size()) return {};
            for (const auto& x : topo2) {
                ans.push_back(x);
            }
        }
        return ans;
    }
};
```

## LeetCode 8 - String to Integer (atoi)
https://leetcode.com/problems/string-to-integer-atoi/


这题有点奇怪。像`+-123`这样的数据没有在题目解释中说明。

需要注意的是检查溢出的条件。注意`int`的最后一位是`7`。

### Solution
``` cpp
class Solution {
public:
    int myAtoi(string str) {
        int sign = 1;
        int ans = 0;
        int i = 0;
        
        while (isspace(str[i])) ++i;
        if (str[i] == '+' || str[i] == '-') {
            sign = (str[i++] == '+' ? 1 : -1);
        }
        for (; i < str.size(); ++i) {
            if (str[i] >= '0' && str[i] <= '9') {
                if (ans > INT_MAX/10 || (ans == INT_MAX/10 && str[i] > '7')) {
                    return (sign==1 ? INT_MAX : INT_MIN);
                }
                
                ans *= 10;
                ans += (str[i]-'0');
            } else {
                break;
            }
        }
        return sign*ans;
    }
};
```