---
title: 使用SM4加密&解密
date: 2025-06-20
slug: sm4-crypto-file
categories:
  - golang
---

# 参考

- https://www.cnblogs.com/wangzhongyang/p/17502480.html
- https://segmentfault.com/a/1190000040206966，主要是该代码
- github.com/tjfoc/gmsm/sm4

# 代码实现

话不多说，上代码

```go

package crypto

import (
	"crypto/cipher"
	"fmt"
	"io"
	"os"

	"github.com/tjfoc/gmsm/sm4"
)

type SM4Crypto struct {
	Key        []byte
	IV         []byte
	BufferSize int64
}

var defaultIv = []byte("1234567890abcedf")

// NewDefaultSM4Crypto
//
//	@return *SM4Crypto
func NewDefaultSM4Crypto() *SM4Crypto {
	return &SM4Crypto{
		IV:         defaultIv,
		BufferSize: 256,
	}
}

// EncryptFile
//
//	@param inputFile
//	@param outFile
//	@param key
//	@return error
func (sm4Crypto *SM4Crypto) EncryptFile(inputFile, outFile string, key []byte) error {

	inFile, err := os.Open(inputFile)
	if err != nil {
		return fmt.Errorf("open file error: %v", err)
	}
	buf := make([]byte, sm4Crypto.BufferSize)
	//初始化一个底层加密算法
	block, err := sm4.NewCipher(key)
	if err != nil {
		return fmt.Errorf("sm4 NewCipher error: %v", err)
	}
	//选择加密模式
	blockMode := cipher.NewCBCEncrypter(block, sm4Crypto.IV)
	out, err := os.Create(outFile)
	if err != nil {
		return fmt.Errorf("create file error: %v", err)
	}
	for {
		n, err := inFile.Read(buf)
		if err == io.EOF {
			break
		}
		if err != nil && err != io.EOF {
			return fmt.Errorf("read file error: %v", err)
		}

		//判断时最后一段数据则进行数据填充
		if int64(n) != sm4Crypto.BufferSize {
			groupData := paddingLastGroup(buf[:n], block.BlockSize())
			n = len(groupData)
			buf = make([]byte, n)
			buf = groupData
		}
		cipherText := make([]byte, n)
		blockMode.CryptBlocks(cipherText, buf[:n])
		_, err = out.Write(cipherText)
		if err != nil {
			return fmt.Errorf("write file error: %v", err)
		}
	}
	return nil
}

// DecryptFile
//
//	@param inputFile
//	@param outputFile
//	@param key
//	@return error
func (sm4Crypto *SM4Crypto) DecryptFile(inputFile, outputFile string, key []byte) error {

	//1.创建一个aes底层密码接口
	block, err := sm4.NewCipher(key)
	if err != nil {
		return err
	}
	//2.选择解密模式
	blockMode := cipher.NewCBCDecrypter(block, sm4Crypto.IV)
	//3.解密
	fr, err := os.Open(inputFile)
	if err != nil {
		return err
	}
	defer fr.Close()
	fileInfo, err := fr.Stat()
	if err != nil {
		return err
	}
	blockNum := fileInfo.Size() / sm4Crypto.BufferSize
	var num int64
	fw, err := os.Create(outputFile)
	if err != nil {
		return err
	}
	defer fw.Close()
	buf := make([]byte, sm4Crypto.BufferSize)
	for {
		num += 1
		n, err := fr.Read(buf)
		if err == io.EOF {
			break
		}
		if err != nil && err != io.EOF {
			return err
		}

		plainText := make([]byte, n)
		blockMode.CryptBlocks(plainText, buf[:n])
		//判断时最后一段数据则进行数据去填充
		if num == blockNum+1 {
			plainText = unpaddingLastGroup(plainText)
			n = len(plainText)
		}
		_, err = fw.Write(plainText[:n])
		if err != nil {
			return err
		}
	}
	return nil
}



func paddingLastGroup(plainText []byte, blockSize int) []byte {
	padNum := blockSize - len(plainText)%blockSize
	char := []byte{byte(padNum)}
	newPlain := bytes.Repeat(char, padNum)
	newText := append(plainText, newPlain...)
	return newText
}

func unpaddingLastGroup(plainText []byte) []byte {
	length := len(plainText)
	lastChar := plainText[length-1]
	number := int(lastChar)
	return plainText[:length-number]
}


```