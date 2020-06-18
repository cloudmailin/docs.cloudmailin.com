---
title: Getting started with CloudMailin Outbound (Beta)
---

# Sending with CloudMailin Outbound (Beta)

<div class="info">
  This contains information about an un-released beta. Please keep all information confidential and
  be aware that changes may be made during the beta period.
</div>

## Welcome to the beta

If you're reading this then, firstly, thank you! We're really excited to be
sharing this with you. As always any feedback at all is greatly appreciated just
[contact us](http://www.cloudmailin.com/contact_us).

## Transactional email

The CloudMailin outbound system only allows you to send transactional messages. Marketing or bulk
messages are not permitted. If you're not quite sure here are some examples of transactional
message types:

  * Welcome Messages
  * Password Reset
  * Receipts / Invoices
  * Comment Notifications or Replies

Daily, Weekly or Monthly Digests and updates sit in a bit of a grey area. At present we are
permitting this type of message. However, they'll need to be marked as `digest` messages. See
[Queues / Priority](#queues---priority).

<div class="warning">
<strong>Marketing, Newsletters, Announcements or any other bulk mail are not permitted</strong>
at present.
If you have any questions please <a href="http://www.cloudmailin.com/contact_us">contact us</a>
and we can help to clarify things.
</div>

## Limitations

During the beta there are a few limitations and processes we ask that you follow:

| Title        | Description |
|--------------|-------------|
| Recipients   | Messages are currently limited to a maximum of `20 recipients`. |
| Message Size | The maximum message size (unless otherwise agreed) is `10 MB` this should include all message content and encoding. |
| Attachments  | Attachments are limited to safe formats. We do not allow executables or those often associated with viruses. Although not exhaustive the following attachments are **not permitted** ` vbs, exe, bin, bat, chm, com, hta, pif, reg, vbe, vba, msc, msi`.
| SPAM         | We will run automated SPAM checks against messages. Those with a high score will be rejected. |
| Max Volumes  | We will help you to automatically ramp up sending volumes, starting small and growing the number of emails you can send per day. Please [contact us](http://www.cloudmailin.com/contact_us) if you have any questions about this. |
| Bounce Rate  | Bounces and supressions will be monitored. Because we're sending transactional email we don't expect this rate to rise above `2%`. We can help you to ensure this is successful. |

Please [contact us](http://www.cloudmailin.com/contact_us) if we need to work with you on any of
these limitations.

## Getting Setup

When you register we'll discuss your needs and what we need from you to get started sending.
This will mainly consist of:

  1. [Creating DNS records](#dns-records)
  2. [Setting your SMTP server access credentials](#smtp-settings)
  3. [Setting Queue Priorities](#queues---priority)
  4. [Monitoring Bounces (highly recommended)](#monitoring-bounces)
  5. [Setting message tags (optional)](#message-tags)

<br/>

### DNS Records

We currently require DNS records for SPF, DKIM and to handle bounces. This can all be set using two
records.

Normally we will ask to send on a subdomain of your primary domain. For example if your domain is
`example.com` then we will send from `mta.example.com`.

The SMTP conversation will send the message from `bounces+12345@mta.example.com` whilst the
message headers remain as `user@example.com`.

We need to set the following DNS records (these are just examples):

| Record | Example                        | Description                                           |
|--------|--------------------------------|-------------------------------------------------------|
| CNAME  | `mta.example.com`              | A CNAME used to set MX servers for bounces and SPF    |
| TXT    | `1234._domainkeys.example.com` | The DKIM record placed on the root example.com domain.|

Details for your domain specifically cen be found on the domain's
[detail page](https://www.cloudmailin.com/beacon/domains/).

### SMTP Settings

SMTP settings will be available from within the dashboard of your account. Currently we require
TLS to allow our self issued certificates. This might require VERIFY_PEER to be turned off in
OpenSSL.

The SMTP transaction will reply with the message-id of the message to use for bounce tracking if
required.

```
250 Thanks! Queued as: f78b876d-dd97-4e10-9a61-067f98044cc7
```

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
### Monitoring Bounces

Our system will track bounces and non-delivery-reports from mail servers. These events will be
sent to you via Webhook. The payload will be a JSON HTTP request with the following format:

```JSON
{
  "events": [
    {
      "kind": "bounce",
      "recipient": "user@example.net",
      "message_id": "f78b876d-dd97-4e10-9a61-067f98044cc7",
      "details": {}
    }
  ]
}
```

**Please note:** The list of events is an array. In multiple events may be sent in one HTTP POST.

The list of fields currently POSTed for each entry is as follows:

| Field         | Description                                           |
|---------------|-------------------------------------------------------|
| `kind`        | The type of event raised. This is one of `delivery`, `bounce`, `soft_bounce`, `open`, `click`, `complaint`, `blocked`. |
| `recipient`   | The recipient of the message.                         |
| `message_id`  | The message ID as returned by the SMTP transaction.   |
| `details`     | Additional details if present related to the event.   |

These fields will be expended with additional details over time.

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

## Getting Help
If you have any questions at all please contact our support team using our
[contact us](http://www.cloudmailin.com/contact_us) page.
