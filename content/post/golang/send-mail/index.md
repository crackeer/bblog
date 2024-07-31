---
title: 使用golang发送邮件
slug: golang-send-email
date: 2024-07-31
categories:
  - Golang
tags:
  - mail
---

话不多说，上代码，使用了[github.com/xhit/go-simple-mail/v2](http://github.com/xhit/go-simple-mail)

1. 引入lib
- `import "github.com/xhit/go-simple-mail/v2"`
- `import "crypto/tls"`

2. 正式代码

```go

server := mail.NewSMTPClient()

// SMTP Server
server.Host = "mail.host.com"
server.Port = 25
server.Username = "yourname@mail.host.com"
server.Password = "your-password"
server.Encryption = mail.EncryptionSTARTTLS

server.KeepAlive = false

// Timeout for connect to SMTP Server
server.ConnectTimeout = 10 * time.Second

// Timeout for send the data and wait respond
server.SendTimeout = 10 * time.Second

// Set TLSConfig to provide custom TLS configuration. For example,
// to skip TLS verification (useful for testing):
server.TLSConfig = &tls.Config{InsecureSkipVerify: true}

// SMTP client
smtpClient, err := server.Connect()
if err != nil {
    return nil, err
}
// Email MSG Build
email := mail.NewMSG()
mailContent := `明天要下雨，记得带伞`
email.SetFrom("【Subject】someone<your-name@mail.host.name>").AddTo("abc@qq.com", "simple@qq.com").SetSubject("【通知】邮件主题").SetBody(mail.TextHTML, mailContent)
if email.Error != nil {
    return email.Error
}
sendError := email.Send(mailer.client
if sendError != nil {
    fmt.Println("send email error:", sendError)
}

```