---
layout: "post"
title: "力扣挑战第二周 - 周赛 156 + 其他题目"
date: "2019-10-02"
lang: cn
tags:
    [LeetCode]
---

力扣挑战第二周。因为有事，所以参加了模拟比赛。

<br>
<div class="toc">
**Contents**

- [Weekly Contest 156](#weekly-contest-156)
    - [1207. Unique Number of Occurrences](#1207-unique-number-of-occurrences)
    - [1208. Get Equal Substrings Within Budget](#1208-get-equal-substrings-within-budget)
    - [1209. Remove All Adjacent Duplicates in String II](#1209-remove-all-adjacent-duplicates-in-string-ii)
    - [1210. Minimum Moves to Reach Target with Rotations](#1210-minimum-moves-to-reach-target-with-rotations)
</div>
<br>

## Weekly Contest 156

### [1207. Unique Number of Occurrences](https://leetcode.com/contest/weekly-contest-156/problems/unique-number-of-occurrences/)

暴力。记下每个数出现的次数，遍历次数看有没有相同的。

```cpp
class Solution {
public:
    bool uniqueOccurrences(vector<int>& arr) {
        unordered_map<int, int> occ;
        unordered_map<int, bool> flag;
        
        for (int i = 0; i < arr.size(); ++i) {
            occ[arr[i]]++;
        }
        
        for (const auto x : occ) {
            if (flag.find(x.second) != flag.end()) {
                if (flag[x.second]) return false;
            } else {
                flag[x.second] = true;
            }
        }
        
        return true;
    }
};
```

### [1208. Get Equal Substrings Within Budget](https://leetcode.com/contest/weekly-contest-156/problems/get-equal-substrings-within-budget/)

两个指针分别记录当前子字符串的起点和终点。可以这样想：在一开始，我们看更换下一个字符的操作花费是否大于`maxCost`，如果小于或等于，终点指针就向后移一位。重复这个操作直到操作失败。
然后如果我们想再加入下一个字符，因为我们的`total_cost`已经“满了”，就必须从开头省出一个操作的花费：减去更换开头字符的操作并往右移动一位起点指针。

```cpp
class Solution {
public:
    int equalSubstring(string s, string t, int maxCost) {
        int maxi = -1;
        int total_cost = 0;
        int l = 0, r = 0;
        while (r < t.size()) {
            int c = abs(s[r]-t[r]);
            while ((total_cost + c) <= maxCost) {
                total_cost += c;
                r++;
                
                if (r >= s.size()) break;
                c = abs(s[r]-t[r]);
            }
            
            maxi = max(maxi, r-l);
            
            total_cost -= abs(s[l] - t[l]);
            l++;
        }
        
        return maxi;
    }
};
```

### [1209. Remove All Adjacent Duplicates in String II](https://leetcode.com/contest/weekly-contest-156/problems/remove-all-adjacent-duplicates-in-string-ii/)

栈。每次我们碰到一个新的字符，就往栈顶加入这个字符和一个初始为`1`的计数器。如果下一个字符和栈顶的字符相同，就增加计数器的计数。当计数和`k`相同时，把该字符从栈中扔掉。

```cpp
class Solution {
public:
    string removeDuplicates(string s, int k) {
        int s_size = s.size();
        if (s_size <= 1) return s;
        
        string ans;
        stack<pair<char, int> > stk;
        stk.push({s[0], 1});
        
        for (int i = 1; i < s_size; i++) {
            if (!stk.empty() && stk.top().first == s[i]) {
                stk.top().second++;
                
                if (stk.top().second == k) {
                    stk.pop();
                }
            } else {
                stk.push({s[i], 1});
            }
        }
        
        while (!stk.empty()) {
            pair<char, int> p = stk.top(); stk.pop();
            ans += string(p.second, p.first);
        }
        
        reverse(ans.begin(), ans.end());
        
        return ans;
    }
};
```

### [1210. Minimum Moves to Reach Target with Rotations](https://leetcode.com/contest/weekly-contest-156/problems/minimum-moves-to-reach-target-with-rotations/)

广度遍历搜索。这题不难只要把实现写对了就行。

```cpp
class Solution {
    typedef pair<int, int> block_t;
    typedef pair<block_t, block_t> block2_t;
    typedef pair<block2_t, int> state_t; // step

    public:
    int minimumMoves(vector<vector<int>>& grid) {
        int N = grid.size();
        queue<state_t> q;
        q.push({{{0, 0}, {0, 1}}, 0});

        set<block2_t> visited;
        visited.insert({{0, 0}, {0, 1}});
        pair<set<block2_t>::iterator, bool> rst;

        while (!q.empty()) {
            state_t s = q.front(); q.pop();
            block_t a = s.first.first;
            block_t b = s.first.second;
            int step = s.second;


            if (a.first == b.first) {
                // horizontal
                if (a.first == N-1 && a.second == N-2 && b.first == N-1 && b.second == N-1) {
                    return step;
                }

                if (b.second+1 < N && grid[b.first][b.second+1] == 0){
                    // right
                    rst = visited.insert({{b.first, b.second}, {b.first, b.second+1}});
                    if (rst.second) {
                        q.push({{{b.first, b.second}, {b.first, b.second+1}}, step+1});
                    }
                }

                if (a.first+1 < N && grid[a.first+1][a.second] == 0 && grid[b.first+1][b.second] == 0) {
                    // down
                    rst = visited.insert({{a.first+1, a.second}, {b.first+1, b.second}});
                    if (rst.second) {
                        q.push({{{a.first+1, a.second}, {b.first+1, b.second}}, step+1});
                    }

                    // clockwise
                    rst = visited.insert({{a.first, a.second}, {a.first+1, a.second}});
                    if (rst.second) {
                        q.push({{{a.first, a.second}, {a.first+1, a.second}}, step+1});
                    }
                }
            } else {
                // vertical
                if (b.first+1 < N && grid[b.first+1][b.second] == 0){
                    // down
                    rst = visited.insert({{b.first, b.second}, {b.first+1, b.second}});
                    if (rst.second) {
                        q.push({{{b.first, b.second}, {b.first+1, b.second}}, step+1});
                    }
                }

                if (a.second+1 < N && grid[a.first][a.second+1] == 0 && grid[b.first][b.second+1] == 0) {
                    // right
                    rst = visited.insert({{a.first, a.second+1}, {b.first, b.second+1}});
                    if (rst.second) {
                        q.push({{{a.first, a.second+1}, {b.first, b.second+1}}, step+1});
                    }

                    // anti-clockwise
                    rst = visited.insert({{a.first, a.second}, {a.first, a.second+1}});
                    if (rst.second) {
                        q.push({{{a.first, a.second}, {a.first, a.second+1}}, step+1});
                    }
                }
            }
        }

        return -1;
    }
};
```