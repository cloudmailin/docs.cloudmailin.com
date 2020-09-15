---
title: Sending Email with CloudMailin Outbound
description: Getting started Sending Transactional Email over SMTP with CloudMailin Outbound.
---

# Sending with CloudMailin Outbound

Our outbound product is newer than our inbound product and is still evolving.
Although it's being used in production  by a number of customers we'd greatly appreciate any
feedback you may have. As always just [contact us] if you have any feedback.

## Getting Started

* To send Outbound Emails with CloudMailin check out the
  [Getting Started Guide](/outbound/getting_started/).
* To read about priories and tags check out the
  [Priorites and Tagging](/outbound/priorities_and_tags/) documentation.
* To get started with SMTP read the <%= link_to_item('/outbound/sending_email_with_smtp/') %>
  documentation.

If you have any questions at all please contact our support team using ou [contact us] page.

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
If you have any questions please <a href="https://www.cloudmailin.com/contact_us">contact us</a>
and we can help to clarify things.
</div>

## Limitations

There are a number of limitations we'd like you to be aware of. If any of these cause an issue
please [contact us].

| Title        | Description |
|--------------|-------------|
| Recipients   | Messages are currently limited to a maximum of `20 recipients`. |
| Message Size | The maximum message size (unless otherwise agreed) is `10 MB` this should include all message content and encoding. |
| Attachments  | Attachments are limited to safe formats. We do not allow executables or those often associated with viruses. Although not exhaustive the following attachments are **not permitted** ` vbs, exe, bin, bat, chm, com, hta, pif, reg, vbe, vba, msc, msi`.
| SPAM         | We will run automated SPAM checks against messages. Those with a high score will be rejected. |
| Max Volumes  | We will help you to automatically ramp up sending volumes, starting small and growing the number of emails you can send per day. Please [contact us] if you have any questions about this. |
| Bounce Rate  | Bounces and supressions will be monitored. Because we're sending transactional email we don't expect this rate to rise above `2%`. We can help you to ensure this is successful. |

Please [contact us] if we need to work with you on any of these limitations.
