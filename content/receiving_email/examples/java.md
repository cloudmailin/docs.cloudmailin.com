---
title: Receiving Email with Java
skip_erb: true
---

# Receiving Email with Java

## Play! 1.2.4

Here's an example of how to extract parameters from the original Cloudmailin HTTP POST. First, set up a route to your controller's action in `conf/routes`:

    POST    /incoming_mail                       Mail.incomingMail

In the action method's signature, you can specify whichever parameters are relevant for your app. This example assigns `to`, `from`, `disposable`, and a list of `attachments`. All of the parameters are still available via the `params` object.

    public class Mail extends Controller {

        public static void incomingMail(String to, String from, String disposable, List<Map> attachments) {
            // Do something with mail
        }
    }

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mail and thats it!
