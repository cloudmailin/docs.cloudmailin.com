---
title: Original HTTP POST Format
---

# Original HTTP POST Format

The original HTTP POST Format transfers emails to your web app using `multipart/form-data` requests. The POST contains the following parameters:

| Parameter     | Description |
|------------------------|
| `message`         | The message itself. This will be the entire message and will need to be manually parsed by your code if you wish to make use of this parameter. |
| `plain`           | The plain text extracted from the raw message. This will be the first text/plain part of the email if the message is multipart and the body if the content is not multipart. |
| `html`            | The html text extracted from the raw message. This will be the first text/html part of an email if the message is multipart. |
| `to`              | The form header as specified in the envelope by the sending server. This could be different to the to address specified in the message itself. If you are forwarding email from your domain you will want to extract the recipient from the email using the `x_to_header` parameter. |
| `disposable`      | The disposable part of the email address if it exists. For example if your email address was example+something@example.com, the disposable would contain 'something'. |
| `x_to_header`     | The to addresses found in the message itself and will be listed separated by a comma. |
| `x_cc_header`     | This is a new header that is being tested and we would appreciate feedback for. The CC addresses found in the message header will be listed separated by a comma.
| `from`            | The from header as specified in the envelope by the sending server. If you are forwarding email from your domain you will want to extract the sender from the email using the `x_from_header` parameter. |
| `x_from_header`   | The from addresses found in the message itself and will be listed separated by a comma. This is sent as a JSON representation of an Array of emails (e.g. "[\"joe@domain.com\", \"jane@domain.com\"]").
| `x_sender`        | This will send the x-sender header from the mail message if it is present. This parameter will likely always be experimental as only some servers will include this header. |
| `subject`         | The subject of the message extracted from the message itself. |
| `x_forwarded_for `| This will send the x-forwarded-for header from the mail message if it is present. This is often included by forwarding email servers to show the original to address the message was sent to. This parameter will likely always be experimental as only some servers will include this header.
| `reply_plain`     | The plain text reply extracted from this message is present / found. |
| `signature`       | The signature of the message encoded with your private key. You can use this to ensure that the HTTP POST data has come from CloudMailin. See [here](#validating_the_sender) for more details.
| `spf`             | The [SPF](/features/spf/) result for the given IP address and Domain. Passed as `spf['result']` and `spf['domain']`. |

## Attachments

It is possible to have CloudMailin extract the attachments from your email and send those attachments directly to an attachment store (S3 bucket).

With this format if you do not use an attachment store then attachments will remain nested within the email itself.
You can parse the attachments yourself from the `message` parameter.
If you wish to have attachments parsed and sent directly to your app we suggest you look at the other [http_post_formats](/http_post_formats/).
However, if you choose to use an attachment store the following additional parameters will be delivered:

| Parameter                           | Description                              |
|--------------------------------------------------------------------------------|
| `attachments[index][file_name]`     | The original file name of the attachment |
| `attachments[index][content_type]`  | The content type of the attachment |
| `attachments[index][url]`           | The url of the file uploaded to S3. This can be used to extract the bucket, path and filename if required. |
| `attachments[index][size]`          | The length of the attachment store in S3 sent in bytes |
| `attachments[index][disposition]`   | The content disposition of the attachment. This is useful for determining if the attachment was inline. *Note:* this will only be passed if the disposition is **not attachment** |

Index refers to the current attachment number starting at 0.

Some frameworks will automatically extract these nested parameters using the brackets into an array or hash. In Rails for example these attachments will form a hash like the following:

    {'attachments' => {'0' => {'file_name' => 'test.jpg'}}}
    puts params[:attachments]['0'][:file_name] #outputs test.jpg

More details about configuring attachments to be sent directly to an attachment store can be found [here](/receiving_email/attachments/).

## Validating the Sender

For more details about ensuring only CloudMailin can post to your HTTP URL see [Securing your message target](/receiving_email/securing_your_email_url_target/).
