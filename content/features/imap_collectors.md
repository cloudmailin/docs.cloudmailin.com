---
title: Receiving email via IMAP polling and forwarding to your Rails, PHP, Node.JS web app
---

# Polling IMAP accounts and forwarding to your Website via HTTP

<div class="warning">We strongly recommend that you look at CloudMailin's standard approach to collecting email and delivering it via HTTP POST <a href="/getting_started/">here</a>. However, in some cases IMAP collection is the best choice.</div>

IMAP polling allows you to collect email from existing email accounts and deliver the email to your web app via HTTP POST.
Although there are a number of drawbacks to using this approach, using IMAP polling can provide an alternative solution for message retreival and in some cases it's the best option. It can also be used to transition from legacy setups to the CloudMailin architecture.

IMAP polling allows you to enter the IMAP details of an existing email account and will periodically poll that account and collect the email from the account. Messages that are received will be marked as read and any that fail will remain unread and tried next time.

## Disadvantages to Polling

There are several disadvantages to using this method:

  * Messages are only collected periodically, with the normal setup messages will arrive in real time.
  * Communication with the sending server has already occurred so features such as Auth Callbacks, Auth Regexp and SPF will not work for IMAP messages.
  * The HTTP Status codes that you return will never result in a hard bounce, just a message being marked as read or unread on the server.


We recommend contacting us before you setup an IMAP poller to be sure you're getting the best from our system. In many cases there's an alternative option allowing you to use the standard, more effective, setup.

## Setting up an IMAP Collector

Each CloudMailin email address can have a number of IMAP Pollers. The pollers can function in addition to the normal setup (using either forwarding to your CloudMailin address or custom domains). The pollers will poll for messages on a regular basis and will attempt to deliver the messages to the existing CloudMailin address.

In order to setup the poller you will need the following details.

| Account Detail | Description                                            |
|----------------|--------------------------------------------------------|
| host           | The hostname of your IMAP server (e.g. imap.gmail.com) |
| port           | The port the IMAP server is listening on (e.g. 993)    |
| ssl            | Use SSL/TLS?                                           |
| folder         | The folder to retrieve messages from once connected    |
| username       | The username of the account accessing the IMAP server  |
| password       | Your IMAP account's password                           |

Once the collector is setup it will make an initial poll to determine if it can successfully connect to the server.
The status of the last collection will be shown aloing with the number of messages in the account that have not been collected yet.

## Marking messages as Read / Collected

The IMAP poller will use the READ flag to determine whether the message was sucessfully collected. If you issue a `2xx` or `4xx` status code then the message will be marked as read.
If there is an issue encountered contacting your server or we receive a `5xx` status code then we will mark the message as unread again and collection will be attempted next time.

    NOTE: You must be sure to check the unread messages from time to time.
    There is currently no system in place to remove a message that repeatidly
    fails, delivery will be attempted every time the system polls for messages.

| Status Code | Examples                                                            | Action Taken                                               |
|-------------|---------------------------------------------------------------------|------------------------------------------------------------|
| 2xx         | `200 - OK`, `201 - Created`                                         | Message marked as `read`.                                  |
| 4xx         | `403 - Forbidden`, `404 - Not Found`, `422 - Unprocessable Entity`  | Message marked as `read`.                                  |
| 5xx         | `500 - Internal Server Error`, `503 - Service Unavailable`          | Message marked as `unread`. Will be tried again next poll. |
| Unreachable | `0`, `Unreachable`                                                  | Message marked as `unread`. Will be tried again next poll. |
| Redirects   | `301 - Moved Permanently`, `302 - Found`                            | Redirects will be followed up to 3 times.                  |

