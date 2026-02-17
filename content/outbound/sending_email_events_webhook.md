---
title: Outbound Email Event Webhook
description:
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
| rate_limit        | You've sent more emails than your domain allows. The message will be sent once your account has allowance again.
| delivery          | The email was delivered to the recipient's server.
| bounce            | The email bounced. You should take action when receiving this event. Accounts with a [high number of bounces] will be suspended.
| soft_bounce       | The email was temporarily unable to be delivered. The message will retry a number of times.
| dispatch_soft_bounce | A temporary delivery issue occurred at the dispatch stage. The message will be retried.
| error             | An error occurred during message processing. [Contact us] if this persists.
| retries_exhausted | The email was retried but ultimately could not be delivered. You should investigate this and take action if possible.
| open              | The email was opened. See [Email Health](/outbound/email-health/#open-tracking) for details.
| read              | The email was read by the recipient for a meaningful duration — a more reliable signal than `open`.
| click             | A link in the email was clicked. See [Email Health](/outbound/email-health/#click-tracking) for details.
| auto_reply        | An automatic reply was received from the recipient (e.g. an out-of-office response).
| bounce_reply      | Someone replied to the bounce (return-path) address rather than the sender address.
| suppressed        | Sending was not attempted. This can occur when a recipient has previously bounced, when a message is flagged by our content checks, or when a domain is unverified. See [Email Health](/outbound/email-health/) for details.

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

