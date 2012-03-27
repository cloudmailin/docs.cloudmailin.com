---
title: Raw Message Format
---

# Raw Message Format

The raw message format sends an entire message as a single field within a `multipart/form-data` POST request. The parameter `message` will contain the entire unparsed email message in addition to the envelope.

| Field | Details                                                                                                 |
|-----------------------------------------------------------------------------------------------------------------|
| `message`   | The entire email as a string. This is unaltered from the format that CloudMailin receives it in.  |
| `envelope`  | This is the message envelope. The details that our server receives from the sending server.       |

## Envelope

The envelope contains the data sent or gathered from the remote server. It doesn't contain any of the message content. It contains details of the transaction that took place between the sending server and CloudMailin.

| Field         | Details
|---------------|-------------------------------------------------------------------------------------|
| `to`          | The email address the server is sending to. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `from`        | The email address that the server was sending from. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `helo_domain` | The domain reported by the sending server as it sends the `helo` or `ehlo' command. |
| `remote_ip`   | The remote IP address of the sending server if available.                           |