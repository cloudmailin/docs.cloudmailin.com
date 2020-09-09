---
title: Receiving emails with multiple recipients
---

# Receiving emails with multiple recipients in a single transaction

If you send an email to multiple recipients on the same domain the sending server can do one of two things.
The first is to split the messages and send multiple identical copies of the message to the server.
Alternatively the sending server might just send one copy of the message and send the `RCPT` command multiple times.

The transaction would look something like this:

    220 Server Name Says Hello
    ...
    MAIL FROM: from@example.com
    250 Ok
    RCPT TO: to@example.com
    250 Ok
    RCPT TO: to@example.com
    250 Ok
    DATA
    354 Send it
    ...

When CloudMailin receives multiple recipient commands it will validate that each of the recipients is accepted in the same way that it would when just receiving one recipient. If one of the recipients is rejected at the authentication phase then the remote server will choose how to handle this response accordingly.

The list of recipients will then be passed along to your target within the envelope parameters as a list of `Recipients`.

If you need to handle multiple recipients differently we can adjust the way that these parameters are handled on a per account basis just [contact us] and let us know what you need to do.
