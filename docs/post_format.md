Receiving the mail at the target
=

#The HTTP POST format and multipart/form-data
#-

When an email arrives at the CloudMailin server, an HTTP **POST** will be sent as a _multipart/form-data_ request with the following parameters:

* _message_ - The message itself. This will be the entire message and will need to be manually parsed by your code. Take a look at the [parsing email](parsing_email) documentation to see how you can do this if you are not familiar with email messages.

* _plain_ - The plain text extracted from the raw message. This will be the first text/plain part of the email if the message is multipart and the body if the content is not multipart.

* _html_ - The html text extracted from the raw message. This will be the first text/html part of an email if the message is multipart.

* _to_ - The recipient as specified by the server. This will be the CloudMailin email address. This could be different to the _TO_ address specified in the message itself. If you are forwarding email from your domain you will want to extract the recipient from the email.

* _disposable_ - The disposable part of the email address if it exists. For example if your email address was example+something@example.com, the disposable would contain 'something'.

* _from_ - The sender as specified by the server. This can differ from the sender specified within the message.

* _subject_ - The subject of the message extracted from the message itself.

* _signature_ - The signature of the message encoded with your private key. You can use this to ensure that the HTTP POST data has come from CloudMailin. See [here](validating_the_sender) for more details.

**Note**: The message is not sent as a file. Instead it is as if the user pasted the message contents into a textfield.

For more details relating to parsing the message click [here](parsing_email).

### Experimental Parameters
There are a couple of experimental parameters that have the possibility of changing or may not be present with every request. They are as follows:

* _x_forwarded_for_ - This will send the x-forwarded-for header from the mail message if it is present. This is often included by forwarding email servers to show the original to address the message was sent to. This parameter will likely always be experimental as only some servers will include this header.

* _x_sender_ - This will send the x-sender header from the mail message if it is present. This parameter will likely always be experimental as only some servers will include this header.

* _x_header_to_ - This is a new header that is being tested and we would appreciate feedback for. The to addresses found in the message header will be listed separated by a comma.

* _x_header_cc_ - This is a new header that is being tested and we would appreciate feedback for. The CC addresses found in the message header will be listed separated by a comma.

## Attachments
It is possible to have CloudMailin extract the attachments from your email and send those attachments directly to an S3 bucket.
If you choose to use this functionality the following additional parameters will be delivered with index being the number of the current attachment.

* _attachments[index][file_name]_ - The original file name of the attachment

* _attachments[index][content_type]_ - The content type of the attachment

* _attachments[index][url]_ - The url of the file uploaded to S3. This can be used to extract the bucket, path and filename if required.

* _attachments[index][size]_ - The length of the attachment store in S3 sent in bytes

* _attachments[index][disposition]_ - The content disposition of the attachment. This is useful for determining if the attachment was inline. *Note:* this will only be passed if the disposition is **not attachment**

Some frameworks will automatically extract these nested parameters using the brackets into an array or hash. In Rails for example these attachments will form a hash like the following:
    {'attachments' => {'0' => {'file_name' => 'test.jpg'}}}
    puts params[:attachments]['0'][:file_name] #outputs test.jpg
    
More details about configuring S3 attachments can be found [here](send_attachments_to_S3).
