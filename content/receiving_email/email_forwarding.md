---
title: Email Forwarding
---

# Email Forwarding

Email forwarding allows you to receive CloudMailin email to your own domain name such as example@yourdomain.com. Forwarding can be set up at your domain registrar or from your existing email provider such as Google Mail.

Using email forwarding you can forward a single or multiple email addresses to your CloudMailin email address.

**Note:** _When email forwarding is in place CloudMailin has no control over when the provider will forward the message. It can result in delays in delivery that are beyond our control._

## Setting up Email Forwarding

### Google Mail

  1. Log into your google account.
  2. Follow the link to `Forwarding and POP/IMAP`.
  3. Click the `Add a forwarding address` button.
  4. Enter your CloudMailin email address and click next.
  5. An email will be sent to your CloudMailin address for verification. To view the email that's sent either view your applications logs or you can use the [debugger](/receiving_email/localhost_debugger/) (set the debugger as the address target and click resend verification email).
  6. Once the email is verified select the email address within the drop-down menu.
  7. Now any email sent to this email should automatically be forwarded onto your CloudMailin address.

This guide will contain examples to help demonstrate setting up email forwarding on different hosts. To contribute to the document please contact us or edit it yourself on github.

### Go Daddy
In order to receive email from your domain with go daddy:

  1. Log into your GoDaddy.com [account manager](https://www.godaddy.com/).
  2. Follow the instructions [here](https://uk.godaddy.com/help/set-up-my-forwarding-email-address-7598) up to step 8.
  3. In the `Forward Mail To` field enter your CloudMailin email address.
  4. If you want to send all emails to your CloudMailin address check `use catchall`.
  5. Now any email sent to your domain should automatically be forwarded onto CloudMailin and therefore your app.

### IONOS (1&1)
In order to redirect email from your one and one domain:

  1. Log into your account [here](https://my.ionos.com/).
  2. Follow the instructions [here](https://www.ionos.co.uk/help/email/setting-up-mail-basic/creating-a-forwarding-email-address/) up to step 5.
  3. To create a catch all address so that all email from that domain goes to the CloudMailin address enter `*` in the `Email Address` field, otherwise enter the email address you wish to use.
  4. Choose type forward and enter your CloudMailin email address in the address field.
  5. Now any email sent to your domain should automatically be forwarded onto CloudMailin and therefore your app.
