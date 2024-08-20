---
title: 二叉树的操作
date: 2024-08-20
slug: 2024-08-20-07-51-47
categories:
  - algo
---


# 参考文档

- https://labuladong.gitee.io/algo/zhun-bei-g-8db77/



# 二叉树构建

```go

func buildTree(data []int) *Node {
	if len(data) < 1 {
		return nil
	}
	root := &Node{
		Value: data[0],
	}
	queue := []*Node{root}
	from := 1
	for {
		curNode := queue[0]
		if from > len(data)-1 {
			break
		}
		curNode.Left = &Node{
			Value: data[from],
		}
		queue = append(queue, curNode.Left)
		from++
		if from > len(data)-1 {
			break
		}
		curNode.Right = &Node{
			Value: data[from],
		}
		queue = append(queue, curNode.Right)
		from++
		queue = queue[1:]
	}
	return root
}
```

# 层序遍历

```go
func printTree(root *Node) {
	if root == nil {
		return
	}
	queue := []*Node{root}
	level := 1
	for {
		if len(queue) < 1 {
			break
		}
		fmt.Printf("level->%d: ", level)
		tmpQueue := []*Node{}
		for _, node := range queue {
			fmt.Printf("%d ", node.Value)
			if node.Left != nil {
				tmpQueue = append(tmpQueue, node.Left)
			}

			if node.Right != nil {
				tmpQueue = append(tmpQueue, node.Right)
			}
		}
		queue = tmpQueue
		level++
		fmt.Println("")
	}
}
```

# 前序遍历

```go
func preTraverse(root *Node) {
	if root == nil {
		return
	}
	queue := []*Node{root}
	for {
		if len(queue) < 1 {
			break
		}

		last := queue[len(queue)-1]
		fmt.Printf("%d ", last.Value)
		queue = queue[0 : len(queue)-1]
		if last.Right != nil {
			queue = append(queue, last.Right)
		}

		if last.Left != nil {
			queue = append(queue, last.Left)
		}
	}
}
```

# 中序遍历

```go
func middleTraverse2(root *Node) {
	if root == nil {
		return
	}

	queue := []*Node{}
	curNode := root

	for {
		if curNode == nil && len(queue) < 1 {
			break
		}
		for curNode != nil {
			queue = append(queue, curNode)
			curNode = curNode.Left
		}
		lastNode := queue[len(queue)-1]
		fmt.Printf("%d ", lastNode.Value)
		queue = queue[0 : len(queue)-1]
		curNode = lastNode.Right
	}
}
```
# 后序遍历

```go
func backTraverse(root *Node) {
	if root == nil {
		return
	}

	queue := []*Node{root}
	list := []*Node{}

	for {
		if len(queue) < 1 {
			break
		}
		first := queue[len(queue)-1]
		queue = queue[0 : len(queue)-1]
		if first.Left != nil {
			queue = append(queue, first.Left)
		}
		if first.Right != nil {
			queue = append(queue, first.Right)
		}
		list = append(list, first)
	}
	for i := range list {
		fmt.Printf("%d ", list[len(list)-i-1].Value)
	}
}
```
