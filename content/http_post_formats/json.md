---
title: JSON Hash Format
---

# JSON Hash Email Message Format

The JSON and multipart formats are incredibly similar. It's only the transport method that differs. The format consists of four main elements, `envelope`, `headers`, `body` and `attachments`. The `body` consists of two parameters `plain` and `html`.

| parameter     | details                 | description                                                                                 |
|---------------|-------------------------|---------------------------------------------------------------------------------------------|
| `envelope`    | [details](#envelope)    | This is the message envelope. The details that our server receives from the sending server. |
| `headers`     | [details](#headers)     | These are the email headers as an array of JSON objects of keys and values.                 |
| `plain`       | [details](#body)        | The email body as plain-text.                                                               |
| `html`        | [details](#body)        | The email as HTML (if a HTML version is available).                                         |
| `reply_plain` | [details](#body)        | The plain text reply extracted from this message is present / found.                        |
| `attachments` | [details](#attachments) | The message attachments.                                                                    |

The following is complete example JSON message:

    {
      "headers": {
        "Return-Path": "from@example.com",
        "Received": [
          "by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800",
          "by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800",
          "from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"
        ],
        "Date": "Mon, 16 Jan 2012 17:00:01 +0000",
        "From": "Message Sender <sender@example.com>",
        "To": "Message Recipient<to@example.co.uk>",
        "Message-ID": "<4F145791.8040802@example.com>",
        "Subject": "Test Subject",
        "Mime-Version": "1.0",
        "Content-Type": "multipart/alternative; boundary=------------090409040602000601080801",
        "Delivered-To": "to@example.com",
        "Received-SPF": "neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;",
        "Authentication-Results": "mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com",
        "User-Agent": "Postbox 3.0.2 (Macintosh/20111203)"
      },
      "envelope": {
        "to": "to@example.com",
        "from": "from@example.com",
        "helo_domain": "localhost",
        "remote_ip": "127.0.0.1",
        "recipients": [
          "to@example.com",
          "another@example.com"
        ],
        "spf": {
          "result": "pass",
          "domain": "example.com"
        }
      },
      "plain": "Test with HTML.",
      "html": "<html><head>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\n bgcolor=\"#FFFFFF\" text=\"#000000\">\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\n</body>\n</html>",
      "reply_plain": "Message reply if found.",
      "attachments": [
        {
          "content": "dGVzdGZpbGU=",
          "file_name": "file.txt",
          "content_type": "text/plain",
          "size": 8,
          "disposition": "attachment"
        },
        {
          "content": "dGVzdGZpbGU=",
          "file_name": "file.txt",
          "content_type": "text/plain",
          "size": 8,
          "disposition": "attachment"
        }
      ]
    }

## Envelope

The envelope contains the data sent or gathered from the remote server. It doesn't contain any of the message content. It contains details of the transaction that took place between the sending server and CloudMailin.

| field         | Details                                                                                                 |
|---------------|---------------------------------------------------------------------------------------------------------|
| `to`          | The email address the server is sending to. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter.                                                                   |
| `recipients`  | The full list of recipients that the remote server is attempting to send to in this transaction. For more details see [multiple_recipients](/receiving_email/multiple_recipients/).                                                              |
| `from`        | The email address that the server was sending from. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `helo_domain` | The domain reported by the sending server as it sends the `helo` or `ehlo` command.                     |
| `remote_ip`   | The remote IP address of the sending server if available.                                               |
| `spf`         | The [SPF](/features/spf/) result for the given IP address and Domain.                                   |

The following is an example envelope:

    "envelope": {
      "to": "to@example.com",
      "recipients": [
          "to@example.com",
          "another@example.com"
        ],
      "from": "from@example.com",
      "helo_domain": "localhost",
      "remote_ip": "127.0.0.1",
      "spf": {
        "result": "pass",
        "domain": "example.com"
      }
    }

## Headers

The headers parameter contains all of the message headers extracted from the email. Headers occurring multiple times (such as the `received` header) will send the value as an array if there are multiple occurrences or as a string if the header only occurs once.

The following is an example message header:

    "headers": {
      "Return-Path": "from@example.com",
      "Received": [
        "by 10.0.0.1 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800",
        "by 10.0.10.1 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800",
      ],
      "Date": "Mon, 16 Jan 2012 17:00:01 +0000",
      "From": "Message Sender <sender@example.com>",
      "To": "Message Recipient<to@example.co.uk>",
      "Message-ID": "<4F145791.8040802@example.com>",
      "Subject": "Test Subject"
    }

## Body

CloudMailin will send the message body in both plain and html formats if they're available. It's always worth using the other parameter as a fallback. If `html` if unavailable then `plain` should always contain the message content. The message body should be encoded into `utf-8` format.

    "plain": "Test with HTML.",
    "html": "<html><head>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\n bgcolor=\"#FFFFFF\" text=\"#000000\">\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\n</body>\n</html>"
    "reply_plain": "Message reply if found."

For more details about the extracted reply see [reply parsing](/features/extracting_replies_from_email/).

## Attachments

Attachments in the new message formats come in three different forms:

| Attachment Type       | Description                                                                                         |
|-----------------------|-----------------------------------------------------------------------------------------------------|
| No Attachments        | If there are no attachments then an empty array will always be passed to the attachments parameter. |
| URL Attachments       | URL Attachments are attachments that have been sent to an [attachment store](/receiving_email/attachments/). In these cases the message content is stored remotely and a URL to the attachment plus the attachment details are provided.            |
| Embedded Attachments  | With embedded attachments the attachment content is passed in `base-64` encoding to the `content` parameter of the attachment |

The attachments will contain the following parameters:

| Field           | Description                                                                                          |
|-----------------|------------------------------------------------------------------------------------------------------|
| `content`       | The content of the attachment in `base-64` encoding, if the message isn't using an attachment store. |
| `url`           | A URL to the attachment if the attachment is within an attachment store.                             |
| `file_name`     | The original file name of the attachment.                                                            |
| `content_type`  | The content type of the attachment.                                                                  |
| `size`          | The size of the attachment.                                                                          |
| `disposition`   | The disposition of the attachment either `attachment` or `inline`                                    |


### URL Attachments

URL attachments are attachments that have been sent to a message store. Instead of content they will contain a link to allow you to retrieve that content. The following is an attachments parameter containing URL attachments:

    "attachments": [
      {
        "file_name": "file1.txt",
        "content_type": "text/plain",
        "size": 8,
        "disposition": "attachment",
        "url": "http://example.com/file1.txt"
      },
      {
        "file_name": "file2.txt",
        "content_type": "text/plain",
        "size": 8,
        "disposition": "attachment",
        "url": "http://example.com/file2.txt"
      }
    ]

CloudMailin will upload attachments using a random filename generated by our system. For more details relating to attachment stores see [attachment store](/receiving_email/attachments/).

### Embedded Attachments

Embedded attachments are attachments that send the attachment content direct to your email server. The don't recommend that large attachments are sent in this way as they can cause a lot of overhead for your server. The following is an attachments parameter containing embedded attachments:

    "attachments": [
      {
        "content": "dGVzdGZpbGU=",
        "file_name": "file1.txt",
        "content_type": "text/plain",
        "size": 8,
        "disposition": "attachment"
      },
      {
        "content": "dGVzdGZpbGU=",
        "file_name": "file2.txt",
        "content_type": "text/plain",
        "size": 8,
        "disposition": "attachment"
      }
    ]

Embedded attachments are sent using `base-64` encoding. The example above contains two attachments named file1.txt and file2.txt both containing the plain text 'testfile' as their content.
