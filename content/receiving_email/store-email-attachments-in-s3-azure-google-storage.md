---
title: Storing Email Attachments in AWS S3, Azure, or Google Storage
description:
  CloudMailin allows you to store large email attachments in Amazon Web
  Services (AWS) S3, Microsoft Azure Blob Storage, or Google Cloud Storage.
  Emails are fully parsed and delivered with a URL containing the location of
  the uploaded file.
---

# Store Email Attachments in AWS S3, Azure Blob Storage, or Google Cloud Storage

In order to save overhead on your HTTP server CloudMailin can transfer your
attachments directly to Amazon Web Services (AWS) S3, Microsoft Azure Blob
Storage or Google Cloud Storage.

CloudMailin allows sending email attachments to:

* [Amazon Web Services (AWS) S3]
* [Microsoft Azure Blob Storage]
* [Google Cloud Platform Cloud Storage]

> Bucket names are now forced to DNS-safe form (lower-case letters, digits,
> hyphens). S3 no longer accepts underscores and GCS buckets with underscores
> break TLS-based hostname access, CloudMailin no longer supports underscores in
> bucket names.

## Why send email attachments to Cloud Storage?

When a large attachment, or multiple attachments, are included within an email
message the amount of data sent to the target website can become quite large.
The overhead can become even larger because emails are often encoded using
Base64 for binary content such as images.

This can lead to **considerable transfer and processing time** on your web
server and can often result in timeouts or unreachable errors as the server
cannot cope with receiving that amount of data. In addition, this overhead can
prevent other requests from reaching the server.

It's also common for HTTP such as Nginx or Apache to prevent sending large HTTP
POSTs (over 1MB by default in Nginx) with a `413: Request Entity Too Large`
error.

CloudMailin has the ability to extract the attachments from your email and
deliver them to Amazon Web Service's (AWS) S3, Microsoft Azure Blob Storage or
Google Cloud Storage. This means that your web server only receives the HTTP
data that it needs to. Instead pass the URL of the attachments that were
extracted from the email.

## How can I send Email Attachments to AWS S3

It is possible to configure CloudMailin to stream message attachments to
Amazon's S3 as an email is received. This can help reduce the overhead on the
end server and allow you to easily save away the attachments sent by your
customers. In order to set up S3 attachments:

### Grant permission to send email attachments to your S3 Bucket

There are several ways that you can grant permission for CloudMailin to create
files in your S3 Bucket. The simplest is to use the AWS website.

1. Go to the AWS Management Console
   [https://console.aws.amazon.com](https://console.aws.amazon.com) and Sign in.
2. Click on the S3 Tab, then select your bucket (or create a new one)
    ![The S3 Tab](/content/assets/images/s3/list-aws-services-s3.png)
3. Click on permissions the button
    ![The S3 Permissions Tab](/content/assets/images/s3/permissions-tab.png)
4. Scroll down to the Access control list (ACL) panel
    ![The S3 Permissions ACL](/content/assets/images/s3/s3-permissions-acl.png)
5. Click `Edit` and then `Add grantee`
    ![The S3 Permissions
    Tab](/content/assets/images/s3/add-canonical-id.png)
6. In the `grantee` field from above, paste the CloudMailin Canonical ID,
    choose `write` and then save

> AWS Canonical ID: `83fec836f8a832fae9c46e100739b635be3b3636d14887e1c7616e2dba1a88c0`

You should now have granted CloudMailin permission to add files to your S3
bucket.

Next we need to [configure CloudMailin] to send email attachments to S3.

If you have any questions feel free to [contact us].

## Sending Email Attachments to Azure Storage

It's possible to configure CloudMailin to send attachments directly to Azure
Blob storage whenever an email is received.

### Grant permission to send email attachments to Azure Blob Storage

1. Create a new `Container` in the Azure Blob Service panel in your Azure
   Storage Account.
   ![Create Azure blob storage container](/content/assets/images/azure-blob-storage/create_storage_container.png)
2. Go to Settings and then `Shared Access Signature` (SAS).
3. Generate a SAS URL for the `Blob` service with `Object` and `Write`
   permission and select the start and end dates for the signature. You'll need
   a large enough date range to provide CloudMailin continued access to the
   container.
   ![Create a Shared Access Signature URL](/content/assets/images/azure-blob-storage/create_sas_url.png)
4. Once you've generated the URL you'll need to save a copy of the full
   `SAS URL`.

> Be sure to select a large enough date range for continued use with
> CloudMailin.

You should now have granted CloudMailin permission to add files to your Azure
Blob Service container.

Next we need to [configure CloudMailin] to send email attachments to Azure.

If you have any questions feel free to [contact us].

## Sending Email Attachments to Google Cloud Storage

It's possible to configure CloudMailin to send attachments directly to Google
Cloud storage whenever an email is received.

### Grant permission to send email attachments to Google Cloud Storage

You'll need to grant access to your storage bucket for us to be able to send
attachments to your bucket.

1. Head to the Google Cloud Platform management page and go to Storage.
2. Create a new `Bucket` or edit your existing bucket.
   ![Create Azure blob storage container](/content/assets/images/google-cloud-storage/create_google_cloud_storage.png)
3. Click on the `Permissions Tab` and select `Add` to add a member to the
   permissions tab.
4. Grant the CloudMailin Service Account (below) `Storage Object Creator` permission to
   allow the creation of new Storage Objects.
   ![Create Azure blob storage container](/content/assets/images/google-cloud-storage/add_upload_permission.png)

> The CloudMailin service account that you need to grant permission is:
> `uploads@cloudmailin-uploads.iam.gserviceaccount.com`

Next we need to [configure CloudMailin] to send email attachments to Google
Cloud Platform.

If you have any questions feel free to [contact us].

## Setting up CloudMailin

Now that you've configured your Cloud Storage provider you'll need to configure CloudMailin to send attachments to your storage provider.

![CloudMailin configuration showing ](/content/assets/images/email-attachment-s3-storage-cloudmailin-config.png)

1. Go to your CloudMailin email [address list] and select the address you wish
   to configure.
2. Click `Add Attachment Store` and select your storage provider.
3. You'll now need to enter the credentials you used when setting up your
   storage provider.
   * For amazon enter your Amazon Web Services (AWS) S3 bucket name and an
     optional path to place before each file. In the format
     `bucket_name/path_prefix`. You'll also need to add your S3 Bucket region
     and the AWS Canned ACL that you wish to use.
   * For Azure enter your Azure Blob Storage container name and the full SAS URL
     that you generated above.
   * For Google Cloud Platform enter your Google Cloud Storage bucket name and
     an optional path to place before each file. In the format
     `bucket_name/path_prefix`.
4. Click `Save` and you're done, CloudMailin will write a test file to your
   storage account to check permissions.

CloudMailin will upload attachments using a random filename generated by our
system. This is because we don't wish to require read access, only write access,
to a bucket and we therefore cannot check if a file already exists. Although it
is unlikely it is theoretically possible that we could generate the same
filename twice. If this is a concern you should move the files once you receive
the url from our servers.

Once this is configured correctly you will see an additional attachments
parameter being passed with the content type, url and original file name of your
attachments. For more details about the attachment format see the documentation
on the [HTTP Post Formats](/http_post_formats/).

[Amazon Web Services (AWS) S3]: #how-can-i-send-email-attachments-to-aws-s3
[Microsoft Azure Blob Storage]: #sending-email-attachments-to-azure-storage
[Google Cloud Platform Cloud Storage]: #sending-email-attachments-to-google-cloud-storage
[address list]: https://www.cloudmailin.com/addresses
[Configure CloudMailin]: #setting-up-cloudmailin
