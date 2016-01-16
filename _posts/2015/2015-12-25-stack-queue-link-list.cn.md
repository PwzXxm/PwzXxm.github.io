---
layout: post
title: "栈，队列和链表"
date: 2015-12-25
tag: data-structure
---

栈，队列和链表是最基础的数据结构，它们出现在很多生活场景中，比如说堆起来的集装箱，排队坐过山车，人体蜈蚣（如果不知道就别去搜了，啦啦啦）

<br>
<div class="toc">
**目录**

- [栈](#stack)
	- [简介](#stack-intro)
	- [数组实现](#stack-array-implementation)
	- [链表实现](#stack-linked-list-implementation)
	- [C++ STL - stack](#stack-c++-stl-stack)
- [队列](#queue)
	- [简介](#q-intro)
	- [链表实现](#q-linked-list-implementation)
	- [C++ STL - queue](#q-c++-stl-queue)
	- [优先队列](#q-priority-queue)
- [链表](#linked-list)
	- [简介](#ll-intro)
	- [C++ struct 实现](#ll-c++-struct-implementation)
</div>
<br>

-----

##<a name="stack"></a> 栈
###<a name="stack-intro"></a> 简介
栈就像堆起来的集装箱，或者是一堆书，每次加入新的元素只能在旧的之上，每次移出元素只能拿出最新加入的，所以有“**后进先出**”的原则(后进去的元素先出来)。

常见操作有:

进栈 | 出栈
:---:|:---:
![stack_push](/img/post/stack_push.gif) | ![stack_pop](/img/post/stack_pop.gif)

###<a name="stack-array-implementation"></a>  数组实现
一般我们用数组的第一个元素`array[0]`作为栈底，创建一个变量`max_index`来存储栈的最顶部元素在数组中的下标，也就是数组最后一个栈中元素的下标。

进栈：`max_index += 1`，然后在该下标插入进栈的元素

出栈：初始化在`max_index`下标的元素，`max_index -= 1`

###<a name="stack-linked-list-implementation"></a> 链表实现
单向链表，用`head`记录栈头，每个元素都有`next`指向下一个元素，栈顶的`next`指向`NULL`，`size`纪录链表大小（栈的大小）。

进栈：让在栈顶（链表尾部）元素的`next`指向新的元素，新元素的`next`为`null`，`size += 1`

出栈：初始化栈顶（链表尾部）元素，移动到上一个元素，设置`next`为`null`, `size -= 1`

###<a name="stack-c++-stl-stack"></a> C++ STL - stack
```cpp
#include<iostream>
#include<stack>
using namespace std;

int main(void) {
    /* 创建一个栈，名为stk，元素类型为int */
	stack <int> stk;

    /* 使一个元素进栈 */
	stk.push(1);	// 1
	stk.push(2);	// 1 2

	/*
	 * cout << stk.push(3) << endl;
	 * 错误！！ stk.push(3) 返回void类型
	 */

    /* top() 返回栈最顶部的元素，且不改变栈 */
	cout << stk.top() << endl; // print out 2

	stk.push(1);

    /* 返回栈的大小，有多少元素 */
	cout << stk.size() << endl; // print out 3

    /* 使栈顶部的元素出栈，返回void类型 */
	stk.pop();
	stk.pop();

	cout << stk.top() << endl; // print out 1

    /* 查看栈是否为空，如果为空，返回真(1) */
	cout << stk.empty() << endl;

	return 0;
}
```

<br>

-----

##<a name="queue"></a> 队列
###<a name="q-intro"></a> 简介
队列就像排队一样，在队尾加入新的元素，在队首出队。所以队列有着“**先进先出**”的原则。

常见操作有：

入队 | 出队
:---:|:---:
![queue_enqueue](/img/post/queue_enqueue.gif) | ![queue_dequeue](/img/post/queue_dequeue.gif)

###<a name="q-linked-list-implementation"></a> 链表实现
使用单向链表，用`head`记录队列头，每个元素都有`next`指向下一个元素，队尾元素的`next`指向`NULL`，`size`纪录队列的长度。

入队：在队尾（链表尾部）插入元素，即旧队尾的`next`指向新元素，新元素的`next`指向`null`，`size += 1`

出队：通过`next`移动到第二个元素，`head`指向第二个元素，初始化原队首（链表头部），`size -= 1`

###<a name="q-c++-stl-queue"></a> C++ STL - queue
基本用法和栈相同，

**需要特别注意的一点是队列分别使用`front`和`back`来返回队首和队尾元素。**

```cpp
#include<iostream>
#include<queue>
using namespace std;

int main() {
	queue<int> q;
	q.push(1); // q: 1
	q.push(2); // q: 1 2

	cout << q.front() << endl; // 1
	cout << q.back() << endl; // 2

	q.push(3); // q: 1 2 3
	cout << q.size() << endl; // 3
	q.pop(); // q: 2 3
	cout << q.front() << endl; // 2
	cout << q.back() << endl; // 3
	cout << q.empty() << endl; // 0

	return 0;
}
```

###<a name="q-priority-queue"></a> 优先队列
优先队列类似于队列，只不过每个元素都有一个优先级，出队的元素不一定是最先入队的元素，而是当前队列中优先级最高的元素。就像有人有VIP卡的可以走专属通道，有人可以插队一样，对每个元素来说并不公平，叹气。

在C++ STL中，如果把`int`作为优先队列的类型， 默认情况下如果是整数的优先队列，那整数越小，则优先级越低。如果想整数越大，优先级越低，可以用`greater<int>`, 完整声明`std::priority_queue<int, std::vector<int>, std::greater<int> q_name`。如有其它需求，可自定义`cmp`函数来完成优先级的比较。

**另外需特别注意的是，优先队列取队首元素不再是用队列的`front()`，而是用`top()`。**

<br>

-----

##<a name="linked-list"></a> 链表
###<a name="ll-intro"></a> 简介
链表像一个个回形针串起来的链子。链表有多种结构：单向链表，双向链表，循环链表等等。主要介绍单向链表，其他类型脑补脑补ok的。

常见操作有：

- 添加节点
- 销毁节点
- 下一节点

![link_in](/img/post/link_in.gif)

###<a name="ll-c++-struct-implementation"></a> C++ struct 实现

``` cpp
#include<iostream>

struct Node {
	int value;
	Node *next;
};

int main() {
	Node *root;
	Node *cur;

	/* 初始化链表 */
	root = new Node;
	root->value = 1;
	root->next = NULL;
	cur = root;

	/* 在链表尾部加入节点 */
	cur = cur->next;
	cur = new Node;
	cur->value = 2;
	cur->next = NULL; // linked list: 1 2

	/* 在节点中间 */
	Node *second = new Node;
	second->value = 3;
	second->next = cur;
	root->next = second; // linked list: 1 3 2

	/* 知道数据，寻找节点 */
	cur = root;
	while (cur->value != 3) {
		cur = cur->next;
	}
	std::cout << cur->value << std::endl;  // 3

	/* 遍历到链表尾部 */
	while (cur->next != NULL) {
		cur = cur->next;
	}
	std::cout << cur->value << std::endl; // 2

	/* 删除节点 */
	Node *last;
	cur = root;
	if (cur == NULL)
		; // empty list
	if (cur->value == 1) { // if we want to delete the first node
		root = cur->next;
		delete cur;
	} else {
		while (cur->value != 1 && cur->next != NULL) {
			last = cur;
			cur = cur->next;
		}

		if (cur->value == 1) {
			last->next = cur->next;
			delete cur;
		}
	}
}
```
