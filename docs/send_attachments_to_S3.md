Sending Email Attachments to Amazon S3
=

#Sending Email Attachments to Amazon S3
#-

It is possible to configure CloudMailin to send message attachments to Amazons S3 as an email is received.
This can help reduce the overhead on the end server and allow you to easily save away the attachments sent by your customers.

In order to set up S3 attachments:

1. Log into your [address dashboard](http://cloudmailin.com/addresses) and choose the address you wish to manage.
2. Select add attachment store.
3. Enter your amazon S3 bucket name and an optional path to place before each file. In the format bucket_name/path_prefix.
4. Make sure you give write access for CloudMailin to your Amazon S3 bucket from the Amazon AWS dashboard.

In order for this to work you must give write access to your bucket to the following Amazon Canonical ID:

    AWS Canonical ID: 83fec836f8a832fae9c46e100739b635be3b3636d14887e1c7616e2dba1a88c0

Once this is configured correctly you will see an additional attachments parameter being passed with the content type, url and original file name of your attachments.
For more details about the attachment format see the documentation on the [HTTP Post Format](post_format#attachments).