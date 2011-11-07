# Developing Locally

Developing locally has always been a difficult task when relying on WebHooks and remote services.

In order to help with the development of CloudMailin enabled services we developed the [HookDebugger](http://webhooks.no.de/).

The hook debugger is an external service that uses WebSockets in order to allow you to debug any webhook and see the parameters that are being passed.
The great thing about the hook debugger though is that it can then take the parameters that it is passed and generate a `curl` command that can be used to mimic the request locally.

## Using the HookDebugger

**Note:** This will prevent emails being delivered to your live app so we recommend using another address if your app is already live.

* The first stage when using the hook debugger is to point your address target at the HookDebugger.
* Send an email to your CloudMailin email address that you'd like to send to your app.
* You should see the output instantly in the page.
* Clicking on the `toggle curl command` button allows you to see the curl command
* You can also use `add curl command to clipboard` to present all the command in a popup that you can copy and then paste.
* Then you can paste the command into the command line to send it to your local app (remember to edit the url at the end of the command).

To ensure the curl command is sent to your local app place your local url into the end of the command:

    ... --request POST http://localhost:3000/mail

You may also need to update the host header in order to ensure that your app receives the post successfully:

    ... -H 'host:localhost:3000' ...

There is currently an that prevents WebSockets from functioning correctly on some browsers. When WebSockets are unavailable long polling or other request methods will be used instead.