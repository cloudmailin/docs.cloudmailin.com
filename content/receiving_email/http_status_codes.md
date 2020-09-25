---
title: HTTP Status Codes - Accepting, Rejecting and Retrying Emails
description: HTTP Status Codes - Accepting, Rejecting and Retrying Emails. How CloudMailin reacts to your server's Status Response.
---

# Accepting, Rejecting and Retrying Messages

CloudMailin will send your email as an HTTP POST request to the url that you specify. Depending on the status code we receive from your app several things can happen. The message will either be rejected, delayed or considered successfully delivered.

## HTTP Status Codes

The following table outlines the HTTP status codes and the actions that CloudMailin will take.

| Status Code | Examples                                                            | Action Taken     |
|-------------|---------------------------------------------------------------------|------------------|
| 2xx         | `200 - OK`, `201 - Created`                                         | Message receipt was successful.
| 4xx         | `403 - Forbidden`, `404 - Not Found`, `422 - Unprocessable Entity`  | The message will be rejected and the sender will be notified of this problem. |
| 5xx         | `500 - Internal Server Error`, `503 - Service Unavailable`          | The message delivery will be delayed. We will tell the mail server to try again later. |
| Redirects   | `301 - Moved Permanently`, `302 - Found`                            | Redirects will be followed up to 3 times. |
| Unreachable | `0`, `Unreachable`                                                  | If we cannot reach your server the message will be delayed. We will tell the mail server to try again later. |

Any other status and we will consider the message delayed and tell the mail server to try again later. This will be shown as either `0` or `unreachable` in the delivery status pages.

## Custom Error Messages

You can send a custom error message when you reject a message by making sure the content type of your response is set to text/plain. This text will then be sent as part of the error message given by the server. This error message will also be stored within the Delivery Status of the message. You can use this to debug any problems that might occur at your server along with your own server logs.

## Custom Maximum Size Message

Since sending a message larger than the allowed maximum size doesn't send a request to your web server you can set the message that's returned to your users as their email is bounced. Clicking on the 'Customize Message' button within the address page allows you to change this message.
