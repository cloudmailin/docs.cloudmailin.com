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

## The SPAM Score

If SPAM Assassin is enabled on your account, you will receive the
following additional parameters within the envelope parameter of
the HTTP POST you receive from CloudMailin.

By default, you'll receive something like the following:


```json
"envelope": {
  "spamd": {
    "score": "1.1",
    "success": true
  }
}
```

| Field | Description |
| ----- | ----------- |
| `score` | The SpamAssasin assigned score. Spam assasin combines all of its rules and gives this score as the output.
| `success` | Did the scan complete. This will be `true` or `false` and is not an indication of the SPAM status just the success of the scan taking place.
| `symbols` | _(if present)_ The rule names that the message matched.
| `description` | _(if present)_ A human readable table of rules, their score and a description. Helpful for getting started. |

### Choosing a score threshold

Every system is different and it would be impossible to choose a score that works for everyone.

SpamAssasin uses a score of **5.0** or above to indicate SPAM by
default. However, this is quite aggressive.

With multiple people emailing you it may be better to start with
something like **8.0** or **10.0** and adjust things depending on
what you see with your system.

### Additional Details
If you need additional details from the report then this can be enabled. The symbols will pass each rule that the message matched.
This can be used to adjust a score to your liking and understand which rules matched.

```json
"envelope": {
  "spamd": {
    "score": "1.1",
    "symbols": [
      "ALL_TRUSTED",
      "DATE_IN_PAST_96_XX",
      "HTML_MESSAGE"
    ],
    "success": true
  }
}
```

#### Full Description

For even more detauls it's possible to include the SpamAssasin
table report.

The description field will contain additional information about
each of thethe rules that matched within SPAM Assassin and the
score that each rule contributed. This is really a human readable format though, it will be harder to parse.

```json
"envelope": {
  "spamd": {
    "score": "1.1",
    "response": " pts rule name              description\n---- ---------------------- --------------------------------------------------\n-1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP\n 2.1 DATE_IN_PAST_96_XX     Date: is 96 hours or more before Received:\n                            date\n 0.0 HTML_MESSAGE           BODY: HTML included in message\n\n",
    "success": true
  }
}
```

The description is directly from SPAM Assassin and might look
similar to this when rendered:

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
