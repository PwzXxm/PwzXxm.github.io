---
title: "LeetCode Weekly Contest 155 and others"
date: 2019-09-19
draft: false

tags: ["LeetCode"]
---

This is the first week of LeetCode Challenges. It includes weekly contest 155 and other problems.

## Weekly Contest 155
https://leetcode.com/contest/weekly-contest-155

### 1200. Minimum Absolute Difference
https://leetcode.com/contest/weekly-contest-155/problems/minimum-absolute-difference/

Brute force. Find the minimum absolute difference and then iterate the list again to output the pairs with minimum absolute difference.

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

Binary search + inclusion/exclusion principle. The number of integers that is divisible by `A` and `B` is equal to the number of integers divisible by `A` plus the number of integers divisible by `b` and minus the number of integers divisible by both `A` and `B`. The theory can be applied to the case when it is divisible by three numbers.

Also, the range of `n` is $[1, 2 \cdot 10^9]$, the time complexity of binary search is $\log_2(2 \cdot 10^9)$, which is totally feasible.

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

Union find. We can find that if it is swappable for the letters at index `(1,2)` and `(2,5)`, the letters at `1, 2, 5` can be in arbitrary order.

Having said that, we can use union find to group them together, then append the character with the smallest lexicographical order in each group. 

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

Topological sort twice.

Firstly, we give distinct group numbers to items that do not belong to any of the group, instead of using `-1`. 

Then we perform topological sort on the groups only.
We only care about the edges among groups and ignore edges within each group.

After that, we iterate over each group and perform topological sort within each group.

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

This question is a bit odd.
Test cases like `+-123` are not explicitly stated in the description of the problem.

The tricky part is to check the condition of overflow. Note that the last digits of `INT_MAX` is `7`, don't forget to check.

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