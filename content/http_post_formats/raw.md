---
title: Raw Message Format
---

# Raw Message Format

The raw message format sends an entire message as a single field within a `multipart/form-data` POST request. The parameter `message` will contain the entire unparsed email message in addition to the envelope. The Raw format should be considered an advanced format and only used by those that really require the full unaltered message contents.

| Field       | Details                                                                                           |
|-------------|---------------------------------------------------------------------------------------------------|
| `message`   | The entire email as a string. This is unaltered from the format that CloudMailin receives it in.  |
| `envelope`  | This is the message envelope. The details that our server receives from the sending server.       |

## Envelope

The envelope contains the data sent or gathered from the remote server. It doesn't contain any of the message content. It contains details of the transaction that took place between the sending server and CloudMailin. The data sent within the envelope is identical to that in the [multipart format](/http_post_formats/multipart/#envelope).

| Field         | Details                                                                                                              |
|---------------|----------------------------------------------------------------------------------------------------------------------|
| `to`          | The email address the server is sending to. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter.                                                                                |
| `from`        | The email address that the server was sending from. Note this might not always be the address within the message headers. For that reason you should also look at the `headers` parameter. |
| `helo_domain` | The domain reported by the sending server as it sends the `helo` or `ehlo` command.                                  |
| `remote_ip`   | The remote IP address of the sending server if available.                                                            |
| `spf`         | The [SPF](/features/spf/) result for the given IP address and Domain. Passed as `spf['result']` and `spf['domain']`. |

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

## Message Content

The entire email will be sent as as a string. This is unaltered from the format that CloudMailin receives it in.

```raw
------cloudmailinboundry
Content-Disposition: form-data; name="message"

entire message here
------cloudmailinboundry
```
```language-ruby
class IncomingMailsController < ApplicationController
  def create
    # Creates an instance of the Mail class in the mail gem.
    # See https://github.com/mikel/mail/blob/master/lib/mail/mail.rb for details.
    message = Mail.new(params[:message])
    render :text => 'Success', :status => 200
  end
end
```
```language-php
<?php
  $raw = $_POST['message'];
?>
```
```language-javascript
var express = require('express');

var app = module.exports = express.createServer()
  , formidable = require('formidable')

app.post('/incoming_mail', function(req, res){
  var form = new formidable.IncomingForm()
  form.parse(req, function(err, fields, files) {
    console.log(fields.message)
    res.writeHead(200, {'content-type': 'text/plain'})
    res.end('Message Received. Thanks!\r\n')
  })
})

app.listen(8080);
```
```language-c#
void Page_Load(object sender, EventArgs e) {
  String raw = Request.Form["message"];
}
```
