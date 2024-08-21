---
title: 一些普通算法
date: 2024-08-21
slug: 2024-08-21-08-34-40
categories:
  - algo
---


# 16进制转2进制

```go
func main() {

	fmt.Println(transferBit2Str("11101"))
	fmt.Println(transferNum2Bit(29, 16, "0123456789ABCDEF"))
	fmt.Println(transfer2To16("11101"))
}

func transfer2To16(str string) string {
	if len(str) < 1 {
		return ""
	}

	var (
		mapping string = "0123456789ABCDEF"
		size16  int    = 16
		rest    int    = len(str) % 4
		segmant int    = len(str) / 4
	)

	result := []string{}
	if rest > 0 {
		result = append(result, transferNum2Bit(transferBit2Str(str[0:rest]), size16, mapping))
	}

	if segmant > 0 {
		for i := 0; i < segmant; i++ {
			from := i*4 + rest
			result = append(result, transferNum2Bit(transferBit2Str(str[from:from+4]), size16, mapping))

		}
	}

	return strings.Join(result, "")

}

func transferNum2Bit(num int, size int, chars string) string {

	if len(chars) < size {
		panic("chars mapping length error")
	}

	result := []byte{}
	for num > 0 {
		res := num % size
		result = append(result, chars[res])
		num = num / size
	}
	for i := 0; i < len(result)/2; i++ {
		result[i], result[len(result)-1-i] = result[len(result)-1-i], result[i]
	}
	return string(result)
}

func transferBit2Str(str string) int {
	offset := len(str) - 1
	result := 0
	for _, b := range str {
		if b == '1' {
			result += int(math.Pow(2, float64(offset)))
		}
		offset--
	}
	return result
}
```

# Bitmap

```go
func main() {

	fmt.Println(0 >> 5)
	object := NewFigure(128)
	object.Set(100)
	object.Set(99)
	object.Set(10)
	fmt.Println(object.Exists(100))
	fmt.Println(object.Exists(99))
	object.Delete(100)
	fmt.Println(object.Exists(100))
	fmt.Println(object.Exists(99))

}

type Figure struct {
	Storage []uint
	MaxSize int
}

func NewFigure(maxSize int) *Figure {
	index, offset := cal(maxSize)
	if offset > 0 {
		index += 1
	}
	return &Figure{
		Storage: make([]uint, index),
		MaxSize: index*8 - 1,
	}
}

func cal(num int) (int, int) {
	return num / 8, num % 8
}

func (f *Figure) Set(num int) bool {
	index, offset := cal(num)
	f.Storage[index] |= 1 << offset
	return true
}

func (f *Figure) Echo() {
	for _, item := range f.Storage {
		fmt.Println(strconv.FormatInt(int64(item), 2))
	}
}

func (f *Figure) Exists(num int) bool {
	index, offset := cal(num)
	return f.Storage[index]>>offset > 0
}

func (f *Figure) Delete(num int) bool {
	index, offset := cal(num)
	f.Storage[index] &= ^(1 << offset)
	return true
}
```

# 字符串相乘

```go
func multiply(str1 string, str2 string) string {
	if len(str1) < 1 || len(str2) < 1 {
		return "0"
	}

	str1Bytes := []byte(str1)
	str2Bytes := []byte(str2)
	mulResult := make([]int, len(str1Bytes)+len(str2Bytes))
	for i := len(str1Bytes) - 1; i >= 0; i-- {
		for j := len(str2Bytes) - 1; j >= 0; j-- {
			mul := int(str1Bytes[i]-'0') * int(str2Bytes[j]-'0')
			p1 := i + j
			p2 := i + j + 1
			sum := int(mul) + mulResult[p2]
			mulResult[p1] = sum / 10
			mulResult[p2] = sum % 10
		}
	}

	var (
		index int
	)
	for i, a := range mulResult {
		if a != 0 {
			index = i
			break
		}
	}
	result := []byte{}
	for i := index; i <= len(mulResult)-1; i++ {
		result = append(result, byte('0'+mulResult[i]))
	}
	fmt.Println(string(result))
	return string(result)
}
```

# 括号对生成

```go

func generateParenthesis(count int) []string {
	list := &[]string{}
	backtrace1(count, count, []byte{}, list)
	for _, v := range *list {
		fmt.Println(v)
	}
	return *list
}

func backtrace1(left, right int, current []byte, list *[]string) {
	if left > right {
		return
	}
	if left < 0 || right < 0 {
		return
	}

	if left == 0 && right == 0 {
		*list = append(*list, string(current))
		return
	}

	current = append(current, '(')
	backtrace1(left-1, right, current, list)
	current = current[0 : len(current)-1]

	current = append(current, ')')
	backtrace1(left, right-1, current, list)
	current = current[0 : len(current)-1]
}
```