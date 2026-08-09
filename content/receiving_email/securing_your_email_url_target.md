---
title: Securely receiving email via HTTP POST
description:
  CloudMailin allows you to Securely receive email via Webhook (HTTP POST).
  An Authorization header allows you to prevent impersonation.
---

# Ensuring that Email Webhooks come from CloudMailin

CloudMailin will send your email as an HTTP POST, but how can you ensure that
the POST is actually coming from CloudMailin and not from another source
attempting to send messages on our behalf?

CloudMailin provides two solutions to ensure your Email to HTTP POST is secure:

| Type                     | Availability      | Description                     |
|--------------------------|-------------------|---------------------------------|
| [Authorization Header]   | `All Formats`     | When used with HTTPS this provides a simple and effective way to secure your target and ensure that only CloudMailin has permission to post to it
| [Signed Requests]        | `Original Format` | Provided for the Original Format but **now Deprecated**.

[Authorization Header]: #the-authorization-header
[Signed Requests]: /receiving_email/signed_http_requests/

## The Authorization Header

We recommend that all requests CloudMailin makes to your target URL are over
HTTPS with an Authorization header. This ensures that only CloudMailin is able
to POST requests to this URL.

To set one, open your address, choose **Authorization Settings** and enter the
header value you want us to send. We will add it to every request we make to
your target. Any value works, so all of the following are valid:

```
Bearer my-token
Basic dXNlcjpteXBhc3M=
my-api-key
```

Leave the field blank to send no Authorization header at all.

> Note: Because the value is sent in the headers it's important to use HTTPS if
> you wish for this secret to remain secure.

## Basic Authentication

Basic authentication is a good default and most frameworks handle it for you.
The header value is the word `Basic`, a space, and then a Base64 encoded
representation of your username and password joined by a colon. For the
username `user` and the password `mypass`, `user:mypass` encodes to
`dXNlcjpteXBhc3M=`, making the header:

```
Authorization: Basic dXNlcjpteXBhc3M=
```

You don't need to work the encoding out yourself. The Authorization Settings
page has a tool that takes a username and password and builds the header for
you in your browser.

As an example, in Rails you can check Basic Authentication like this:

```ruby
class MyController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "mypass"
end
```

Because the username and password are encoded together, characters like `@`
and `%` need no special treatment. If you previously had to URL encode them,
that is no longer the case.

## Credentials in the target URL

CloudMailin used to accept basic authentication credentials as part of the
target URL itself, in the form `https://user:mypass@example.com/incoming`.
That is no longer supported, and setting a target URL in that format will now
show an error.

Any credentials that were set that way have been converted into an
Authorization header for you. The header CloudMailin sends is exactly the same
as it was before, so there was nothing to change at your end. Your target URLs
no longer contain the username and password, which keeps them out of logs and
referrer headers.

## Setting the header over the API

The address API accepts the header as `auth_header` when you create or update
an address:

```json
{
  "target": "https://example.com/incoming",
  "target_format": "json+n",
  "auth_header": "Bearer my-token"
}
```

The value is never returned when you read an address back. Send an empty value
to remove it. See [using the CloudMailin API] for more on managing addresses
this way.

[using the CloudMailin API]: /features/using_the_cloudmailin_email_api/
