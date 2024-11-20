---
title: Callbacks - Interacting with Authorization and Error Notification
---

# Authorization and Error Callbacks

CloudMailin has the ability to make additional callbacks as well as just sending your app the HTTP POST containing your emails. CloudMailin can make the following callbacks.

| Callback Type             | Information                                                           |
|---------------------------|-----------------------------------------------------------------------|
| `Authorization Callbacks` | Authorization callbacks allow you to interact with the authorization of messages before any content is transmitted. They let your app act like the mail server and decide who is and isn't allowed in the sender and to fields. |
| `Error Callbacks`         | Error callbacks fire whenever CloudMailin receives a [HTTP status code](/receiving_email/http_status_codes/) that isn't in the `2xx` range. They can be used to alert you whenever something isn't right. |

## Authorization Callbacks

Authorization callbacks fire before any data is received by our server. They send an HTTP POST to your app containing details about the message and let your app decide who is and isn't allowed to send emails to your server. Depending on how you respond the server will either accept the message and continue, reject the message, or mark it as delayed. If you don't specify an authorization callback then the app will just accept the messages like it does by default.

The authorization callback sends the following parameters to your app

| Parameter     | Description                                                                                             |
|---------------|---------------------------------------------------------------------------------------------------------|
| `to`          | The message recipient, this could be your CloudMailin email address or custom domain email.             |
| `from`        | The message sender's email address.                                                                     |
| `size`        | The size of the message the user is trying to send. This isn't always available as it relies on SIZE being sent to our servers with the message sender. |
| `remote_ip`   | The IP address of the server that is sending this message to the CloudMailin servers                    |
| `helo_domain` | The domain that the remote server authenticated with when it connected to the CloudMailin email Servers |
| `spf`         | The [SPF](/features/spf/) result for the given IP address and Domain.                                   |

The callback is available in `URL Encoded`, `JSON` and `XML` formats. Each representation will all present the above parameters but the xml format will wrap these in a node called `parameters`, examples can be seen below.

The acceptance of the message will be determined by the HTTP Status code that you send back to CloudMailin. The table shows the status codes your app can send and the action that will be taken by the CloudMailin servers:

| Status Code | Action Taken by CloudMailin                                                               |
|-------------|-------------------------------------------------------------------------------------------|
| `2xx`       | The message will be accepted and the server will be asked to continue sending it's data.  |
| `3xx`       | CloudMailin will attempt to follow redirects up to 3 times.                               |
| `4xx`       | The message will be rejected and the remote server informed that it should not retry delivery. This will normally result in a bounce message being sent to the sender (SMTP `550`). |
| `5xx`       | The message will be delayed. We will inform the server that an error occurred contacting the authorization server (SMTP `450`) |

### Examples

An example `application/x-www-form-urlencoded` callback is as follows:

```application/x-www-form-urlencoded
size=102400&to=to%example.net&from=from%2Btest%40example.com&helo_domain=localhost&remote_ip=127.0.0.1&spf[result]=pass&spf[domain]=example.com
```

An example `application/json` callback is as follows:

```json
{"size":102400,"to":"to@example.net","from":"from+test@example.com","helo_domain":"localhost","remote_ip":"127.0.0.1","spf":{"result":"pass","domain":"example.com"}}
```

An example `application/xml` callback is as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<parameters>
  <size type="integer">102400</size>
  <to>to@example.net</to>
  <from>from+test@example.com</from>
  <helo-domain>localhost</helo-domain>
  <remote-ip>127.0.0.1</remote-ip>
  <spf>
    <result>pass</result>
    <domain>example.com</domain>
  </spf>
</parameters>
```

## Error Callbacks

Error callbacks are alerts that fire whenever CloudMailin doesn't receive a `2xx` status from your website. You can add the error callback from the address page by clicking on the `Callback Settings` button. Here you can enter a URL that will be registered as a callback whenever the email is delayed or rejected by your website. The callback parameters will either be sent as `application/x-www-form-urlencoded` or `JSON` depending on the extension of the URL. A URL ending in `.json` will be sent in `JSON` format, any other url will send the url encoded data.

When an error callback fires it will contain the following parameters:

| Parameter  | Description                                                                                 |
|------------|-------------------------------------------------------------------------------------------- |
| `status`   | The HTTP status code returned by your web server.                                           |
| `to`       | The message recipient, this could be your CloudMailin email address or custom domain email. |
| `from`     | The message sender's email address.                                                         |
| `response` | The content of the response given by your web server to help with debugging the problem.    |

### Example

An example `application/x-www-form-urlencoded` formatter response is as follows:

```application/x-www-form-urlencoded
status=422&to=recipient%40example.com&from=from%40example.com&response=%3Chtml%3E%3Cbody%3EAn%20error%20occurred%20trying%20to%20save%20this%20data.%3C%2Fbody%3E%3C%2Fhtml%3E
```

An example `JSON` formatted response is as follows:

```json
{
  'status': 422,
  'to': 'recipient@example.com',
  'from': 'from@example.com',
  'response': '<html><body>An error occurred trying to save this data.</body></html>'
}
```
