---
title: Callbacks - Interacting with Authorization and Error Notification
---

# Authorization and Error Callbacks

CloudMailin has the ability to make additional callbacks as well as just sending your app the HTTP POST containing your emails. CloudMailin can make the following callbacks.

| Callback Type             | Information                                                           |
|---------------------------|-----------------------------------------------------------------------|
| `Error Callbacks`         | Error callbacks fire whenever CloudMailin receives a [HTTP status code](/receiving_email/http_status_codes) that isn't in the `2xx` range. They can be used to alert you whenever something isn't right. |
<%# | `Authorization Callbacks` | Authorization callbacks allow you to interact with the authorization of messages before any content is transmitted. The let your app act like the mail server and decide who is and isn't allowed in the sender and to fields. | -%>

## Error Callbacks

Error callbacks are alerts that fire whenever CloudMailin doesn't receive a `2xx` status from your website. You can add the error callback from the address page by clicking on the `Callback Settings` button. Here you can enter a URL that will be registered as a callback whenever the email is delayed or rejected by your website. The callback parameters will either be sent as `application/x-www-form-urlencoded` or `JSON` depending on the extension of the URL. A URL ending in `.json` will be sent in `JSON` format, any other url will send the url encoded data.

When an error callback fires it will contain the following parameters:

| Parameter  | Description                                                                                 |
|--------------------------------------------------------------------------------------------------------- |
| `status`   | The HTTP status code returned by your web server.                                            |
| `to`       | The message recipient, this could be your CloudMailin email address or custom domain email. |
| `from`     | The message sender's email address.                                                         |
| `response` | The content of the response given by your web server to help with debugging the problem.     |

### Example

An example `application/x-www-form-urlencoded` formatter response is as follows:

    status=422&to=recipient%40example.com&from=from%40example.com&response=%3Chtml%3E%3Cbody%3EAn%20error%20occurred%20trying%20to%20save%20this%20data.%3C%2Fbody%3E%3C%2Fhtml%3E

An example `JSON` formatted response is as follows:

    {
      'status': 422,
      'to': 'recipient@example.com',
      'from': 'from@example.com',
      'response': '<html><body>An error occurred trying to save this data.</body></html>'
    }

    