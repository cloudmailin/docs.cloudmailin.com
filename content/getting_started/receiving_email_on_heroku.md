---
title: Receiving Email on Heroku
name: Getting Started on Heroku
---

# Getting Started On Heroku

[CloudMailin](http://www.cloudmailin.com) allows you to receive incoming email messages in your web app via an HTTP POST request.

When you install the CloudMailin Add-on you will be automatically given an email address to send email to. Any email sent to that address will automatically be forwarded to the web address of your choice.

## Getting Started on Heroku

You can install the CloudMailin Add-on from the Heroku website or the terminal. To get started using the terminal simply install the CloudMailin Add-on using the following command:

    $ heroku addons:add cloudmailin

This will automatically create you a CloudMailin account and create an address that will forward to the default location. To create a different CloudMailin plan just pass the plan name. For example to create the starter plan type:

    $ heroku addons:add cloudmailin:starter

Your CloudMailin email address will be stored in your Heroku Environment, for more details see [config vars in the Heroku documentation](https://devcenter.heroku.com/articles/config-vars). Heroku makes these config variables available within your apps environment. For example in Ruby you can retrieve them like so:

    reply_to = env['CLOUDMAILIN_FORWARD_ADDRESS']

You can also retrieve this from your terminal (along with your CloudMailin email and password) using the Heroku Gem by issuing the following command:

    $ heroku config --long

## Setting the Target Location

By default CloudMailin email addresses will forward to the CloudMailin [200 target](http://www.cloudmailin.com/target/200). This location will simply return a 200 status code causing the server to believe the message has been accepted and do nothing else with it.

In order to forward your email to your own website you need login to the [CloudMailin Dashboard](http://www.cloudmailin.com). There are three different ways to do this:

| Method                          | Logging In                                                                            |
|---------------------------------|---------------------------------------------------------------------------------------|
| Using the Terminal              | Use the gem and enter `$ heroku addons:open cloudmailin` into the terminal.           |
| Using the Heroku Website        | Just login to [Heroku] and select CloudMailin from the Add-On menu for your application. |
| Using a Username and Password   | First, obtain your CloudMailin Username and Password using `$ heroku config --long`. Then head to  [CloudMailin.com](http://www.cloudmailin.com) and login using these credentials. |

Once you're logged in you must set the target location for each HTTP POST containing your email and choose your HTTP POST Format. Click on the edit target button, here you can set the URL and choose the POST Format. For more details about the format that CloudMailin will send your email in see [HTTP Post Formats](/http_post_formats/).

We also recommend you look at our general [Getting Started Guide](/getting_started/) as it explains in more detail how you will be sent messages, how the HTTP Status codes you respond with affect the message delivery and walks you through receiving your first email.

## Adding Some Code

There are also some [code examples](/receiving_email/examples/) available for number of different languages and frameworks.

## Upgrading your Heroku Add-On

You can upgrade your Heroku Add-on to one of our other plans by using the upgrade command in the terminal. For example:

    $ heroku addons:upgrade cloudmailin:premium

This will upgrade your existing address and setup to the higher plan without you having to provision any new details or setup.
