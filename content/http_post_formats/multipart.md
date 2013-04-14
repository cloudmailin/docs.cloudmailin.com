---
title: Multipart Form Data Hash Format
---

# Multipart/form-data Hash Email Message Format

The JSON and multipart formats are incredibly similar. It's only the transport method that differs. The format consists of four main elements, `envelope`, `headers`, `body` and `attachments`. The `body` consists of two parameters `plain` and `html`.

| parameter     | details                 | description                                                                   |
|---------------|-------------------------|-------------------------------------------------------------------------------|
| `envelope`    | [details](#envelope)    | This is the message envelope. The details that our server receives from the sending server.   |
| `headers`     | [details](#headers)     | These are the email headers they use the notation headers[field_name] to represent the array. |
| `plain`       | [details](#body)        | The email body as plain-text.                                                 |
| `html`        | [details](#body)        | The email as HTML (if a HTML version is available).                           |
| `reply_plain` | [details](#body)        | The plain text reply extracted from this message is present / found.          |
| `attachments` | [details](#attachments) | The message attachments.                                                      |

The following is complete example Multipart message:

```raw
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
```
```language-ruby
class IncomingMailsController < ApplicationController
  def create
    Rails.logger.info params
    message = Message.new(
      :to => params[:envelope][:to],
      :from => params[:envelope][:from],
      :subject => params[:headers]['Subject'],
      :body => params[:plain]
    )
    if message.save
      render :text => 'Success', :status => 200
    else
      render :text => message.errors.full_messages, :status => 422, :content_type => Mime::TEXT.to_s
    end
  end
end

#=> {"plain"=>"Test with HTML.", "html"=>"<html><head>\r\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\r\n bgcolor=\"#FFFFFF\" text=\"#000000\">\r\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\r\n</body>\r\n</html>", "reply_plain"=>"Message reply if found.", "headers"=>{"Return-Path"=>"from@example.com", "Received"=>{"0"=>"by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "1"=>"by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "2"=>"from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"}, "Date"=>"Mon, 16 Jan 2012 17:00:01 +0000", "From"=>"Message Sender <sender@example.com>", "To"=>"Message Recipient <to@example.com>", "Message-ID"=>"<4F145791.8040802@example.com>", "Subject"=>"Test Subject", "Mime-Version"=>"1.0", "Delivered-To"=>"to@example.com", "Received-SPF"=>"neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;", "Authentication-Results"=>"mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com", "User-Agent"=>"Postbox 3.0.2 (Macintosh/20111203)"}, "envelope"=>{"to"=>"to@example.com", "recipients"=>{"0"=>"to@example.com"}, "from"=>"from@example.com", "helo_domain"=>"localhost", "remote_ip"=>"127.0.0.1", "spf"=>{"result"=>"pass", "domain"=>"example.com"}}, "attachments"=>{"0"=>#<ActionDispatch::Http::UploadedFile:0x007f9bef0aed98 @original_filename="file1.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"attachments[0]\"; filename=\"file1.txt\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/sq/lggbm81j6zdgp8xz9c69wwr80000gn/T/RackMultipart20130409-6298-120trfe>>, "1"=>#<ActionDispatch::Http::UploadedFile:0x007f9bef0aecd0 @original_filename="file2.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"attachments[1]\"; filename=\"file2.txt\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/sq/lggbm81j6zdgp8xz9c69wwr80000gn/T/RackMultipart20130409-6298-hbuu4r>>}}
```
```language-php
<?php
  header("Content-type: text/plain");

  $to = $_POST['envelope']['to'];
  $subject = $_POST['headers']['Subject'];
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
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.from)
    console.log(fields.headers['Subject'])
    console.log(fields.plain)
    console.log(fields.html)
    console.log(fields.reply_plain)
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String from = Request.Form["envelope"]["from"];
  String subject = Request.Form["headers"]["Subject"]; // Note the titlecase Subject. Header names are as passed.
  String plain = Request.Form["plain"];
  String html = Request.Form["html"];
  String reply = Request.Form["reply_plain"];
}
```

## Envelope

The envelope contains the data sent or gathered from the remote server. It doesn't contain any of the message content. It contains details of the transaction that took place between the sending server and CloudMailin.

| field         | Details                                                                             |
|---------------|-------------------------------------------------------------------------------------|
| `to`          | The email address the server is sending to. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter.                                               |
| `recipients`  | The full list of recipients that the remote server is attempting to send to in this transaction. For more details see [multiple_recipients](/receiving_email/multiple_recipients/).                                          |
| `from`        | The email address that the server was sending from. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter.                                          |
| `helo_domain` | The domain reported by the sending server as it sends the `helo` or `ehlo` command. |
| `remote_ip`   | The remote IP address of the sending server if available.                           |
| `spf`         | The [SPF](/features/spf/) result for the given IP address and Domain.               |

The following is an example envelope:

```raw
------cloudmailinboundry
Content-Disposition: form-data; name="envelope[to]"

to@example.com
------cloudmailinboundry
Content-Disposition: form-data; name="envelope[recipients][0]"

to@example.com
Content-Disposition: form-data; name="envelope[recipients][1]"

another@example.com
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
```
```language-ruby
  def create
    Rails.logger.info params[:envelope][:to] #=> "to@example.com"
    Rails.logger.info params[:envelope][:recipients] #=> {"0"=>"to@example.com","1"=>"another@example.com"}
    Rails.logger.info params[:envelope][:recipients]['0'] #=> "to@example.com"
    Rails.logger.info params[:envelope][:recipients].values #=> ["to@example.com"]
    Rails.logger.info params[:envelope][:from] #=> "from@example.com"
    Rails.logger.info params[:envelope][:helo_domain] #=> "from@example.com"
    Rails.logger.info params[:envelope][:remote_ip] #=> "127.0.0.1"
    Rails.logger.info params[:envelope][:spf] #=> {"result"=>"pass", "domain"=>"example.com"}
  end
```
```language-php
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
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.envelope.to)
    console.log(fields.envelope.from)
    console.log(fields.envelope.recipients)
    console.log(fields.helo_domain)
    console.log(fields.remote_ip)
    console.log(fields.spf.domain)
    console.log(fields.spf.result)
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String to = Request.Form["envelope"]["to"];
  String from = Request.Form["envelope"]["from"];
  String recipients = Request.Form["envelope"]["recipients"];
  String helo_domain = Request.Form["envelope"]["helo_domain"];
  String remote_ip = Request.Form["envelope"]["remote_ip"];
  String spf_domain = Request.Form["envelope"]["spf"]["domain"];
  String spf_result = Request.Form["envelope"]["spf"]["result"];
}
```

## Headers

The headers parameter contains all of the message headers extracted from the email. Headers occurring multiple times (such as the `received` header) will send the value as an array if there are multiple occurrences or as a string if the header only occurs once.

The following is an example message header:

```raw
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
```
```language-ruby
def create
  Rails.logger.info params[:headers] #=> "headers"=>{"Return-Path"=>"from@example.com", "Received"=>{"0"=>"by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "1"=>"by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "2"=>"from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"}, "Date"=>"Mon, 16 Jan 2012 17:00:01 +0000", "From"=>"Message Sender <sender@example.com>", "To"=>"Message Recipient <to@example.com>", "Message-ID"=>"<4F145791.8040802@example.com>", "Subject"=>"Test Subject", "Mime-Version"=>"1.0", "Delivered-To"=>"to@example.com", "Received-SPF"=>"neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) client-ip=10.0.10.1;", "Authentication-Results"=>"mx.google.com; spf=neutral (google.com: 10.0.10.1 is neither permitted nor denied by best guess record for domain of from@example.com) smtp.mail=from@example.com", "User-Agent"=>"Postbox 3.0.2 (Macintosh/20111203)"}
  Rails.logger.info params[:headers]['Subject'] #=> "Test Subject"
  Rails.logger.info params[:headers]['To'] #=> "to@example.com"
  Rails.logger.info params[:headers]['From'] #=> "from@example.com"
  Rails.logger.info params[:headers]['Received'] #=> {"0"=>"by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800", "1"=>"by 10.216.131.153 with SMTP id m25mr5479776wei.9.1326733205283; Mon, 16 Jan 2012 09:00:05 -0800", "2"=>"from mail-wi0-f170.google.com (mail-wi0-f170.google.com [209.85.212.170]) by mx.google.com with ESMTPS id u74si9614172weq.62.2012.01.16.09.00.04 (version=TLSv1/SSLv3 cipher=OTHER); Mon, 16 Jan 2012 09:00:04 -0800"}
  Rails.logger.info params[:headers]['Received']['0'] #=> "by 10.52.90.229 with SMTP id bz5cs75582vdb; Mon, 16 Jan 2012 09:00:07 -0800"
  Rails.logger.info params[:headers]['Return-Path'] #=> "from@example.com"
end
```
```language-php
<?php
  $subject = $_POST['headers']['Subject'];
  $to = $_POST['headers']['To'];
  $from = $_POST['headers']['From'];
  $received = $_POST['headers']['Received'];
  $return_path = $_POST['headers']['Return-Path'];
?>
```
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.headers['Subject'])
    console.log(fields.headers['To'])
    console.log(fields.headers['From'])
    console.log(fields.headers['Received'])
    console.log(fields.headers['Return-Path'])
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String recipients = Request.Form["envelope"]["Subject"];
  String to = Request.Form["headers"]["To"];
  String from = Request.Form["headers"]["From"];
  String received = Request.Form["envelope"]["Received"];
  String return = Request.Form["envelope"]["Return-Path"];
}
```

## Body

CloudMailin will send the message body in both plain and html formats if they're available. It's always worth using the other parameter as a fallback. If `html` if unavailable then `plain` should always contain the message content. The message body should be encoded into `utf-8` format.

```raw
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
```
```language-ruby
  def create
    Rails.logger.info params[:plain] #=> "Test with HTML."
    Rails.logger.info params[:html] #=> "<html><head>\r\n<meta http-equiv=\"content-type\" content=\"text/html; charset=ISO-8859-1\"></head><body\r\n bgcolor=\"#FFFFFF\" text=\"#000000\">\r\nTest with <span style=\"font-weight: bold;\">HTML</span>.<br>\r\n</body>\r\n</html>"
    Rails.logger.info params[:reply_plain] #=> "Message reply if found."
  end
```
```language-php
<?php
  $plain = $_POST['plain'];
  $html = $_POST['html'];
  $reply = $_POST['reply_plain'];
?>
```
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.plain)
    console.log(fields.html)
    console.log(fields.reply_plain)
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String plain = Request.Form["plain"];
  String html = Request.Form["html"];
  String reply = Request.Form["reply_plain"];
}
```

For more details about the extracted reply see [reply parsing](/features/extracting_replies_from_email/).

## Attachments

Attachments in the new message formats come in three different forms:

| Attachment Type       | Description                                                                                         |
|-----------------------|-----------------------------------------------------------------------------------------------------|
| No Attachments        | If there are no attachments the attachments parameter will not be present for the multipart format. |
| URL Attachments       | URL Attachments are attachments that have been sent to an [attachment store](/receiving_email/attachments/). In these cases the message content is stored remotely and a URL to the attachment plus the attachment details are provided.            |
| Embedded Attachments  | Attachments will be sent as multipart/form-data attachments. No decoding should be required and some frameworks will automatically create temporary files for these attachements                                                                   |

### URL Attachments

URL based attachments will contain the following parameters:

| Field           | Description                                                                                          |
|-----------------|------------------------------------------------------------------------------------------------------|
| `url`           | A URL to the attachment if the attachment is within an attachment store.                             |
| `file_name`     | The original file name of the attachment.                                                            |
| `content_type`  | The content type of the attachment.                                                                  |
| `size`          | The size of the attachment.                                                                          |
| `disposition`   | The disposition of the attachment either `attachment` or `inline`                                    |

URL attachments are attachments that have been sent to a message store. Instead of content they will contain a link to allow you to retrieve that content. URL attachments will be formatted as an array of attachment details. The following is an attachments parameter containing URL attachments:

```raw
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
```
```language-ruby
  def create
    Rails.logger.info params[:attachments] #=> {"0"=>{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"},"1"=>{"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"}}
    Rails.logger.info params[:attachments]['0'] #=> {"file_name"=>"file.txt","content_type"=>"text/plain","size"=>8,"disposition"=>"attachment","url"=>"http://example.com/file.txt"}
    Rails.logger.info params[:attachments]['0']['url'] => "http://example.com/file.txt"
  end
```
```language-php
<?php
  $attachment = $_POST['attachments']['0'];
  $name = $_POST['attachments']['0']['file_name'];
  $url = $_POST['attachments']['0']['url'];
?>
```
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.attachments['0'])
    console.log(fields.attachments['0']['file_name'])
    console.log(fields.attachments['0']['url'])
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String attachment = Request.Form["attachments"]["0"];
  String name = Request.Form["attachments"]["0"]["file_name"];
  String name = Request.Form["attachments"]["0"]["url"];
}
```

CloudMailin will upload attachments using a random filename generated by our system. For more details relating to attachment stores see [attachment store](/receiving_email/attachments/).

### Embedded Attachments

Embedded attachments are attachments that send the attachment content direct to your email server. The don't recommend that large attachments are sent in this way as they can cause a lot of overhead for your server. The attachments will be send like normal `multipart/form-data` attachments. Many frameworks will automatically extract these attachments and place them into temporary files. The following is an attachments parameter containing embedded attachments:

```raw
------cloudmailinboundry
Content-Disposition: form-data; name="attachments[0]"; filename="file1.txt"
Content-Type: text/plain

testfile
------cloudmailinboundry
Content-Disposition: form-data; name="attachments[1]"; filename="file2.txt"
Content-Type: text/plain

testfile
```
```language-ruby
  # In Rails embeded files are just normal instances of ActionDispatch::Http::UploadedFile

  def create
    Rails.logger.info params[:attachments] #=> {"0"=>#<ActionDispatch::Http::UploadedFile:0x007f9bef0aed98 @original_filename="file1.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"attachments[0]\"; filename=\"file1.txt\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/sq/lggbm81j6zdgp8xz9c69wwr80000gn/T/RackMultipart20130409-6298-120trfe>>, "1"=>#<ActionDispatch::Http::UploadedFile:0x007f9bef0aecd0 @original_filename="file2.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"attachments[1]\"; filename=\"file2.txt\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/sq/lggbm81j6zdgp8xz9c69wwr80000gn/T/RackMultipart20130409-6298-hbuu4r>>}
    Rails.logger.info params[:attachments]['0'] #=> #<ActionDispatch::Http::UploadedFile:0x007f9bef0aed98 @original_filename="file1.txt", @content_type="text/plain", @headers="Content-Disposition: form-data; name=\"attachments[0]\"; filename=\"file1.txt\"\r\nContent-Type: text/plain\r\n", @tempfile=#<Tempfile:/var/folders/sq/lggbm81j6zdgp8xz9c69wwr80000gn/T/RackMultipart20130409-6298-120trfe>>

    params[:attachments].each do |k, attachment|
      Rails.logger.info attachment.read #=> "testfile"
      Rails.logger.info attachment.original_filename #=> "file1.txt"
      Rails.logger.info attachment.content_type #=> "text/plain"
    end
  end
```
```language-php
<?php error_log(var_export($_FILES, true), 3, '/var/tmp/output.log') ?>

outputs:
array (
  'attachments' => 
  array (
    'name' => 
    array (
      0 => 'file1.txt',
    ),
    'type' => 
    array (
      0 => 'text/plain',
    ),
    'tmp_name' => 
    array (
      0 => '/private/var/tmp/phpXCjERD',
    ),
    'error' => 
    array (
      0 => 0,
    ),
    'size' => 
    array (
      0 => 8,
    ),
  )...

<?php error_log(var_export($_FILES['attachments']['name'][0], true), 3, '/var/tmp/output.log') ?>
outputs: 'file1.txt'

```
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(files)
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```

Embedded attachments are sent using binary encoding. The example above contains two attachments named file1.txt and file2.txt both containing the plain text 'testfile' as their content.
