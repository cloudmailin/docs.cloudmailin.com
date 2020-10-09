---
title: JSON (Normalised) Hash Format
---

# Normalised JSON Hash Email Message Format

The JSON and multipart formats are incredibly similar. It's only the transport method that differs.
The normalised version just makes some small adjustments for consistency, for example, within the normalised version the headers are all lowercase with underscores.

The format consists of four main elements, `envelope`, `headers`, `body` and `attachments`. The `body` consists of two parameters `plain` and `html`.

| parameter     | details                 | description                                                                                 |
|---------------|-------------------------|---------------------------------------------------------------------------------------------|
| `envelope`    | [details](#envelope)    | This is the message envelope. The details that our server receives from the sending server. |
| `headers`     | [details](#headers)     | These are the email headers as an array of JSON objects of keys and values.                 |
| `plain`       | [details](#body)        | The email body as plain-text.                                                               |
| `html`        | [details](#body)        | The email as HTML (if a HTML version is available).                                         |
| `reply_plain` | [details](#body)        | The plain text reply extracted from this message is present / found.                        |
| `attachments` | [details](#attachments) | The message attachments.                                                                    |

The following is complete example JSON message:

```raw
{
  "headers": {
    "return_path": "from@example.com",
    "received": [
      "by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800",
      "by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800",
      "from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"
    ],
    "date": "Mon, 16 Jan 2012 17:00:01 +0000",
    "from": "Message Sender <sender@example.com>",
    "to": "Message Recipient<to@example.co.uk>",
    "message_id": "<4F145791.8040802@example.com>",
    "subject": "Test Subject",
    "mime_version": "1.0",
    "content_type": "multipart/alternative; boundary=------------090409040602000601080801",
    "delivered_to": "to@example.com",
    "received_spf": "neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;",
    "authentication_results": "mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com",
    "user_agent": "Postbox 3.0.2 (Macintosh/20111203)"
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
    },
    "tls": true,
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
```
```ruby
class IncomingMailsController < ApplicationController
  def create
    Rails.logger.info params
    message = Message.new(
      :to => params[:envelope][:to],
      :from => params[:envelope][:from],
      :subject => params[:headers][:subject],
      :body => params[:plain]
    )
    if message.save
      render json: { status: 'success' }
    else
      render json: { errors:  message.errors.full_messages }, status: 422, content_type: Mime::TEXT.to_s
    end
  end
end

#=> {"plain"=>"Test with HTML.", "html"=>"<html><head>\r\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\r\n bgcolor=\"#FFFFFF\" text=\"#000000\">\r\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\r\n</body>\r\n</html>", "reply_plain"=>"Message reply if found.", "headers"=>{"return_path"=>"from@example.com", "received"=>{"0"=>"by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "1"=>"by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "2"=>"from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"}, "date"=>"Mon, 16 Jan 2012 17:00:01 +0000", "from"=>"Message Sender <sender@example.com>", "to"=>"Message Recipient <to@example.com>", "message_id"=>"<4F145791.8040802@example.com>", "subject"=>"Test Subject", "mime_version"=>"1.0", "delivered_to"=>"to@example.com", "received_spf"=>"neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;", "Authentication-Results"=>"mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com", "user-agent"=>"Postbox 3.0.2 (Macintosh/20111203)"}, "envelope"=>{"to"=>"to@example.com", "recipients"=>["to@example.com"], "from"=>"from@example.com", "helo_domain"=>"localhost", "remote_ip"=>"127.0.0.1", "spf"=>{"result"=>"pass", "domain"=>"example.com"}}, "attachments"=>[{"content": "dGVzdGZpbGU=","file_name": "file.txt","content_type": "text/plain","size": 8,"disposition": "attachment"},{"content": "dGVzdGZpbGU=","file_name": "file.txt","content_type": "text/plain","size": 8,"disposition": "attachment"}]}
```
```php
<?php
  header("Content-type: text/plain");

  $to = $_POST['envelope']['to'];
  $subject = $_POST['headers']['subject'];
  $plain = $_POST['plain'];
  $html = $_POST['html'];
  $reply = $_POST['reply_plain'];

  if ($to == 'allowed@example.com'){
    header("HTTP/1.0 200 OK");
    echo('success');
  }else{
    header("HTTP/1.0 403 OK");
    echo('user not allowed here');
  }
  exit;
?>
```
```javascript
var parsedBody = JSON.parse(request.body);
console.log(parsedBody.from);
console.log(parsedBody.headers.subject);
console.log(parsedBody.plain);
console.log(parsedBody.html);
console.log(parsedBody.reply_plain);
```

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
| `tls`         | Whether the incoming message was sent to CloudMailin using TLS encryption.                              |

The following is an example envelope:

```raw
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
  },
  "tls": true
}
```
```ruby
  def create
    Rails.logger.info params[:envelope][:to] #=> "to@example.com"
    Rails.logger.info params[:envelope][:recipients] #=> ["to@example.com","another@example.com"]
    Rails.logger.info params[:envelope][:from] #=> "from@example.com"
    Rails.logger.info params[:envelope][:helo_domain] #=> "from@example.com"
    Rails.logger.info params[:envelope][:remote_ip] #=> "127.0.0.1"
    Rails.logger.info params[:envelope][:spf] #=> {"result"=>"pass", "domain"=>"example.com"}
  end
```
```php
<?php
  $to = $_POST['envelope']['to'];
  $from = $_POST['envelope']['from'];
  $recipients = $_POST['envelope']['recipients'];
  $domain = $_POST['envelope']['helo_domain'];
  $remote_ip = $_POST['envelope']['remote_ip'];
  $spf_domain = $_POST['envelope']['spf']['domain'];
  $spf_result = $_POST['envelope']['spf']['result'];
?>
```
```javascript
parsedBody = JSON.parse(request.body)
console.log(parsedBody.envelope.to)
console.log(parsedBody.envelope.from)
console.log(parsedBody.envelope.recipients)
console.log(parsedBody.helo_domain)
console.log(parsedBody.remote_ip)
console.log(parsedBody.spf.domain)
console.log(parsedBody.spf.result)
```

## Headers

The headers parameter contains all of the message headers extracted from the email. Headers occurring multiple times (such as the `received` header) will send the value as an array if there are multiple occurrences or as a string if the header only occurs once.

The following is an example message header:

```raw
"headers": {
  "return_path": "from@example.com",
  "received": [
    "by 10.0.0.1 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800",
    "by 10.0.10.1 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800",
  ],
  "date": "Mon, 16 Jan 2012 17:00:01 +0000",
  "from": "Message Sender <sender@example.com>",
  "to": "Message Recipient<to@example.co.uk>",
  "message_id": "<4F145791.8040802@example.com>",
  "subject": "Test Subject"
}
```
```ruby
def create
  Rails.logger.info params[:headers] #=> "headers"=>{"return_path"=>"from@example.com", "received"=>{"0"=>"by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "1"=>"by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "2"=>"from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"}, "Date"=>"Mon, 16 Jan 2012 17:00:01 +0000", "from"=>"Message Sender <sender@example.com>", "to"=>"Message Recipient <to@example.com>", "message_id"=>"<4F145791.8040802@example.com>", "subject"=>"Test Subject", "mime_version"=>"1.0", "delivered_to"=>"to@example.com", "[id]: url "title"eceived-SPF"=>"neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;", "authentication_results"=>"mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com", "user_agent"=>"Postbox 3.0.2 (Macintosh/20111203)"}
  Rails.logger.info params[:headers][:subject] #=> "Test Subject"
  Rails.logger.info params[:headers][:to] #=> "to@example.com"
  Rails.logger.info params[:headers][:from] #=> "from@example.com"
  Rails.logger.info params[:headers][:received] #=> ["by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"]
  Rails.logger.info params[:headers]['Received'][0] #=> "by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800"
  Rails.logger.info params[:headers][:return_path] #=> "from@example.com"
end
```
```php
<?php
  $subject = $_POST['headers']['subject'];
  $to = $_POST['headers']['to'];
  $from = $_POST['headers']['from'];
  $received = $_POST['headers']['received'];
  $return_path = $_POST['headers']['return_path'];
?>
```
```javascript
parsedBody = JSON.parse(request.body)
console.log(fields.headers.subject)
console.log(fields.headers.to)
console.log(fields.headers.from)
console.log(fields.headers.received)
console.log(fields.headers.return_path)
```

## Body

CloudMailin will send the message body in both plain and html formats if they're available. It's always worth using the other parameter as a fallback. If `html` if unavailable then `plain` should always contain the message content. The message body should be encoded into `utf-8` format.

```raw
"plain": "Test with HTML.",
"html": "<html><head>\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\n bgcolor=\"#FFFFFF\" text=\"#000000\">\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\n</body>\n</html>"
"reply_plain": "Message reply if found."
```
```ruby
  def create
    Rails.logger.info params[:plain] #=> "Test with HTML."
    Rails.logger.info params[:html] #=> "<html><head>\r\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\r\n bgcolor=\"#FFFFFF\" text=\"#000000\">\r\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\r\n</body>\r\n</html>"
    Rails.logger.info params[:reply_plain] #=> "Message reply if found."
  end
```
```php
<?php
  $plain = $_POST['plain'];
  $html = $_POST['html'];
  $reply = $_POST['reply_plain'];
?>
```
```javascript
parsedBody = JSON.parse(request.body)
console.log(parsedBody.plain)
console.log(parsedBody.html)
console.log(parsedBody.reply_plain)
```

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

```raw
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
```
```ruby
  def create
    Rails.logger.info params[:attachments] #=> [{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"},{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"}]
    Rails.logger.info params[:attachments].first #=> {"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"}
    Rails.logger.info params[:attachments][0][:url] => "http://example.com/file.txt"
  end
```
```php
<?php
  $attachment = $_POST['attachments'][0];
  $name = $_POST['attachments'][0]['file_name'];
  $url = $_POST['attachments'][0]['url'];
?>
```
```javascript
parsedBody = JSON.parse(request.body)
console.log(parsedBody.attachments[0])
console.log(parsedBody.attachments[0]['file_name'])
console.log(parsedBody.attachments[0]['url'])
```

CloudMailin will upload attachments using a random filename generated by our system.
For more details relating to attachment stores see [attachment store](/receiving_email/attachments/).

### Embedded Attachments

Embedded attachments are attachments that send the attachment content direct to your email server.
We don't recommend that large attachments are sent in this way as they can cause a lot of overhead
for your server. The following is an attachments parameter containing embedded attachments:

```raw
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
```
```ruby
  def create
    Rails.logger.info params[:attachments] #=> [{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","content"=>"dGVzdGZpbGU="},{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","content"=>"dGVzdGZpbGU="}]
    Rails.logger.info params[:attachments].first #=> {"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","content"=>"dGVzdGZpbGU="}
    raw_content = params[:attachments][0]['content'] => "http://example.com/file.txt"
    Rails.logger.info Base64.decode64(raw_content)
  end
```
```php
<?php
  $attachment = $_POST['attachments'][0];
  $name = $_POST['attachments'][0]['file_name'];
  $content = $_POST['attachments'][0]['content'];
  $decoded_content = base64_decode($content)
?>
```
```javascript
parsedBody = JSON.parse(request.body)
console.log(parsedBody.attachments[0])
console.log(parsedBody.attachments[0]['file_name'])
console.log(new Buffer(parsedBody.attachments[0]['url'], 'base64').toString('utf-8'))
})
```

Embedded attachments are sent using `base-64` encoding. The example above contains two attachments named file1.txt and file2.txt both containing the plain text 'testfile' as their content.
