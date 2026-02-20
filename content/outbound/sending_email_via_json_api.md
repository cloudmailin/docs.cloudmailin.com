---
title: Sending Email via the CloudMailin API
description: CloudMailin's API documentation to send email via JSON API
image: http
---

# CloudMailin Send Email Message API

To send an email via the API, create a POST request to the Email Message endpoint:

`POST`: `https://api.cloudmailin.com/api/v0.1/{SMTP_USERNAME}/messages`.

There are several ways to send email:

* Use a [client library] if one is available for your language or framework
* Make an HTTP POST with a [JSON message](#json-message) — CloudMailin will construct the email for you
* Make an HTTP POST with a [raw RFC822 message](#raw-message) — useful if you're building the email yourself or migrating from another provider

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

If your language or framework isn't listed above you can make a
request directly to the Outbound Email API.

You can also send email using any language or framework via [SMTP].

### Authentication

Authentication relies on your username and password from your SMTP credentials.
You can find your SMTP credentials for both live and test accounts on the
[SMTP Accounts] page. Your SMTP username is part of the path used to make the
request: `POST`:
`https://api.cloudmailin.com/api/v0.1/[SMTP_USERNAME]/messages`

You then need to send your SMTP API Token.
Authentication is via the Bearer token in the Authorization header as follows:
`Authorization: Bearer API_TOKEN`.

## JSON Message

The simplest way to send email is to POST a JSON object with the message fields.
CloudMailin will construct the email for you.

### Example

```json
<%= render_api_example("components/schemas/Message") %>
```

### Fields

| Field         | Type    | Description                                                         |
|---------------|---------|---------------------------------------------------------------------|
<%= render_api_fields("components/schemas/Message", include_readonly: false, except: %w[headers attachments]) %>
| `headers`     | object  | See the [headers section](#headers)
| `attachments` | array of attachment objects | See the [attachments section](#attachments)

### Attachments

Attachments require the following fields:

| Field         | Type    | Description                                                         |
|---------------|---------|---------------------------------------------------------------------|
<%= render_api_fields("components/schemas/MessageAttachment") %>

For example:

```json
<%= render_api_example("components/schemas/MessageAttachment") %>
```

### Headers

Headers are not required as the subject, to and from headers will be set automatically.
If you need to specify additional headers you can pass them as an object.
The key is the header name and the value is expected to be a string:

```json
"headers": {
  "x-api-test": "Test",
  "x-additional-header": "Value"
}
```

## Raw Message

If you already have a constructed RFC822 email you can send it directly using
the `raw` field instead of `plain`/`html`. This is useful if you're generating
emails with your own library or migrating from another provider.

### Example

```json
<%= render_api_example("components/schemas/RawMessage") %>
```

### Fields

| Field         | Type    | Description                                                         |
|---------------|---------|---------------------------------------------------------------------|
<%= render_api_fields("components/schemas/RawMessage", include_readonly: false, except: %w[headers attachments]) %>

[Client Library]: #client-libraries
[SMTP Accounts]: https://www.cloudmailin.com/outbound/senders
[SMTP]: <%= url_to_item('/outbound/sending_email_with_smtp/') %>
