---
title: Securely receiving email via HTTP POST
description: |
  CloudMailin allows you to Securely receive email via Webhook (HTTP POST)
  Basic authentication allows you to prevent impersonation.
---

# Ensuring that Email Webhooks come from CloudMailin

CloudMailin will send your email as an HTTP POST, but how can you ensure that
the POST is actually coming from CloudMailin and not from another source
attempting to send messages on our behalf?

CloudMailin provides two solutions to ensure your Email to HTTP POST is secure:

| Type                   | Availability      | Description                     |
|------------------------|-------------------|---------------------------------|
| [Basic Authentication] | `All Formats`     | When used with HTTPS this provides a simple and effective way to secure your target and ensure that only CloudMailin has permission to post to it
| [Signed Requests]      | `Original Format` | Provided for the Original Format but **now Deprecated**.

[Basic Authentication]: #basic-authentication-and-https
[Signed Requests]: /receiving_email/signed_http_requests/

## Basic Authentication and HTTPS

We recommend that all requests CloudMailin makes to your target URL are over
HTTPS using basic authentication. This ensures that only CloudMailin is able to
POST requests to this URL.

Unlike the Signed requests using Basic Authentication to secure your request is really simple. You simply pass a username and password within your target URL as you set it. We will then extract this username and password and add it the headers of each request that we make. For example:

```
https://user:mypass@cloudmailin.com/target/200
```

The example above would pass along the username and password would pass `user` and `mypass` along to the application. This would add the following HTTP header to the request:

```
Authorization: Basic dXNlcjpteXBhc3M=
```

The string `dXNlcjpteXBhc3M=` is simply a Base64 encoded representation of `user:mypass`.

> Note: Because the string is sent in the headers it's important to use HTTPS if you wish for
> this secret to remain secure.

Most frameworks will handle basic authentication for you.
As an example Rails you can use the following method to check Basic Authentication:

```ruby
class MyController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "mypass"
end
```


### URL Encoding Usernames and Passwords

It's important to remember that you're specifying your username and password as part of a URL. Therefore if you want to use usernames and passwords that contain certain symbols (such as the `@` symbol) you'll need to URL encode them.

For example `youremail@yourdomain.com` should be encoded as `youremail%40yourdomain.com`. This would make the URL something like the following:

```
https://youremail%40yourdomain.com:password@yourdomain.com/incoming_mails/
```

Note that the actual `@` character is used to show that we're passing credentials and the `:` is used to seperate the username and password. If you need help converting to the URL encoded format checkout [this converter](http://meyerweb.com/eric/tools/dencoder/) by Eric Meyer. We've also included a few common characters in the table below:

| Character | URL Encoded Version |
|-----------|---------------------|
| `!`       | `%21`               |
| `[space]` | `%20`               |
| `@`       | `%40`               |
| `$`       | `%24`               |
| `%`       | `%25`               |
| `^`       | `%5E`               |
| `&`       | `%26`               |
| `*`       | `%2A`               |
| `(`       | `%28`               |
| `)`       | `%29`               |
| `?`       | `%3F`               |
| `,`       | `%2C`               |
| `=`       | `%3D`               |
