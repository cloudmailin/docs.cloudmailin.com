---
title: Using the CloudMailin Email API
description:
  CloudMailin allows you to receive emails via an HTTP POST request and to
  send emails via a REST API or send emails via SMTP.
  However, CloudMailin also has an admin API allowing you to configure and
  manage your account features.
---

# The CloudMailin management API

CloudMailin allows you to receive emails via an HTTP POST request and to send
emails via a REST API or send emails via SMTP. However, CloudMailin also has an
admin API allowing you to configure and manage your account features.

In most cases you don't need to use the admin API, but it can be useful if you
want to automate the configuration of your account or have a large number of
domains or customers that need to configure domains automatically.

If you just want to:

* [Send Email](/outbound)
* [Receive Email](/getting_started)

> You also don't need the API in order to create email addresses / receive email
> for your domain. You can do this via the
> [CloudMailin dashboard](https://www.cloudmailin.com/dashboard) and use the
> [HTTP status code](/receiving_email/http_status_codes) that you return to
> accept or reject email in real time rather than having to sync your list of
> email addresses / users with CloudMailin ahead of time.

If you need additional features then read on:

## Getting access to the management API

Because most users don't need access to the management API, we don't provide
this access by default. If you need access to the management API then please
[contact us] and we will enable this for you.

We'll also send you a link to the API documentation so that you can get started.

## Authentication

Once the management API has been enabled for your account, you will be able to
acces your API key on the account page of the CloudMailin dashboard.

This key can be used for perform the following features and more:

* Create new, modify and delete CloudMailin addresses
* Create and delete custom domains for receiving email (this is useful if you
  want to whitelabel CloudMailin and allow customers to receive email on their
  own domain)
* Fetch all of the recent message delivery statuses for a given CloudMailin
  address
* Add a new sending domain for sending email via the CloudMailin API (this is
  also useful when sending on a customer's behalf using their own domain name)

There are also a number of other features not listed here that are available
via the API and visible in the API documentation.
