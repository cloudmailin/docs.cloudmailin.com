---
title: Email Health & Deliverability
description: How CloudMailin monitors outbound email health including spam checking, engagement tracking, bounce monitoring and health scores to maximise deliverability.
image: out
---

# Email Health & Deliverability

CloudMailin monitors the health of your outbound email to maximise deliverability and protect
your sending reputation. Every outbound message passes through a series of checks before it
leaves our servers — because if the receiving mail server is going to check, it's better to
catch problems before they affect your reputation.

This page explains what we monitor, why, and how you can maintain a healthy sending account.

## Why Email Health Matters

Email providers like Gmail, Outlook and Yahoo continuously evaluate sender reputation. They
look at signals like bounce rates, spam complaints and engagement (opens, clicks) to decide
whether your emails reach the inbox or land in the junk folder.

A single sender with poor practices can damage the reputation of the shared sending
infrastructure, affecting deliverability for everyone. CloudMailin's health system is designed
to catch problems early — both to protect your deliverability and to maintain the reputation
of the platform as a whole.

## Health Scores

Every outbound account has a health score between 0 and 100, visible in your dashboard. The
score is calculated from a combination of factors including delivery rates, bounce rates,
spam complaints and engagement metrics.

| Score Range | Status  | Meaning |
|-------------|---------|---------|
| 90–100      | Healthy | Your email is performing well. |
| 75–89       | Warning | Some metrics need attention. You'll receive a notification. |
| Below 75    | Danger  | Significant issues that need addressing urgently. |
| Below 50    | Critical | Sending may be suspended until issues are resolved. |

Health scores are recalculated regularly. If your score drops, you'll receive an email
notification with specific guidance on what to improve.

## What We Monitor

### Spam & Content Checking

All outbound messages are scanned for spam characteristics before sending. Messages that
score above our threshold are rejected and you'll receive a `suppressed`
[webhook event](/outbound/sending_email_events_webhook/).

This is the same kind of content analysis that receiving mail servers perform. By catching
it first, we prevent your messages from being silently filtered or penalised by the
recipient's mail provider. If we allowed high-scoring messages through, it would damage the
sending reputation of the IP addresses used by all CloudMailin customers.

<div class="warning">
Spam checking cannot be disabled. If you believe a message was incorrectly flagged, please
<a href="https://www.cloudmailin.com/contact_us">contact us</a> and we can investigate.
</div>

### Bounce Rate

Hard bounces (permanent delivery failures) are tracked against your sending volume. ISPs
treat high bounce rates as a strong signal that a sender isn't maintaining clean recipient
lists — which is a hallmark of spammers.

Because CloudMailin is for [transactional email](/outbound/) sent to known, valid recipients,
bounce rates should naturally be very low. We expect rates to stay below 2%. Persistent high
bounce rates will affect your health score and may lead to account suspension.

You should monitor bounce [webhook events](/outbound/sending_email_events_webhook/) and take
action promptly — for example, by removing addresses that repeatedly bounce.

### Spam Complaints

When a recipient marks your email as spam, CloudMailin is notified. Even very small complaint
rates are serious — ISPs weight complaints heavily when evaluating sender reputation.

CloudMailin monitors complaint rates and will alert you if they rise above acceptable levels.
High complaint rates will significantly impact your health score.

### Open Tracking

CloudMailin adds a small tracking pixel to HTML emails to detect when they are opened. This
serves two purposes:

1. **Deliverability signal** — open rates tell us whether your emails are actually reaching
   inboxes. A sudden drop in opens can indicate that emails are being filtered to junk.
2. **Engagement data** — you receive `open`
   [webhook events](/outbound/sending_email_events_webhook/) so you can monitor engagement
   with your emails.

Open tracking only works with HTML emails and depends on the recipient's email client loading
images, so it's not 100% accurate — but it's a useful indicator of overall trends.

Open tracking is enabled by default. See [Disabling Tracking](#disabling-open--click-tracking)
below if you need to turn it off.

### Click Tracking

Links in HTML emails are rewritten to pass through a redirect that logs the click before
sending the recipient to the original destination URL. The original URL is preserved and the
redirect happens transparently.

Click tracking provides engagement data that both you and CloudMailin use to assess email
health:

1. **Engagement signal** — click-through rates indicate that recipients find your content
   relevant and are interacting with it. ISPs increasingly factor engagement into their
   filtering decisions.
2. **Webhook events** — you receive `click`
   [webhook events](/outbound/sending_email_events_webhook/) including which link was clicked.

Click tracking is enabled by default. See [Disabling Tracking](#disabling-open--click-tracking)
below if you need to turn it off.

## Disabling Open & Click Tracking

You can request to disable open tracking, click tracking, or both by
[contacting support](https://www.cloudmailin.com/contact_us). Before doing so, be aware of
the trade-offs:

- You will no longer receive `open` and/or `click`
  [webhook events](/outbound/sending_email_events_webhook/).
- Your health score will no longer include engagement metrics — those checks are skipped
  when tracking is disabled.
- CloudMailin won't be able to proactively warn you about deliverability issues related to
  low engagement.

Spam checking and bounce monitoring cannot be disabled — these protect the shared sending
infrastructure and are essential for maintaining deliverability across the platform.

## Tips for Maintaining a Healthy Account

- **Send to valid recipients only** — transactional email should go to addresses you know
  can receive mail. Avoid sending to unverified or purchased lists.
- **Monitor and act on bounces** — set up a
  [webhook endpoint](/outbound/sending_email_events_webhook/) and handle bounce events
  promptly.
- **Keep content clean and well-formatted** — use proper HTML, avoid excessive links or
  image-heavy layouts, and include a plain text alternative where possible.
- **Set up DMARC** — SPF and DKIM are configured as part of
  [getting started](/outbound/getting_started/#dns-records), but adding a
  [DMARC policy](/outbound/dmarc/) further improves deliverability.
- **Only send transactional email** — CloudMailin is for transactional messages only.
  Marketing, newsletters and bulk mail are not permitted. See the
  [outbound introduction](/outbound/#transactional-email) for details.
- **Check your health score** — review your dashboard regularly and address any warnings
  before they escalate.

## More Help

If you have questions about your health score or deliverability, please
[contact us](https://www.cloudmailin.com/contact_us) and we'll be happy to help.
