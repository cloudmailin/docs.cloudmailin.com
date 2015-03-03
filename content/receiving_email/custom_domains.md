---
title: Custom Domains
---

# Custom Domains

The Custom Domain feature allows you to use CloudMailin to receive all email for your domain. With Custom Domains you can create a DNS entry in your own domain name to allow CloudMailin to accept all email on that domain and forward it onto your website just like your regular CloudMailin address.

Each of your CloudMailin addresses can have its own custom domain allowing you to use the feature for any number of websites and domains.

## Setting up Custom Domains

The first step is to add a record to your Domain Name Server (DNS) to state that the CloudMailin server should be the server to receive your email. There are two options for this, using a CNAME or adding MX records manually. We recommend adding the MX records directly to your account. This may mean that you have to update the records if CloudMailin ever changes it's defaults however, using a CNAME can cause issues in some edge cases so it's generally worth the overhead.

| Type                                                     | Advantages                                                    | Downsides       |
|----------------------------------------------------------|---------------------------------------------------------------|-----------------|
| `MX Records` [Adding MX Records](#setting-up-mx-records) | Using MX Records provides a lot more flexibility and allow you host other records on the same domain. | However, they require you to update each of your MX records if ever CloudMailin change the defaults. |
| `CNAME Records` [Adding a CNAME](#adding-a-cname)        | CNAME Records make management of your domain much easier, your entire domain will be given the DNS records that we specifiy for clients.cloudmailin.net and will be updated whenever we change these entries automatically. | However, there are a few edge cases where this doesn't work, or when you need to be able to control other records, for example if you also host a website on this domain name. |

## Adding Your Custom Domain

Once your DNS records are setup The next step is to go to the [CloudMailin](http://www.cloudmailin.com) and go to the address page for the address you wish to add the custom domain for. Once you are on the page you can click the custom domains button to add your domain name to the address. Any email sent to the CloudMailin servers with a to address with that domain will now be sent to your website.

Note that both of these methods will prevent you from receiving regular email on this domain so we recommend using a subdomain such as mail.example.com. If you only want to receive email on one email address we recommend you [set up a forwarding account](/receiving_email/email_forwarding/) on your domain.

You can also setup wildcard DNS entries to point to CloudMailin. For example you could enter \*.example.com as your custom domain so long as there is a DNS entry for \*.example.com that is either a CNAME or has MX records pointing to CloudMailin.

## Setting Up MX Records
Adding MX records directly to your DNS server is our recommended way of mapping your domain to send directly to CloudMailin's servers.

Add the following MX records and priorities:

    mail.example.com MX client1.cloudmailin.net. 5
    mail.example.com MX client2.cloudmailin.net. 5

You can check your configuration with the host command:

    $ host mail.example.com
    ..
    mail.example.com mail is handled by 5 client2.cloudmailin.net.
    mail.example.com mail is handled by 5 client1.cloudmailin.net.

## Adding a CNAME
We no longer recommend that you use a CNAME to setup your custom domain. This method has the advantage that whenever we change the locations or names of our mail servers your DNS record will always be up to date with the latest details. However, it has the downside of a few incompatibiliy issues with some servers. To add use this method create a CNAME record pointing to:

    clients.cloudmailin.net

You can check your configuration with the host command:

    $ host mail.example.com
    mail.example.com is an alias for clients.cloudmailin.net.

## Validating the MX and CNAME Records

Please make sure that you setup your DNS entries before trying to enter a custom domain in the CloudMailin system. If you try to register your CustomDomain before creating the DNS entries then the CloudMailin system will not validate your custom domain and it cannot be used. If you have any problems setting up your MX Records [contact us](http://www.cloudmailin.com/contact_us).

If you need to ensure a transfer from one mail server to the CloudMailin system please [contact us](http://www.cloudmailin.com/contact_us) and we can setup the custom domain before you change your DNS records.

