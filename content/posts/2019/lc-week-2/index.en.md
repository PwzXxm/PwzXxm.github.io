---
title: "LeetCode Weekly Contest 156 and others"
date: 2019-10-02
draft: false

tags: [LeetCode]
---

Second week of LeetCode Challenge. Participated the virtual contest.


## Weekly Contest 156

### 1207. Unique Number of Occurrences
https://leetcode.com/contest/weekly-contest-156/problems/unique-number-of-occurrences/

Brute force. Record total occurrence of each number and iterate over it to see if there is any duplication.

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

### 1208. Get Equal Substrings Within Budget
https://leetcode.com/contest/weekly-contest-156/problems/get-equal-substrings-within-budget/

Two pointers. Let's think it in this way: at the starting position, if we can go to the next character in the string and does not exceed the maximum cost, do so and keep doing it until we can't.
Then in order to extend the length of sub-string, we must "release" the cost of changing one character at the beginning of the sub-string, so that the next character has some costs available to use in order to hold the maximum bound.

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

### 1209. Remove All Adjacent Duplicates in String II
https://leetcode.com/contest/weekly-contest-156/problems/remove-all-adjacent-duplicates-in-string-ii/

Stack approach. Whenever encounter a new character, push the character with count `1` into the stack. Increment the counter if the next character is the same as the top of the stack.
If the counter reaches `k`, then just remove it from the stack as it's valid adjacent duplicates.

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

### 1210. Minimum Moves to Reach Target with Rotations
https://leetcode.com/contest/weekly-contest-156/problems/minimum-moves-to-reach-target-with-rotations/

BFS. This question is not hard while you got the implementation right. Check all possible moves.

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