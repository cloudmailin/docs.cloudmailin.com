---
title: Sending Email with SMTP
description: CloudMailin's SMTP settings for sending email
image: out
---

# Sending Email with SMTP

The CloudMailin SMTP system allows you to use SMTP to send transactional email.
When sending email with SMTP you can still benefit from our queues and priority, our tagging and
all of our analytics systems.

Often web frameworks and applications have systems embedded to allow sending email over SMTP.
Using SMTP also allows a simple configuration change to move providers in most cases.

We recommend sending both Plain and HTML email parts when sending your transactional emails.
Once you've setup a domain to start sending you'll need an
[outbound account] to get your SMTP connection details:

| Field    | Value      | Details                                                              |
|----------|------------|----------------------------------------------------------------------|
| Host     | `provided` | Your SMTP host will be provided on your [account page].
| Port     | `587` (recommended), `2525`, `25` | We accept mail on multiple ports. In case one is blocked by your host try a different port.
| STARTTLS | `required` | Start TLS must be used to begin a encrypted session before we will allow authentication to take place.
| Auth     | `login`, `plain` | We require `login` or `plain` auth once an encrypted sesssion has been established.
| Username | `provided` | Your [account page] will show your username.
| Password | `provided` | Your [account page] will show your password.

Once you've sent a message the SMTP transaction will reply with the message-id of the message
to use for bounce tracking if required.

    250 Thanks! Queued as: f78b876d-dd97-4e10-9a61-067f98044cc7

### Queues, Priorities and Tagging Support

Using SMTP you can add additional headers to your emails to help control things like the queue
we use to send the email and tags to allow analysis/filtering in the dashboard. More infromation
about setting these can be found in the
<%= link_to_item('/outbound/priorities_and_tags/') %> documentation.

## Examples:

There are a number examples below for specific languages and frameworks to get started sending
email over SMTP:

<!-- This strange layout is to handle the weird ERB issue with - -->
<% items_for_section('outbound/examples').each do |item| %>
  * <%= link_to_item(item) %><% end %>


[account page]: https://www.cloudmailin.com/outbound/accounts
