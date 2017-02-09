---
layout: post
title: "Stack, Queue and Linked Lists"
date: 2015-12-25
tag: data-structure
lang: en
images:
  - url: /img/post/link_in.gif
---

Stack, queue and Linked lists are basic data structures. They appear in our daily life. For example, stacks of intermodal containers at the port, waiting in line(queue) to ride a roller coaster and the film The Human Centipede，if you know it.

<br>
<div class="toc">
**Contents**

- [Stack](#stack)
	- [Intro](#stack-intro)
	- [Array Implementation](#stack-array-implementation)
	- [Linked List Implementation](#stack-linked-list-implementation)
	- [C++ STL - stack](#stack-c++-stl-stack)
- [Queue](#queue)
	- [Intro](#q-intro)
	- [Linked List Implementation](#q-linked-list-implementation)
	- [C++ STL - queue](#q-c++-stl-queue)
	- [Priority Queue](#q-priority-queue)
- [Linked List](#linked-list)
	- [Intro](#ll-intro)
	- [C++ Struct Implementation](#ll-c++-struct-implementation)
</div>
<br>

-----

##<a name="stack"></a>Stack
###<a name="stack-intro"></a>Intro
Stack is like a stack of intermodal containers, or a stack of book. Every time you want to put a new item, you put above the original stack, not between or below. Every time you want to remove a item, you need to start from the top, remove the item which is latest added. Hence, there is a principle called "**LIFO**", Last In, First Out.

Common operations:

push | pop
:---:|:---:
![stack_push](/img/post/stack_push.gif) | ![stack_pop](/img/post/stack_pop.gif)

###<a name="stack-array-implementation"></a> Array Implementation
Usually we use the first item in the array `array[0]` as the bottom of the stack, create index `max-index` to store the index of the top item, in other words, the index of the last item in the stack.

Push: `max_index += 1`, and at the index of max_index add the item

Pop: delete the item at the index `max_index`, `max_index -= 1`

###<a name="stack-linked-list-implementation"></a> Linked List Implementation
Using singly linked list, use `head` to store the bottom of the stack, each item has `next` pointing at the next item. The top item's `next` points to `NULL`, `size` stores the size of the stack (the length of the linked list).

push: change the `next` variable of the top item in stack(last item in list) to the new item, let `next` of the new item points to `NULL`, `size += 1`

pop: delete the top item in stack (last item in list), `size -= 1`, set `next` of the new last item to `NULL`

###<a name="stack-c++-stl-stack"></a> C++ STL - stack
``` cpp
#include<iostream>
#include<stack>
using namespace std;

int main(void) {
	/* create a stack named stk and its elements are int type */
	stack <int> stk;

	/* push an element to the stack */
	stk.push(1);	// 1
	stk.push(2);	// 1 2

	/*
	 * cout << stk.push(3) << endl;
	 * error!! stk.push(3) returns void
	 */

	/* top() returns the top element in the stack and it does NOT change the stack */
	cout << stk.top() << endl; // print out 2

	stk.push(1);

	/* gives the size of the stack - how many elements are there */
	cout << stk.size() << endl; // print out 3

	/* pop the top element from the stack, return void as well */
	stk.pop();
	stk.pop();

	cout << stk.top() << endl; // print out 1

	/* check if the stack is empty, if it is empty, returns true(1) */
	cout << stk.empty() << endl;

	return 0;
}
```

<br>

-----

##<a name="queue"></a>Queue
###<a name="q-intro"></a> Intro
Queue is like the queue in our life, wait in line to check out. Each new item add to the end of a queue, and the item at the front goes out first. Hence, Queue has the principle of "**FIFO**" (First In, First Out).

Common operations:

enqueue | dequeue
:---:|:---:
![queue_enqueue](/img/post/queue_enqueue.gif) | ![queue_dequeue](/img/post/queue_dequeue.gif)

###<a name="q-linked-list-implementation"></a>Linked List Implementation
Using singly linked list, use `head` to track the head of a queue, each item has a variable `next` pointing to the next item, `next` of the last item in the queue points to `NULL`, `size` tracks the length of the queue.

Enqueue: append the new item at the end of the queue/list, `next` of the old last item points to the new item just appended, `size += 1`

Dequeue: Using `next` to navigate to the second item, `head` points to the second item, delete the first item, `size -= 1`

###<a name="q-c++-stl-queue"></a> C++ STL - queue
Almost the same as `stack`!

**Caution: `queue` uses `front` and `back` to get the first and last item respectively.**

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

###<a name="q-priority-queue"></a> Priority Queue
Priority Queue is similar as queue, however each item has a priority. The first item to be dequeued maybe not the most front of the queue, it is now which the item has the highest priority. It's like someone who have VIP cards, or someone is a queue-jumper, not fair for these items waiting, right? sigh.

In C++ STL, if you use `int` as items in a priority queue, it is default that the smaller the integer is, the less priority it has. If you want the opposite, which is larger integer, less priority, you could use `great<int>`, fully declaration`std::priority_queue<int, std::vector<int>, std::greater<int> q_name`. If you want other custom compare methods, you might need to custom `cmp` function to complete priority comparison.

**Caution: Priority Queue uses `front()` to get the first item, NOT `top()`**

<br>

-----

##<a name="linked-list"></a>Linked List
###<a name="ll-intro"></a> Intro
Linked list is like linked paper clips, have you tired before? Linked list have several structures: singly linked list, doubly linked list, multiply linked list and others. We only show singly linked list here as others can be implemented with the understanding of singly linked list.

Common operations:

- add nodes
- delete nodes
- next node

![link_in](/img/post/link_in.gif)

###<a name="ll-c++-struct-implementation"></a> C++ Struct Implementation
``` cpp
#include<iostream>

struct Node {
	int value;
	Node *next;
};

int main() {
	Node *root;
	Node *cur;

	/* Initialize the linked list */
	root = new Node;
	root->value = 1;
	root->next = NULL;
	cur = root;

	/* add Node at the end of the list */
	cur = cur->next;
	cur = new Node;
	cur->value = 2;
	cur->next = NULL; // linked list: 1 2

	/* add Node between two Nodes */
	Node *second = new Node;
	second->value = 3;
	second->next = cur;
	root->next = second; // linked list: 1 3 2

	/* known value, find Node */
	cur = root;
	while (cur->value != 3) {
		cur = cur->next;
	}
	std::cout << cur->value << std::endl;  // 3

	/* traverse to the last Node */
	while (cur->next != NULL) {
		cur = cur->next;
	}
	std::cout << cur->value << std::endl; // 2

	/* delete Node */
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
