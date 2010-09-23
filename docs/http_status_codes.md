HTTP Status Codes
=

Depending on the status code we receive from your app when we send you the HTTP POST several things can happen.

### If we cannot reach your server
If we can't reach your server. We will tell the user's mail server that there has been a temporary problem so try again later. This will be shown as 000 in the delivery status pages.

### 200
If you give us an http status of *200* - Everything is good we will tell the mail server the message has been delivered

### 403, 404 or 422
If you give us an http status of *403, 404 or 422* - The message will be rejected and the sender will be notified of this problem.

### 500
If you give us an http status of *500* - we will tell the mail server to try again later.

### Anything else
Any other status and we will also tell the mail server to try again later.

## Custom Error Messages
You can send a custom error message when you reject a message by making sure the content type of your response is set to _text/plain_. This text will then be sent as part of the error message given by the server.