---
title: Receiving Email with Node JS and Typescript
description: |
  There are a number of ways to receive email in Node.js or TypeScript.
  We'll cover the simplest, using CloudMailin to receive email with your Node app as JSON by HTTP POST.
skip_erb: false
image: node
---

# Receiving Email with Node.js and TypeScript

It's possible to receive an email in Node.js using a couple of different methods.
However, a number of these can be quite involved.
With [CloudMailin] your email is delivered to your application over HTTP POST as JSON.

All of the examples here are in TypeScript and JavaScript. You can click
the link in each example to change between the two.

> To work with Node, we recommend the JSON (Normalized) version of our HTTP POST

## Express

We're going to use Express to receive our email as an HTTP POST.
Express can automatically parse JSON bodies using the [body parser] middleware.

```typescript
import express from "express";
import bodyParser from "body-parser";

const app = express();

app.use(bodyParser.json());

app.post("/incoming_mails/", (req, res) => {
  console.log(req.body);

  res.send("Thanks!");
});

app.listen("80", "0.0.0.0", () => {
  console.log("server started http://0.0.0.0:80");
});
```
```javascript
var express = require("express");
var bodyParser = require("body-parser");

var app = express();

app.use(bodyParser.json());

app.post("/incoming_mail/", function (req, res) {
    console.log(req.body);

    res.status(201).json({ status: "OK!" });
});

app.listen(80, "0.0.0.0", function () {
    console.log("server started http://0.0.0.0:80");
});
```

Here we've created a basic express app framework, parsed the JSON so that the value of
`req.body` is a Javascript object (which we log) and returned a response.

Next, we'll take a look at a few parts of the email.

## Getting TypeScript Types for the HTTP POST JSON

To make the next part simpler, we can fetch an interface for the CloudMailin HTTP POST.
The interface allows us to strongly-type the JSON from the inbound HTTP POST.

To get started, we'll add the `cloudmailin` [NPM package]:

```shell
npm install --save-dev cloudmailin
```

Once the package is installed, we can import the InboundPost Interface from the CloudMailin
NPM package:

```typescript
import { IncomingMail } from "cloudmailin";
```
```javascript
// This only applies to typescript
```

We can then cast the request body into our `IncomingMail`.

```typescript
app.post("/incoming_mails/", (req, res) => {
  const mail = <IncomingMail>req.body;

  res.status(201).json(mail);
}
```
```javascript
```

## The Envelope (SMTP Transaction)

The SMTP transaction itself receives a recipient (`to`) and a mail (`from`) command.
This allows the server to route the email.
We also retain some other information, such as the remote server IP, encryption (TLS) status
and the SPF result for the SMTP request.

More details about the format of the POST can be found in the [HTTP POST Formats]
documentation.

> Often you don't want the to/from address in the envelope (SMTP) if your email is
> being forwarded.
> The intended information is normally available in the headers and is often different and
> preferable. Feel free to [contact us] if you need help deciding which to use.

We can implement a simple check to accept or reject the email based on the SMTP transaction's
`RCPT TO` like the following:

```typescript
app.post("/incoming_mails/", (req, res) => {
  const mail = <IncomingMail>req.body;

  if (mail.envelope.to == 'test@cloudmailin.net') {
    res.status(201).json({ status: "OK!" });
    return;
  }

  res.status(422).json({ status: `Incorrect User ${mail.envelope.to}` });
});
```
```javascript
app.post("/incoming_mail/", function (req, res) {
    var mail = req.body;
    if (mail.envelope.to == 'test@cloudmailin.net') {
        res.status(201).json({ status: "OK!" });
        return;
    }
    res.status(422).json({ status: "Incorrect User " + mail.envelope.to });
});
```

Note that the CloudMailin server will respond to the SMTP sending server as if the
mailbox does not exist if we return the `422` status code (see [Status Codes]).

## The Headers

All of the headers can be found in the `headers` parameter. This is an object containing
the header key and either a string or array of strings.

Note that if the header was specified more than once in the original Mime email then the
object will contain an array of strings rather than a string.

```typescript
app.post("/incoming_mails", (req, res) => {
  const mail = <IncomingMail>req.body;

  console.log(mail.headers.received);
  console.log(mail.headers.to);
  console.log(mail.headers.cc);
  console.log(mail.headers.from);

  res.status(201).json({ headers: mail.headers });
});
```
```javascript
app.post("/incoming_mails", function (req, res) {
    var mail = req.body;
    console.log(mail.headers.received);
    console.log(mail.headers.to);
    console.log(mail.headers.cc);
    console.log(mail.headers.from);
    res.status(201).json({ headers: mail.headers });
});
```

## Plain, HTML and Replies

The plain and HTML parts of the email can be found in the `plain` and `html` fields.
Not all emails will have a plain AND html parameter so it generally makes sense to fall
back to the plain parameter for HTML.

```typescript
  const body = mail.html || mail.plain
  console.log(body)

  res.status(201).json({ body });
```
```javascript
    var body = mail.html || mail.plain;
    console.log(body);

    res.status(201).json({ body: body });
```

We also attempt to extract the latest reply to an email message and return that in the `reply_plain`.

## Attachments

Attachments are extracted and can be returned in one of two formats. The first format passes
the attachment content as Base64 encoded content within the JSON.

If this is the case, we can access the attachment with the following:

```typescript
  const attachment = mail.attachments[0];

  if (attachment.content) {
    const data: Buffer = Buffer.from(attachment.content, 'base64');
    fs.writeFileSync(attachment.file_name, data);

    return res.status(201).json({ status: `wrote ${attachment.file_name}` });
  }

  res.status(422).json({ status: "Content Not passed" });
```
```javascript
    var attachment = mail.attachments[0];
    if (attachment.content) {
        var data = Buffer.from(attachment.content, 'base64');
        fs.writeFileSync(attachment.file_name, data);
        return res.status(201).json({ status: "wrote " + attachment.file_name });
    }
    res.status(422).json({ status: "Content Not passed" });
```

### Using S3, Azure Storage, or Google Cloud Storage

Sending attachments within the JSON POST to your Node application is quite consuming.
Instead, it's possible for CloudMailin to offload this. CloudMain can send your email
attachments directly to Amazon's S3, Azure Storage, or Google Cloud Storage ([Attachment Store]).

```typescript
  const attachment = mail.attachments[0];

  if (attachment.url) {
    console.log(attachment.url)

    return res.status(201).json({ status: attachment.url });
  }

  res.status(422).json({ status: "URL not found" });
```
```javascript
    var attachment = mail.attachments[0];

    if (attachment.url) {
        console.log(attachment.url);
        return res.status(201).json({ status: attachment.url });
    }

    res.status(422).json({ status: "URL not found" });
```

In this case, we don't have to receive the full content of the attachment,
we receive a URL to the location of the uploaded file.

---

<%= items["/receiving_email/examples/_summary/"].raw_content %>

[NPM package]: https://www.npmjs.com/package/cloudmailin
[Status Codes]: <%= url_to_item('/receiving_email/http_status_codes/') %>
[HTTP POST Formats]: <%= url_to_item('/http_post_formats/') %>
[Attachment Store]: <%= url_to_item('/receiving_email/attachments/') %>
[Body Parser]: http://expressjs.com/en/resources/middleware/body-parser.html
