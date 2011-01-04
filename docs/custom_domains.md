# Custom Domains (Experimental)
Custom Domains is a new feature that lets you use your own domain for receiving email through CloudMailin.
With Custom Domains you can create a DNS entry in your own domain name to allow CloudMailin to accept all email on that domain and forward it onto your website just like your regular CloudMailin address.

Each of your CloudMailin addresses can have it's own custom domain allowing you to use the feature for any number of websites.

## Setting up Custom Domains
The first step is to go to the [CloudMailin](http://cloudmailin.com) and go to the address page for the address you wish to add the custom domain for. Once you are on the page you can click the custom domains button to add your domain name to the address. Any email sent to the CloudMailin servers with a to address with that domain will now be sent to your website.

The next step is to add a record to your Domain Name Server (DNS) to state that the CloudMailin server should be the server to receive your email. There are two options for this, using a CNAME, the preferred method and adding MX records manually.

Note that both of these methods will prevent you from receiving regular email on this domain so we recommend using a subdomain such as mail.example.com. If you only want to receive email one one email address we recommend you [set up a forwarding account](forwarding) on your domain.

You can also setup wildcard DNS entries to point to CloudMailin. For example you could enter \*.example.com as your custom domain so long as there is a DNS entry for \*.example.com that is either a CNAME or has MX records pointing to CloudMailin.

## Adding a CNAME
Using a CNAME is the preferred method of pointing your domain at our email servers. This method means that whenever we change the locations or names of our mail servers your DNS record will always be up to date with the latest details. To add use this method create a CNAME record pointing to:

    clients.cloudmailin.net
    
You can check your configuration with the host command:
    
    $ host mail.example.com
    mail.example.com is an alias for clients.cloudmailin.net.

## Adding the Server Addresses as MX Records
If it isn't possible to use a CNAME or you need to receive email on your main domain then you can add MX records for your domain.

Add the following MX records and priorities:

    mail.example.com MX client1.cloudmailin.net. 5
    mail.example.com MX client2.cloudmailin.net. 10
    
You can check your configuration with the host command:
    
    $ host mail.example.com
    ..
    mail.example.com mail is handled by 10 client2.cloudmailin.net.
    mail.example.com mail is handled by 5 client1.cloudmailin.net.

## Validating the MX and CNAME Records
Please make sure that you setup your DNS entries before trying to enter a custom domain in the CloudMailin system. If you try to register your CustomDomain before creating the DNS entries then the CloudMailin system will not validate your custom domain and it cannot be used.

