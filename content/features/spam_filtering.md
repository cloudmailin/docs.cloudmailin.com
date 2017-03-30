---
title: Scanning Incoming Emails for SPAM
---

# Checking Incoming Emails for SPAM

For a long time, CloudMailin didn't support the ability to scan emails for SPAM.
It was and still is our belief that bayesian SPAM checking is best done at the account level.

However, we're pleased to announce that CloudMailin can now check your incoming emails for SPAM
using [SPAM Assassin](http://spamassassin.apache.org/) automatically.

SPAM Assassin performs a number of tests that give an indication of whether you should accept the
email or not.

The details of the SPAM score are passed as an HTTP POST to your target WebHook along with your
email content.

## Enabling SPAM checking for your CloudMailin email address

In order to enable SPAM checking on your CloudMailin email address, you'll need to
[contact support](http://www.cloudmailin.com/contact_us).

There are a number of options that can be enabled and disabled on dedicated servers.

### The SPAM Score

If SPAM Assassin is enabled on your account, you will receive the following additional
parameters within the envelope parameter of the HTTP POST you receive from CloudMailin.

By default, you'll receive something like the following:

```json
"envelope": {
  {"score":0.7,"success":true}
}
```

#### Additional Details

If you need additional details from the report then this can be enabled. The description field will
contain additional information about the rules that matched within SPAM Assassin.

```json
"envelope": {
  {"score":0.7,"response":" pts rule name              description\n---- ---------------------- --------------------------------------------------\n-0.0 NO_RELAYS              Informational: message was not relayed via SMTP\n 0.0 HTML_MESSAGE           BODY: HTML included in message\n 0.7 HTML_IMAGE_ONLY_28     BODY: HTML: images with 2400-2800 bytes of words\n-0.0 NO_RECEIVED            Informational: message has no Received headers\n 0.0 T_REMOTE_IMAGE         Message contains an external image\n 0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal information\n\n","success":true}
}
```
The output is directly from SPAM Assassin and would look similar to this when rendered:

| pts  | rule name              | description                                      |
|:-----|:-----------------------|:-------------------------------------------------|
| -0.0 | NO_RELAYS              | Informational: message was not relayed via SMTP  |
| 0.0  | HTML_MESSAGE           | BODY: HTML included in message                   |
| 0.7  | HTML_IMAGE_ONLY_28     | BODY: HTML: images with 2400-2800 bytes of words |
| -0.0 | NO_RECEIVED            | Informational: message has no Received headers   |
| 0.0  | T_REMOTE_IMAGE         | Message contains an external image               |
| 0.0  | T_FILL_THIS_FORM_SHORT | Fill in a short form with personal information   |


## Contact Us

In order to enable SPAM checking on your CloudMailin email address, please
[contact us](http://www.cloudmailin.com/contact_us).
