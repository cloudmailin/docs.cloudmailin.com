---
title: Send Email with Go (GoLang)
description: In this guide we'll cover sending email in Go Lang over SMTP with CloudMailin's SMTP settings.
image: go
---

# Sending Email with Go (Golang) via SMTP or API

Sending email with Go can be done via HTTP API or SMTP.

* [Sending Email with Go via API]
* [Sending Email with Go via SMTP]

Although Go is perfect for network communication the SMTP protocol is quite
verbose. HTTP makes a more convenient / efficient protocol for sending email
within Web applications. CloudMailin provides sending email via HTTP API or SMTP
to allow the developer to choose.

> To obtain your SMTP credentials you can create a free [outbound account] with
> CloudMailin.

## Sending email with Go via HTTP API

CloudMailin provides the [cloudmailin-go] package to make sending and receiving
email in Go (Golang) straight forward.

To install the package simply `go get` it:

```console
go get -u github.com/cloudmailin/cloudmailin-go
```

You can then send a message with the following:

```go
package main

import (
  "fmt"

  "github.com/cloudmailin/cloudmailin-go"
)

func main() {
  // Create the default CloudMailin Client. This example will panic if there
  // are any failures at all.
  client, err := cloudmailin.NewClient()
  if err != nil {
    panic(err)
  }

  // SMTP Settings will be taken from CLOUDMAILIN_SMTP_URL env variable by
  // default but they can be overridden.
  // client.SMTPAccountID = ""
  // client.SMTPToken = ""

  attachment, err := cloudmailin.AttachmentFromFile("./logo.png")
  if err != nil {
    panic(err)
  }

  // Generate an example email
  email := cloudmailin.OutboundMail{
    From:        "sender@cloudmta.dev",
    To:          []string{"debug@smtp"},
    CC:          []string{"carbon@smtp"},
    Headers:     map[string][]string{"x-agent": {"cloudmailin-go"}},
    Subject:     "Hello From Go 😀",
    Plain:       "Hello World",
    HTML:        "<h1>Hello!</h1>\nWorld",
    Priority:    "",
    Tags:        []string{"go"},
    Attachments: []cloudmailin.OutboundMailAttachment{attachment},
    TestMode:    true,
  }

  // This will re-write the email struct based on the
  // JSON returned from the call if successful.
  _, err = client.SendMail(&email)
  if err != nil {
    panic(err)
  }

  // The email.ID should now be populated
  fmt.Printf("ID: %s, Tags: %s", email.ID, email.Tags)
}
```

By default the package assumes that you have your SMTP credentials stored in an
environment variable called `CLOUDMAILIN_SMTP_URL` in the form:
`smtp://user:password@smtp.cloudmta.net:587`. However, these can be set
manually.

For details of the email parameter check the documentation.

CloudMailin will construct the message for you from the supplied parameters.
During development `TestMode: true` will ensure that messages aren't actually
sent to the recipient. When you're ready to send just remove this or set it to
false.

That's it! The message ID should have been populated on the message struct and
you can now head to the [summary].

## Sending email with Go via SMTP

Sending email in Go (GoLang) is simple with the inbuilt `net/smtp` package. Go
will automatically attempt to negotiate a TLS connection using STARTTLS when
using `SendMail`.

All we need to do is create `smtp.PlainAuth` to perform authentication. Like
CloudMailin Go will only perform plain auth once the TLS connection is
established ([docs]).

```go
package main

import (
  "log"
  "net/smtp"
)

func main() {
  // hostname is used by PlainAuth to validate the TLS certificate.
  hostname := "host from account"
  auth := smtp.PlainAuth("", "username from account", "password from account", hostname)

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
by using additional third-party libraries. If you need help with emails in go feel free to
[contact us].

<%= render 'outbound_summary' %>

[Sending Email with Go via API]: #sending-email-with-go-via-http-api
[Sending Email with Go via SMTP]: #sending-email-with-go-via-smtp
[cloudmailin-go]: https://pkg.go.dev/github.com/cloudmailin/cloudmailin-go
[docs]: https://go.dev/pkg/net/smtp/#PlainAuth
[OutboundMail]: https://pkg.go.dev/github.com/cloudmailin/cloudmailin-go#OutboundMail
