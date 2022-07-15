---
title: Outbound Email Event Webhook
description: |
  When you send email with CloudMailin you can opt to receive status events via Webhook.
  This is different to the Webhook received when CloudMailin actually receives email.
image: out
---

# CloudMailin Email Sending Event Webhook

When you send email with CloudMailin you can opt to receive status events via
Webhook. This is different to the Webhook received when CloudMailin actually
receives email. If you're looking for our inbound email to webhook, head to our
[Incoming Email Webhook](/getting_started/).

## CloudMailin email delivery events

The list of possible events during email delivery is as follows:

| Event             | Description   |
|-------------------|---------------|
| registration      | We've received your email and are preparing it to deliver to the recipient.
| dispatch          | Your email has been processed and dispatched to the outbound sending server.
| rate_limited      | You've sent more emails than your domain allows. The message will be sent once your account has allowance again.
| delivery          | The email was delivered to the recipient's server.
| bounce            | The email bounced. You should take action when receiving this event. Accounts with a [high number of bounces] will be suspended
| soft_bounce       | The email was temporarily unable to be delivered. The message will retry a number of times.
| retries_exhausted | The email was retried but ultimately could not be delivered. You should investigate this and take action if possible.
| open              | The email was opened.
| click             | A link in the email was clicked.
| blocked           | Sending was blocked due to previous bounces. This is called supressed in our interface.
| spamd             | Sending the email was not attempted because the message appears as SPAM to SpamAssassin. [Contact us] if you think this is an error.

[high number of bounces]: /outbound/#limitations

```json
{
  "events": [
    {
      "kind": "registration",
      "recipient": "debug@smtp",
      "message_id": "b47c8008-84af-47aa-b39a-b0a3f358a0ee"
    }
  ]
}
```



<!--
registration: 0,
dispatch: 1,
rate_limit: 3,
dispatch_bounce: 5,
dispatch_soft_bounce: 6,
delivery: 10,
bounce: 11,
soft_bounce: 12,
open: 20,
click: 21,
read: 22,
complaint: 30,
retries_exhausted: 40,
blocked: 50,
auto_reply: 60,
process: 1000,
spamd: 1001
-->
