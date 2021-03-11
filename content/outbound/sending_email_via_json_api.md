---
title: Sending Email via the CloudMailin API
description: CloudMailin's API documentation to send email via JSON API
---

# CloudMailin Send Email Message API

In order to send an email via API you can create a POST request to the Message endpoint:
`POST`: `https://api.cloudmailin.com/api/v0.1/[SMTP_USERNAME]/messages`

###  Authentication

Authentication relies on your username and password from you SMTP credentails.
You can find your SMTP credentails for both live and test accounts on the [SMTP Accounts] page.
Your SMTP username is part of the path used to make the SMTP request:
`POST`: `https://api.cloudmailin.com/api/v0.1/[SMTP_USERNAME]/messages`

You then need to send your SMTP API Token.
Authentication is via the Bearer token in the Authorization header as follows:
`Authorization: Bearer API_TOKEN`.

> This documentation is currently a work in progress. If you need help sending via the API
> please feel free to contact us, alterrnatively you may wish to use [SMTP], which if
> fully functional.

## Messages Endpoint Example

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

Below you can see an explanation of the [fields](#fields), how to add [attachments](#attachments)
and how to set custom [headers](#headers).

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

## Libaries

Some languages and frameworks have official or community libraries to help get started:

| Language / Framework | Status      | Library                         |
|----------------------|-------------|---------------------------------|
| `node`/`typescript`  | beta        | `npm install --save cloudmailin`
| `ruby`               | coming soon |
| `go`                 | coming soon |

In the meantime you can still use any language / framework via [SMTP].

> If you've created a community library we'd love to hear from you. [Contact Us] and let us know!

[SMTP Accounts]: https://www.cloudmailin.com/outbound/accounts
[SMTP]: <%= url_to_item('/outbound/sending_email_with_smtp/') %>
