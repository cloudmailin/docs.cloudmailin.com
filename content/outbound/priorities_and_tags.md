---
title: Setting SMTP queue priority and Tagging
description : Setting SMTP Queue Priority and Tagging on your CloudMailin Outbound Emails
image: out
---

# Setting SMTP Queue Priority and Tagging

CloudMailin allows you to select which queue you send your email to. This allows you to priorities messages like password resets whilst lowering the priority of things like Digest Emails.

> Remember, digest emails such as updates or weekly/monthly summaries must use the digest queue.
> This enables us to prioritise emails such as password resets.

### Queues / Priority

During the beta we will have 3 different message queues:

| Queue      | Description |
|------------|-------------|
| `standard` | This is the default queue, it will be set if no header is set. |
| `priority` | This is only to be used for messages that require immediate user response, such as password reset emails. Messages in this queue will skip to the front of all queues and be sent as soon  as possible. **Please don't use this queue for all messages**. |
| `digest`   | This queue **must** be used for messages that are not time sensitive and any notifications, updates or digests. This queue will spread message delivery as required and will help spread messages to aid inbox placement for this type of message. |

In order to select the queue please use the `x-cloudmta-class` header:

```
from: user@example.com
to: user@example.net
subject: Daily Update
x-cloudmta-class: digest

This is the digest content
```

### Message Tags

Message tags help you to break down your message analytics in the dashboard. You can use the
`x-cloudmta-tags` header to add tags to your message.

```
from: user@example.com
to: user@example.net
subject: Password Reset
x-cloudmta-tags: password-reset, account

Please click the following link to reset your password...
```
