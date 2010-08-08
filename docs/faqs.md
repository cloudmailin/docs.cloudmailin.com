FAQs
=

The following are some of the frequently asked questions. Please contact us with any other questions and if there is anything that you think should be on this list.

How long does it take for a message to arrive?
-
Your emails should arrive within seconds (actually we aim for it to be milliseconds). Because we have written our own custom SMTP server we don't poll for your emails. The will be received as soon as they are sent to the server. A little bit of processing and they're sent straight on to your app.

How do I change the website that my email is posted to
-
The CloudMailin website allows you to view all of your email addresses and to change the target location. Click [here](http://cloudmailin.com/addresses) to view and edit your addresses.

How can I use my own domain name or email@mydomain.com instead of a CloudMailin address.
-
The easiest way to do this is to get your current email server to forward any mail sent to example@mydomain.com to your cloudmailin address.

How can I give each of my users a unique email address to send to?
-
At the moment we recommend forwarding email from your own domain to your cloudmailin address in order to achieve this. You can then look at the message envelope to see which address the message was sent to.

We are looking into the option of using a plus in the address to also do this. Please contact us if this is something you would really like.

What format will the message arrive in?
-
Your server will receive an HTTP POST to the url that you specify. This will be in exactly format as if the user pasted the email into one of the fields of a multipart/form-data form on your website. For more details of the exact format please see the HTTP POST [documentation](post_format).

Great I've got the raw email but how to I get the content from it?
-
We send you the raw email so that your system can parse it the way you want it to. We do however pull out some basic info like the sender and subject to make life easier. There are loads of libraries out there to take the raw email and extract the contents. Take a look at [this](parsing_email) page for some examples.

Do you support attachments?
-
Sure, we send you the entire email in its raw form. Its up to you to get the attachment out of the email but there are plenty of tools to help you do this. Take a look at [this](parsing_email) page for some examples.

How robust is this service?
-
We have tried to make things pretty robust, in fact we should be far better than most email hosting systems, however everyone makes mistakes and sometimes things happen that are beyond our control.

We're not going to offer you one of those silly agreements that says something like 99% uptime (3 days a year is a long time!) instead we're going to promise to do our best. If the site goes down we will receive emails (ironic we know), SMS messages and hopefully a bunch of tweets! We will get cracking as soon as possible and work our socks off to bring the site back to life. If the server is unavailable almost all mail servers will retry a little later anyway.

What happens if the server is unavailable?
-
Because of the way email and SMTP works most mail servers will try and resend your emails until the email is delivered or too many retries have occurred. We are considering adding a separate backup mail server to make sure this happens quicker but for now we are relying on the other server to resend the mail.

What if my site is down?
-
In exactly the same way that servers will retry if our system is down the same will happen with your system. In fact we will respond to the following status codes or errors:

* If we can't reach your server. We will tell the user's mail server that there has been a temporary problem so try again later. This will be shown as 000 in the delivery status pages.
* If you give us an http status of *200* - Everything is good we will tell the mail server the message has been delivered
* If you give us an http status of *404* - The message will be rejected and the sender will be notified of this problem.
* If you give us an http status of *420* - The message will be rejected and the sender will be notified of this problem.
* If you give us an http status of *500* - we will tell the mail server to try again later.
* Any other status and we will also tell the mail server to try again later.

See the [HTTP Status Codes](http_status_codes) page for more details

How many times will a user's email server retry before it gives up?
-
This is entirely dependent on how the mail server was set up. However, most mail servers will retry often at first and then start to back off. In our experience Google for example will start by trying every 30 minutes then back off to once every 4 hours or so and will do this for about 4 days. They will also tell the user that the message delivery has been delayed.

How do I know that things are working?
-
We have built a simple delivery status system to allow you to see some basic details about the most recent messages we have received and tried to deliver to your site. Most importantly the HTTP status that your site returned is logged as part of this status. A status of 000 means we couldn't reach the server specified as the target.

How can I test things with a fake target?
-
We have wired up a few fake targets you can use to test your emails.

* http://cloudmailin.com/target/200 - will simulate a 200 response. This simulates the message successfully being delivered.
* http://cloudmailin.com/target/404 - will simulate a 404 response. This simulates your site not knowing anything about the page you have set as your target.
* http://cloudmailin.com/target/500 - will simulate a 500 response. This simulates something going wrong on your site and you asking the server to deliver the message later.