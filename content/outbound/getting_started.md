---
title: Getting Setup Sending Email with CloudMailin Outbound
---

# Getting Started Sending Email

> Remember CloudMailin Outbound is only for
[Transactional email](/outbound/)
More information can be found in the [outbound email introduction](/outbound/).

This will mainly consist of:

  1. [Creating DNS records](#dns-records)
  2. [Setting your SMTP server access credentials](#smtp-settings)
  4. [Monitoring Bounces (highly recommended)](#monitoring-bounces)
  3. [Setting Queue Priorities (optional)](/outbound/priorities_and_tags/#queues-priority)
  5. [Setting message tags (optional)](/outbound/priorities_and_tags/#message-tags)

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
[detail page](https://www.cloudmailin.com/outbound/domains/).

### SMTP Settings

SMTP settings will be available from within the dashboard of your account.

Before you can send email we require SMTP Autentication. You'll need to provide a username and
password via `LOGIN` or `PLAIN` auth. In order for this to be secure we only accept SMTP Auth once
an encrptyed session has been established via the `STARTTLS` command.

The SMTP transaction will reply with the message-id of the message to use for bounce tracking if
required.

```
250 Thanks! Queued as: f78b876d-dd97-4e10-9a61-067f98044cc7
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
