---
layout: "post"
title: "Static Linked List - Another Way To Represent Graphs"
date: "2018-05-29"
lang: en
tags: [Graph, Data-Structure]
---

Static Linked List is a data structure that stores linked list in static arrays. It is usually used to represent graphs. It is very interesting that its Chinese name literally translated as "Linked Forward Star". You have two choices of paths to understand this.

- Start from [Forward Star](#forward-star).

- Start from [Adjacency List](#adjacency-list).

However, I would recommend to explore both ideas to have a better understanding. If you know some of it or you just don't care, you can jump to [here](#static-linked-list) straight away.

<br/>
<br/>

## Forward Star

Forward Star is also known as Adjacency Array and . We first store edges in an array and then sorted it. Then we have another two arrays stores the index of each vertex, and out-degree (how many edges are coming from the vertex) respectively.

### Example

![example](/img/post/static_linked_list_example.svg)

We have these edges (from, to) in the example graph:

```
(1, 2)
(2, 4)
(3, 4)
(1, 3)
(4, 3)
(3, 2)
(1, 4)
```

Let `u` be the vertex where the edge is coming from and `v` be the vertex the edge is going to:

We sort it first base on `u`, the order of `v` does not matter and we fill arrays

- `es[]`: the second vertex in each pair - `v`.

- `head[]`: the index of the first occurrence of `u` (first vertex in the pair)

- `len[]`: how many edges are going out from this vertex

```
(1, 2) --|
(1, 3) --| => len[1] = 3
(1, 4) --|
(2, 4)
(3, 2) => head[3] = 5
(3, 4)
(4, 3)
    ^
  es[]
```

| Array | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **es** | 2 | 3 | 4 | 4 | 2 | 4 | 3 |
| **head** | 1 | 4 | 5 | 7 |  |  |  |
| **len** | 3 | 1 | 2 | 1 |  |  |  |

Therefore, we can easily get all edges coming from vertex `1` by first identifying that its index in `es[]` is `1` using `head[1] == 1`, and then iterate `es[]` from `head[1]` to `head[1]+len[1]` (exclusive). That is `es[1+0] == 2`, `es[1+1] == 3`, `es[1+2] == 4` which means the edges (1,2), (1,3), (1,4).

``` cpp
// to find all edges from vertex u
for (int i = 0; i < len[u]; i++) {
    cout << u << " " << es[head[u]+i] << endl;
}
```

Forward Star is not frequently used because of its sorting operation which takes $ O(E \times log(E)) $ in time complexity. Therefore we have Linked Forward Star to avoid sorting.

<br/>

---

<br/>

## Adjacency List

Adjacency List is usually implemented by `vector<int> G[MAXN_V]`. `G[u]` points to a vector that stores all edges from `u`.

### Example

![example](/img/post/static_linked_list_example.svg)

The result is like the figure shown below, the array at the left represents each `G[]` respectively. Every time we read a edge from `u`, we push it back to the vector `G[u]` points to.

![list](/img/post/static_linked_list_list.svg)

``` cpp
for (int i = 0; i < G[u].size(); i++) {
    cout << u << " " << G[u][i] << endl;
}
```

<br/>

---

<br/>

## Static Linked List

Static Linked List is an improved version of [Forward Star](#forward-star) and the static version of [Adjacency List](#adjacency-list). It avoids sorting the edge array. How? Keep linking to itself!

### Example

We use the same example as above.

![example](/img/post/static_linked_list_example.svg)

With edges (from, to):

```
(1, 2)
(2, 4)
(3, 4)
(1, 3)
(4, 3)
(3, 2)
(1, 4)
    ^
   es[]
```

We construct arrays, let `u` be the vertex where the edge is coming from and `v` be the vertex the edge is going to:

- `es[]`: stores `v`s, containing the second vertices from each pair. The information about `u` is stored in `head[]`.

- `head[]`: the index of first occurrence of the `u`, or in other words, the first element of the list.

- `next[]`: the index of the next edge that coming from the same `u`, use `0` to represent that it is the end of the list.

During constructing `next[]`, we need another array to keep track of the position of the last element in each list.

So we have

| Array | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **es** | 2 | 4 | 4 | 3 | 3 | 2 | 4 |
| **head** | 1 | 2 | 3 | 5 | | | |
| **next** | 4 | 0 | 6 | 7 | 0 | 0 | 0 |


Let's walking through finding all edges coming from vertex **1**.

1. use `head[1] == 1` and let `i = head[1]` to find the index of first edge, `es[i] == 2` yields the edge (1, 2), update `i = next[i]`, now `i == 4`.

2. `es[i] == 3` yields the edge (1, 3), update `i = next[i]`, now `i == 7`.

3. `es[i] == 4` yields the edge (1, 4), update `i = next[i]`, now `i == 0`.

4. since `i == 0`, terminate.

``` cpp
for (int i = head[u]; i; i = next[i]) {
    cout << u << " " << es[i] << endl;
}
```

It keeps linking back to itself and bounce between `es[]` and `next[]`, except the first time which uses `head[]`.

## Comparison

The time complexity of Forward Star is $O(E \times log(E))$, so if you solve problem use this it may become worse.

Adjacency List is easy to understand and implement using C++ STL vector. It allocates spaces dynamically, so it does not need to know the number of edges. However, please note that since it allocates twice of the memory as needed, it sometimes wastes some of the space.

Static Linked List does not change the order of the edges. It only build up relationships by using arrays. It is faster than STL. It is easy to implement once you master it.

However, these data structures are not good at finding particular edges from a given vertex, the worst case is to iterate to the end of the list.
