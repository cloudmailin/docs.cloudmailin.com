---
title: Questions? - Frequently Asked Questions
---
# Frequently Asked Questions

The following are some of the most frequently asked questions at CloudMailin. We're hoping to build this up into a bit more of a knowledge base so feel free to add more to the [issue tracker on github](https://github.com/CloudMailin/docs.cloudmailin.com/issues).

### How long does it take for a message to arrive?
Your emails should arrive within seconds (actually we aim for it to be milliseconds). Our email server doesn't poll for your emails, they will be received as soon as they are sent to the server. A little bit of processing and they're sent straight on to your app.

### How do I change the website that my email is posted to
The CloudMailin website allows you to view all of your email addresses and to change the target location. Click [here](http://www.cloudmailin.com/addresses) to view and edit your addresses.

### How can I use my own domain name or email@mydomain.com instead of a CloudMailin address.
Absolutely check out [Forwarding and Custom Domains](/receiving_email/forwarding_and_custom_domains/) for more details.

### Can I create a Wildcard DNS entry or subdomain for my Custom Domain?
Yes. Make sure you create a wildcard DNS entry then just enter *.yourdomain.com as your custom domain.

### How can I give each of my users a unique email address to send to?
We recommend using either [Forwarding or Custom Domains](/receiving_email/forwarding_and_custom_domains/) to do this.

You can also use a plus in your email address to create a disposable email address. Disposable email addresses allow you to use a unique email address for each user. As an example, a user given an email address in the form example@example.com could use example+something@example.com or example+1.2.3@example.com.

### What format will the message arrive in?
Checkout the [HTTP POST Formats](/http_post_formats/) documentation.

### Do you support attachments?
Absolutely. Some formats also parse the attachments for you see [HTTP POST Formats](/http_post_formats/) for more details. We can also send your message direct to an [attachment store](/receiving_email/attachments).

### How robust is this service?
We have tried to make things pretty robust, in fact we should be far better than most email hosting systems, however everyone makes mistakes and sometimes things happen that are beyond our control.

We're not going to offer you one of those silly agreements that says something like 99% uptime (3 days a year is a long time!) instead we're going to promise to do our best. If the site goes down we will receive emails (ironic we know), SMS messages and hopefully a bunch of tweets! We will get cracking as soon as possible and work our socks off to bring the site back to life. If the server is unavailable, almost all mail servers will retry a little later anyway.

### What happens if the server is unavailable?
Because of the way email and SMTP works most mail servers will try and resend your emails until the email is delivered or too many retries have occurred. We are considering adding a separate backup mail server to make sure this happens quicker but for now we are relying on the other server to resend the mail.

### How can I test the different status codes?
We have wired up a few fake targets you can use to test your emails.

| URL                               | Description                                                                            |
|----------------------------------------------------------------------------------------------------------------------------|
| http://www.cloudmailin.com/target/200 | will simulate a 200 response. This simulates the message successfully being delivered. |
| http://www.cloudmailin.com/target/404 | will simulate a 404 response. This simulates your site not knowing anything about the page you have set as your target. |
| http://www.cloudmailin.com/target/500 | will simulate a 500 response. This simulates something going wrong on your site and you asking the server to deliver the message later. |

### How can I see the response my server returned
On the address page within CloudMailin you should see the message and the status that your server returned to CloudMailin. Clicking on the details tab will also show additional information.
The details also include the first 2kb of any failed response so that you can determine what may have gone wrong with your server.

### My server had a temporary problem and a message was delayed, how can I see if it was delivered?
You can use the details page for a delivery status to see all delivery attempts with the same message ID. Hopefully one of these is green.

### I am receiving an error trying to create my custom domain?
You must make sure that your setup your DNS entries with either a CNAME or MX records pointing to CloudMailin before trying to enter a custom domain in the control panel. If you try to enter your custom domain first, it will fail to validate stating that the DNS records cannot be found. Take a look [here](/receiving_email/forwarding_and_custom_domains/) for more information about setting up your custom domains.

### Where are your servers based?
Our servers predominantly based in EC2's US-EAST region (it is most likely these are the servers you will reach). This is to allow low latency and cut costs for the majority of our users. We do however make use of several other hosting providers to provide redundancy can add others upon request if required. [Contact us](http://www.cloudmailin.com/contact_us) for more details.