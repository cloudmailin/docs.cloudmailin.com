---
title: Getting replies from your email messages
---

# Getting replies from emails

CloudMailin will attempt to extract the plain text reply from an email whenever the email is a reply to another email. There are several factors to be considered here.

Firstly CloudMailin uses a `Magic Marker` and takes all content above this content. CloudMailin will look for `### Reply Above This Line ###` and only take the content above this. CloudMailin will also look for indented content using the `>` character at the start of the line.

In addition to this we'll also try and remove the header line from the reply, things like `on 1st Jan, You wrote:`.

For example the following email:

    Hey this looks great!

    On 1st Jan, Alex wrote:
    > ### Reply Above This Line ###
    > Hey this is an email that I sent to you
    >
    > Alex.

Will result in the following:

    Hey this looks great!

Within most of the message formats the reply will be contained within the `reply_plain` paramter. For more details see [HTTP Post Formats](/http_post_formats/).

As with most things email related, things might not be perfect. If you spot something that hasn't been parsed correctly or a reply that contains more or less than you expected please contact us and let us know!