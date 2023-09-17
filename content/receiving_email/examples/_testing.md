### Testing Incoming Email Locally

There are a couple of options for receiving email via HTTP POST locally:

#### Webhook App

If you want to see how a format will look with your own content we recommend using the [WebhookApp]. Simply set the [WebhookApp] as your message url target and then send an email. The message content will then be sent over HTTP to the app using WebSockets so you can view this content and try out the format.

#### Postman

We also have some examples in Postman that you can use to start development before you send your
own mail. The examples include an email message with all the expected attributes and an attachment.

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/93865eabe09f106dacad)

---
