---
title: Receiving Email with Go (Golang)
skip_erb: false
image: ruby
---

# Receiving Inbound Email with Go (Golang)

There are a few ways to receive email with Go. However, a number of these can be
quite involved. With CloudMailin your email is delivered to your application
via HTTP POST as a JSON Webhook.

CloudMailin provides a Go package to make receiving email via webhook within
your Go application trivial.


You can install the package using:

```console
go get -u github.com/cloudmailin/cloudmailin-go
```

## Receiving email via HTTP POST in Go

Once the package is installed we'll use the standard HTTP server to listen for
the HTTP POST. However, this will work with any HTTP Server.

> To work with Go, we require the JSON (Normalized) version of our HTTP POST

```go
import (
  "net/http"

  "github.com/cloudmailin/cloudmailin-go"
)

func main() {
  http.HandleFunc("/", handleIncomingPOST)

  // Start the HTTP server to listen for HTTP POST
  http.ListenAndServe(":8080", nil)
}
```

When CloudMailin receives an email it will make an HTTP Request to our site.
When the HTTP server receives a request we'll parse the JSON into a struct using
the cloudmailin-go package:

```go
func handleIncomingPOST(w http.ResponseWriter, req *http.Request) {
  // Parse the message from the request body
  message, err := cloudmailin.ParseIncoming(req.Body)
  if err != nil {
    http.Error(w, "Error parsing message: "+err.Error(), http.StatusUnprocessableEntity)
    return
  }

  // Output the first instance of the message-id in the headers to show
  // that we correctly parsed the message. We could also use the helper
  // message.Headers.MessageID().
  fmt.Fprint(w, "Thanks for message: ", message.Headers.First("message_id"))
}
```

The JSON is parsed into a struct containing our email message.

## Parsing email headers with CloudMailin Go

As you can see in the above example the email headers are parsed and can be
found using a few helpers such as `message.Headers.first("message_id")`.

The format of the Go struct pretty closely matches the JSON provided by
CloudMailin in the webhook. However, headers are always returned as an instance
of [IncomingMailHeaders]. This is because CloudMailin may return a string or
an array of strings for headers.

The format is also expected to be underscored, the same as the JSON Webhook format
from CloudMailin. This means for example that the email Message-ID header will
be message_id. More details can be found in the [JSON normalized format] docs.

| Name                        | Description |
|-----------------------------|-------------|
| message.Headers.Find()      | Parses the email headers and finds all headers with the given string as the key.
| message.Headers.First()     | Finds the first instance of a given header (the bottom header).
| message.Headers.Last()      | Finds the latest instance of a given headers (the one at the top).
| message.Headers.To()        | A convenience helper to find the email To Header.
| message.Headers.MessageID() | A convenience helper to find the Message-ID Header.
| message.Headers.Subject()   | A convenience helper to find the email subject.
| message.Headers.From()       | A convenience helper to find the email From Header.

## Getting the email body

Once we've parsed the email webhook we can request several parameters.

| Name               | Description |
|--------------------|-------------|
| message.Plain      | The plain text body of the email if it is present.
| message.ReplyPlain | The reply extracted from the plain part if it is a reply.
| message.HTML       | The HTML body of the email if it is present.

If you always require a plain text version of the email please [contact us] as
we can enable HTML to Plain text extraction to provide a plain text version of
the email even if one was not present within the email itself.

```go
body := message.ReplyPlain
if body == "" {
  body = message.Plain
}

log.Println("Reply: ", body)
log.Println("HTML: ", message.HTML)
```

## The email envelope

When an email is sent over SMTP there are a number of parameters. CloudMailin
refers to these as the 'envelope'. This includes to SMTP to, from, the sender's
IP address and other related information. See the [IncomingMailEnvelope]
documentation for details.

```go
if strings.HasPrefix(message.Envelope.To, "noreply@") {
  http.Error(w, "No replies please", http.StatusForbidden)
  return
}
```

In the above example we return a 404 status code in order to request that
CloudMailin bounces any messages starting with noreply (see
[HTTP Status Codes]).

## Attachments

Attachments are passed along in one of two methods. Attachment bodies may either
be Base64 encoded into the JSON or, if you have enabled the [Attachment Storage]
then you will simply receive a URL to the file.

See the [Package Documentation] for all of the parameters of the attachment,
including the original filename, content or URL.

```go
log.Println("Attachment Name: ", message.Attachments[0].FileName)
log.Println("Attachment URL: ", message.Attachments[0].URL)
```

## The full example email to Webhook with Go

Below we've included the full example from the above email details:

```go
package main

import (
  "fmt"
  "log"
  "net/http"

  "github.com/cloudmailin/cloudmailin-go"
  )

func main() {
  http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
    message, err := cloudmailin.ParseIncoming(req.Body)
    if err != nil {
      http.Error(w, "Error parsing message: "+err.Error(), http.StatusUnprocessableEntity)
      return
    }

    if strings.HasPrefix(message.Envelope.To, "noreply@") {
      http.Error(w, "No replies please", http.StatusForbidden)
      return
    }

    body := message.ReplyPlain
    if body == "" {
      body = message.Plain
    }

    fmt.Fprintln(w, "Thanks for message: ", message.Headers.First("message_id"))

    log.Println("Reply: ", body)
    log.Println("HTML: ", message.HTML)

    log.Println("Attachment Name: ", message.Attachments[0].FileName)
    log.Println("Attachment URL: ", message.Attachments[0].URL)
  })

  http.ListenAndServe(":8080", nil)
}
```

---

<%= items["/receiving_email/examples/_summary/"].raw_content %>

[IncomingMailEnvelope]: https://pkg.go.dev/github.com/cloudmailin/cloudmailin-go#IncomingMailEnvelope
[Package Documentation]: https://pkg.go.dev/github.com/cloudmailin/cloudmailin-go
[IncomingMailHeaders]: https://pkg.go.dev/github.com/cloudmailin/cloudmailin-go#IncomingMailHeaders
[JSON normalized format]: <%= url_to_item('json_normalized') %>
[Attachment Storage]: <%= url_to_item('store-email-attachments-in-s3-azure-google-storage') %>
[HTTP Status Codes]: <%= url_to_item('http_status_codes') %>
