---
title: Receiving Email via HTTP API (POST) - Formats
description: JSON, Multipart/form-data or RAW email. CloudMailin allows your API / App receive email in several different formats over HTTP (POST) Webhook.
---

# Receiving Your Email via HTTP (POST) API

* [Formats](#)
* [Testing A Format](#testing-a-format)
* [Older (Deprecated) Formats](#older--deprecated--formats)

CloudMailin sends your email as an HTTP POST to the URL that you specify. There are several formats to choose from:

| Format                 | Details                                             | Description |
|------------------------|-----------------------------------------------------|-------------|
| `Multipart Normalized` | [details](/http_post_formats/multipart_normalized/) | A new `multipart/form-data` based format consisting of four main parts `envelope`, `headers`, `body`, `attachments`. this normalizes headers and arrays to make things more consistent. We recommend using this as the default for new projects.
| `JSON Normalized`      | [details](/http_post_formats/json_normalized/)      | Exactly the same as the `multipart` format but this uses `JSON` to encode the details it normalizes headers and arrays to make things more consistent. We recommend using this as the default for new projects.
| `Raw Message`          | [details](/http_post_formats/raw/)                  | This sends just original Raw message as a single `multipart/form-data` request parameter.

> If you're starting a fresh app then the <%= link_to_item '/http_post_formats/multipart_normalized/' %>
> or <%= link_to_item '/http_post_formats/json_normalized/' %> will be useful depending on
> whether you prefer to work with JSON or not.

We recommend using the <%= link_to_item '/http_post_formats/multipart_normalized/' %>
though as it's generally the easiest to work with in modern web frameworks.

If you just want to use CloudMailin to forward the entire email to your website over http without
parsing or processing it at all then the [Raw format](/http_post_formats/raw/) does exactly that.

## Testing a Format

### Webhook App

If you want to see how a format will look with your own content we recommend using the [WebhookApp]. Simply set the [WebhookApp] as your message url target and then send an email. The message content will then be sent over HTTP to the app using WebSockets so you can view this content and try out the format.

### Postman

We also have some examples in Postman that you can use to start development before you send your
own mail. The examples include an email message with all the expected attributes and an attachment.

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/93865eabe09f106dacad)

---

## Older (Deprecated) Formats

The original and standard multipart / JSON formats should be considered deprecated but are still
available for apps that are currently using them.

| Format                 | Details                                  | Description |
|------------------------|------------------------------------------|-------------|
| `Multipart`            | [details](/http_post_formats/multipart/) | An older `multipart/form-data` based format consisting of four main parts `envelope`, `headers`, `body`, `attachments`.
| `JSON`                 | [details](/http_post_formats/json/)      | An older `JSON` format, the same as the `multipart` format but this uses `JSON` to encode the details.
| `Original`             | [details](/http_post_formats/original/)  | The original CloudMailin message format (only recommended for legacy projects).
