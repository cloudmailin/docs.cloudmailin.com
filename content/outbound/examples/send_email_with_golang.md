---
title: Send Email with Go
description: In this guide we'll cover sending email in Go Lang over SMTP with CloudMailin's SMTP settings.
---

# Sending Email with Go

> To obtain your SMTP credentials you can create a free [outbound account] with CloudMailin.

## Sending with SMTP

Sending email in Go is simple with the inbuilt `net/smtp` package. Go will automatically attempt to
negotiate a TLS connection using STARTTLS when using `SendMail`.

All we need to do is create `smtp.PlainAuth` to perform authentication. Like CloudMailin Go will
only perform plain auth once the TLS connection is established ([docs]).

```go
package main

import (
  "log"
  "net/smtp"
)

func main() {
  // hostname is used by PlainAuth to validate the TLS certificate.
  hostname := "host from account"
  auth := smtp.PlainAuth("", "username from account", "password fromo account", hostname)

  msg := `To: to@example.net
From: from@example.com
Subject: Testing from GoLang

This is the message content!
Thanks
`
  err := smtp.SendMail(hostname+":587", auth, "from@example.com", []string{"to@example.net"},
    []byte(msg))
  if err != nil {
    log.Fatal(err)
  }
}
```

### Creating a Mime Message

In the example above we manually constructed the email content. An email message is structured
by a number of headers followed by an empty line and then the content. Multipart mime messages
can be used to include multiple parts such plain and html versions of the content.

It's possible to construct messages in Go in a number of ways. Either manually, using templates or
by using additional third-party libaries. If you need help with emails in go feel free to
[contact us].

<%= render 'outbound_summary' %>

[docs]: https://golang.org/pkg/net/smtp/#PlainAuth
