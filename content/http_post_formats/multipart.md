---
title: Multipart Form Data Hash Format
---

# Multipart/form-data Hash Email Message Format

The JSON and multipart formats are incredibly similar. It's only the transport method that differs. The format consists of four main elements, `envelope`, `headers`, `body` and `attachments`. The `body` consists of two parameters `plain` and `html`.

| parameter     | details                 | description                                                                   |
|-------------------------------------------------------------------------------------------------------------------------|
| `envelope`    | [details](#envelope)    | This is the message envelope. The details that our server receives from the sending server.   |
| `headers`     | [details](#headers)     | These are the email headers they use the notation headers[field_name] to represent the array. |
| `plain`       | [details](#body)        | The email body as plain-text.                                                 |
| `html`        | [details](#body)        | The email as HTML (if a HTML version is available).                           |
| `reply_plain` | [details](#body)        | The plain text reply extracted from this message is present / found.          |
| `attachments` | [details](#attachments) | The message attachments.                                                      |

The following is complete example Multipart message:

    ------cloudmailinboundry
    Content-Disposition: form-data; name="plain"

    Test with HTML.
    ------cloudmailinboundry
    Content-Disposition: form-data; name="html"

    <html><head>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"></head><body
     bgcolor="#FFFFFF" text="#000000">
    Test with <span style="font-weight: bold;">HTML</span>.<br>
    </body>
    </html>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="reply_plain"

    Message reply if found.
    ------cloudmailinboundry

    Content-Disposition: form-data; name="headers[Return-Path]"

    from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][0]"

    by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][1]"

    by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][2]"

    from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Date]"

    Mon, 16 Jan 2012 17:00:01 +0000
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[From]"

    Message Sender <sender@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[To]"

    Message Recipient <to@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Message-ID]"

    <4F145791.8040802@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Subject]"

    Test Subject
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Mime-Version]"

    1.0
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Delivered-To]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received-SPF]"

    neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Authentication-Results]"

    mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[User-Agent]"

    Postbox 3.0.2 (Macintosh/20111203)
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[to]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[recipients][0]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[from]"

    from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[helo_domain]"

    localhost
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[remote_ip]"

    127.0.0.1
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[spf][result]"

    pass
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[spf][domain]"

    example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0]"; filename="file1.txt"
    Content-Type: text/plain

    testfile
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1]"; filename="file2.txt"
    Content-Type: text/plain

    testfile
    ------cloudmailinboundry--

## Envelope

The envelope contains the data sent or gathered from the remote server. It doesn't contain any of the message content. It contains details of the transaction that took place between the sending server and CloudMailin.

| field         | Details
|---------------|-------------------------------------------------------------------------------------|
| `to`          | The email address the server is sending to. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `recipients`  | The full list of recipients that the remote server is attempting to send to in this transaction. For more details see [multiple_recipients](/receiving_email/multiple_recipients/). |
| `from`        | The email address that the server was sending from. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `helo_domain` | The domain reported by the sending server as it sends the `helo` or `ehlo` command. |
| `remote_ip`   | The remote IP address of the sending server if available.                           |
| `spf`         | The [SPF](/features/spf/) result for the given IP address and Domain.               |

The following is an example envelope:

    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[to]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[recipients][0]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[from]"

    from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[helo_domain]"

    localhost
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[remote_ip]"

    127.0.0.1
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[spf][result]"

    pass
    ------cloudmailinboundry
    Content-Disposition: form-data; name="envelope[spf][domain]"

    example.com

## Headers

The headers parameter contains all of the message headers extracted from the email. Headers occurring multiple times (such as the `received` header) will send the value as an array if there are multiple occurrences or as a string if the header only occurs once.

The following is an example message header:

    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Return-Path]"

    from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][0]"

    by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][1]"

    by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received][2]"

    from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Date]"

    Mon, 16 Jan 2012 17:00:01 +0000
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[From]"

    Message Sender <sender@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[To]"

    Message Recipient <to@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Message-ID]"

    <4F145791.8040802@example.com>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Subject]"

    Test Subject
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Mime-Version]"

    1.0
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Delivered-To]"

    to@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Received-SPF]"

    neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[Authentication-Results]"

    mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com
    ------cloudmailinboundry
    Content-Disposition: form-data; name="headers[User-Agent]"

    Postbox 3.0.2 (Macintosh/20111203)

## Body

CloudMailin will send the message body in both plain and html formats if they're available. It's always worth using the other parameter as a fallback. If `html` if unavailable then `plain` should always contain the message content. The message body should be encoded into `utf-8` format.

    ------cloudmailinboundry
    Content-Disposition: form-data; name="plain"

    Test with HTML.
    ------cloudmailinboundry
    Content-Disposition: form-data; name="html"

    <html><head>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1"></head><body
     bgcolor="#FFFFFF" text="#000000">
    Test with <span style="font-weight: bold;">HTML</span>.<br>
    </body>
    </html>
    ------cloudmailinboundry
    Content-Disposition: form-data; name="reply_plain"

    Message reply if found.

For more details about the extracted reply see [reply parsing](/features/extracting_replies_from_email/).

## Attachments

Attachments in the new message formats come in three different forms:

| No Attachments        | If there are no attachments the attachments parameter will not be present for the multipart format. |
| URL Attachments       | URL Attachments are attachments that have been sent to an [attachment store](/receiving_email/attachments/). In these cases the message content is stored remotely and a URL to the attachment plus the attachment details are provided. |
| Embedded Attachments  | Attachments will be sent as multipart/form-data attachments. No decoding should be required and some frameworks will automatically create temporary files for these attachements |

### URL Attachments

URL based attachments will contain the following parameters:

| Field           | Description                                                                                          |
|------------------------------------------------------------------------------------------------------------------------|
| `url`           | A URL to the attachment if the attachment is within an attachment store.                             |
| `file_name`     | The original file name of the attachment.                                                            |
| `content_type`  | The content type of the attachment.                                                                  |
| `size`          | The size of the attachment.                                                                          |
| `disposition`   | The disposition of the attachment either `attachment` or `inline`                                    |

URL attachments are attachments that have been sent to a message store. Instead of content they will contain a link to allow you to retrieve that content. URL attachments will be formatted as an array of attachment details. The following is an attachments parameter containing URL attachments:

    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0][file_name]"

    file.txt
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0][content_type]"

    text/plain
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0][size]"

    8
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0][disposition]"

    attachment
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0][url]"

    http://example.com/file.txt
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1][file_name]"

    file.txt
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1][content_type]"

    text/plain
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1][size]"

    8
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1][disposition]"

    attachment
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1][url]"

http://example.com/file.txt
CloudMailin will upload attachments using a random filename generated by our system. For more details relating to attachment stores see [attachment store](/receiving_email/attachments/).

### Embedded Attachments

Embedded attachments are attachments that send the attachment content direct to your email server. The don't recommend that large attachments are sent in this way as they can cause a lot of overhead for your server. The attachments will be send like normal `multipart/form-data` attachments. Many frameworks will automatically extract these attachments and place them into temporary files. The following is an attachments parameter containing embedded attachments:

    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[0]"; filename="file1.txt"
    Content-Type: text/plain

    testfile
    ------cloudmailinboundry
    Content-Disposition: form-data; name="attachments[1]"; filename="file2.txt"
    Content-Type: text/plain

    testfile

Embedded attachments are sent using binary encoding. The example above contains two attachments named file1.txt and file2.txt both containing the plain text 'testfile' as their content.
