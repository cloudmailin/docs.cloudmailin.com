---
title: Developing Locally with WebhookApp.com
---

# Debugging Locally with WebhookApp.com

Developing locally has always been a difficult task when relying on WebHooks and remote services.

In order to help with the development of CloudMailin enabled services we developed the [WebHookApp](http://webhookapp.com/).

The hook debugger is an external service that uses WebSockets in order to allow you to debug any webhook and see the parameters that are being passed. The great thing about the hook debugger though is that it can then take the parameters that it is passed and generate a `curl` command that can be used to mimic the request locally.

## Using the WebHookApp

**Note:** This will prevent emails being delivered to your live app so we recommend using another address if your app is already live.

  1. The first stage when using the hook debugger is to point your address target at the WebHookApp.
  2. Send an email to your CloudMailin email address that you'd like to send to your app.
  3. You should see the output instantly in the page.
  4. Clicking on the `toggle curl command` button allows you to see the curl command
  5. You can also use `add curl command to clipboard` to present all the command in a popup that you can copy and then paste.
  6. Then you can paste the command into the command line to send it to your local app (remember to edit the url at the end of the command).

To ensure the curl command is sent to your local app place your local url into the end of the command:

    ... --request POST http://localhost:3000/incoming_mail

You may also need to update the host header in order to ensure that your app receives the post successfully:

    ... -H 'host:localhost:3000' ...

If for some reason WebSockets are unavailable the debugger should revert to using long polling. The debugger is a bit of a side project, and it still has a few kinks that need working out, but if you encounter any issues with the debugger be sure to [contact us](http://www.cloudmailin.com/contact_us).