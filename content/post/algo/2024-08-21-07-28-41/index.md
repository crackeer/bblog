---
title: 链表那些事儿
date: 2024-08-21
slug: 2024-08-21-07-28-41
categories:
  - algo
---

# 链表


# 翻转链表

- 递归版本

```go
func ReverseLinkList1(head *Node) *Node {
	if head == nil || head.Next == nil {
		return head
	}
	newHead := ReverseLinkList1(head.Next)
	head.Next.Next = head
	head.Next = nil

	return newHead
}
```

- 非递归版本

```go
func ReverseLinkList2(head *Node) *Node {
	if head == nil || head.Next == nil {
		return head
	}

	var (
		preNode  *Node
		curNode  *Node = head
		nextNode *Node
	)

	for curNode != nil {
		nextNode = curNode.Next
		curNode.Next = preNode
		preNode = curNode
		curNode = nextNode

	}
	return preNode
}
```


# K个一组翻转链表

```go
func ReverseLinkListK(head *Node, k int64) *Node {
	if head == nil || head.Next == nil {
		return head
	}
	if k == 1 {
		return head
	}
	newHead := ReverseLinkListK(head.Next, k-1)
	head.Next.Next = head
	head.Next = nil

	return newHead
}

func ReverseLinkByStep(head *Node, step int64) *Node {
	if step <= 1 {
		return head
	}

	var (
		curNode *Node = head
		newHead *Node = head
	)
	for i := 0; i < int(step); i++ {
		if curNode != nil {
			curNode = curNode.Next
		} else {
			return head
		}
	}
	newHead = ReverseLinkListK(head, step)
	head.Next = ReverseLinkByStep(curNode, step)
	return newHead
}

```
