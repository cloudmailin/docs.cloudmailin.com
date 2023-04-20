---
title: Sending Email via the CloudMailin API
description: CloudMailin's API documentation to send email via JSON API
image: http
---

# CloudMailin Send Email Message API

In order to send an email via API you can create a POST request to the Email
Message endpoint:

`POST`: `https://api.cloudmailin.com/api/v0.1/{SMTP_USERNAME}/messages`.

Sending email via HTTP POST can be done via one of two methods:

* If a [client library] is available for your Programming Language / Framework
  you can use a client library; Alternatively;
* you can make an HTTP POST to our API manually to send the email

## Client Libraries

Some languages and frameworks have official or community libraries to help get started:

| Language / Framework | Status      | Library                         | Link |
|----------------------|-------------|---------------------------------|------|
| [node/typescript]    | released    | `npm install --save cloudmailin` | [link](https://github.com/cloudmailin/cloudmailin-js)
| [go]                 | beta        | `go get -u github.com/cloudmailin/cloudmailin-go` | [link](https://github.com/cloudmailin/cloudmailin-go)
| `ruby`               | coming soon |

[node/typescript]: /outbound/examples/send_email_with_node_js/
[go]: /outbound/examples/send_email_with_golang/

We're adding new libraries regularly and this is an area under active
development.

> If you've created a community library we'd love to hear from you.
> [Contact Us] and let us know!

## Sending Email with an API Call

If your Language / Framework isn't listed above then you can always make a
request directly to the Outbound Email API.

You can also use any language / framework via [SMTP].

### Authentication

Authentication relies on your username and password from you SMTP credentials.
You can find your SMTP credentials for both live and test accounts on the
[SMTP Accounts] page. Your SMTP username is part of the path used to make the
SMTP request: `POST`:
`https://api.cloudmailin.com/api/v0.1/[SMTP_USERNAME]/messages`

You then need to send your SMTP API Token.
Authentication is via the Bearer token in the Authorization header as follows:
`Authorization: Bearer API_TOKEN`.

> This documentation is currently a work in progress. If you need help sending
> via the API please feel free to contact us, alternatively you may wish to use
> [SMTP], which is fully functional.

## Email Messages Endpoint Example

A full example POST can be seen below:

```json
{
  "from": "Sender Name <sender@example.com>",
  "to": [
    "Recipient <recipient@example.com>",
    "Another <another@example.com>"
  ],
  "test_mode": false,
  "subject": "Hello from CloudMailin 😃",
  "tags": [
    "api-tag",
    "cloudmailin-tag"
  ],
  "plain": "Hello Plain Text",
  "html": "<h1>Hello Html</h1>",
  "headers": {
    "x-api-test": "Test",
    "x-additional-header": "Value"
  },
  "attachments": [
    {
      "file_name": "pixel.png",
      "content": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP0rdr1HwAFHwKCk87e6gAAAABJRU5ErkJggg==",
      "content_type": "image/png",
      "content_id": null
    }
  ]
}
```

Below you can see an explanation of the [fields](#fields), how to add
[attachments](#attachments) and how to set custom [headers](#headers).

### Fields

The API allows sending with the following fields:

| Field         | Type    | Description                                                         |
|---------------|---------|---------------------------------------------------------------------|
<%= render_api_fields("components/schemas/MessageCommon/properties/", 'from', 'to', 'test_mode', 'subject', 'tags') %>
<%= render_api_fields("components/schemas/Message/allOf/1/properties", 'plain', 'html') %>
| `headers`     | object  | See the [headers section](#headers)
| `attachments` | Arrary of attachment objects | See the [attachments section](#attachments)

### Attachments

Attachments are slightly more complicated and require the following fields

| Field         | Type    | Description                                                         |
|---------------|---------|---------------------------------------------------------------------|
<%= render_api_fields("components/schemas/MessageAttachment/properties/") %>

For example this attaches a one-pixel image (Base64 encoded):

```json
"attachments": [
  {
    "file_name": "pixel.png",
    "content": "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP0rdr1HwAFHwKCk87e6gAAAABJRU5ErkJggg==",
    "content_type": "image/png",
    "content_id": null
  }
]
```

### Headers

Headers are not required as the subject, to and from headers will be set. However, if you need to
specify additional headers you can pass them as  an object.
The key is the header name and the value is expected to be a string a string value:

```json
"headers": {
  "x-api-test": "Test",
  "x-additional-header": "Value"
}
```

[Client Library]: #client-libraries
[SMTP Accounts]: https://www.cloudmailin.com/outbound/senders
[SMTP]: <%= url_to_item('/outbound/sending_email_with_smtp/') %>
