---
title: Receiving Email with Node.js
skip_erb: true
---

# Receiving Email with Node.js

<div class="warning">This example may be outdated. You can now find examples for newer POST formats within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

## Express

Node.js will automatically parse JSON and provide you with an object to work with. If you need to access 'multipart/form-data' content (for the original format) in Node.js you can use the [node-formidable](https://github.com/felixge/node-formidable) module.

The following is a really simple express app that parses the multipart content using node-formidable and outputs the to, from and subject to the console.

    var express = require('express');

    var app = module.exports = express.createServer()
      , formidable = require('formidable')

    app.post('/incoming_mail', function(req, res){
      var form = new formidable.IncomingForm()
      form.parse(req, function(err, fields, files) {
        console.log(fields.to)
        console.log(fields.from)
        console.log(fields.subject)
        res.writeHead(200, {'content-type': 'text/plain'})
        res.end('Message Received. Thanks!\r\n')
      })
    })

    app.listen(8080);
    
The following [gist](https://gist.github.com/1495479) (by [jafstar](https://github.com/jafstar)) may also be of help when dealing with errors from Node.js applications and presenting the correct parameters.