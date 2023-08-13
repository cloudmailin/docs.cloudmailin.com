---
title: Storing Email Attachments in AWS S3 with a bucket policy
description:
  CloudMailin allows you to store large email attachments in Amazon Web
  Services (AWS) S3 whilst using an access control list is simpler to
  setup a bucket policy is also possible.
---

# Storing Email Attachments in AWS S3 with a bucket policy

Whilst this documentation recommends using an [access control list] to control
access to your S3 bucket it is also possible to use a bucket policy.

## Creating a bucket policy

In order to provide CloudMailin access you'll need to allow `s3:PutObject`
permission to the CloudMailin canonical ID. The ID is:
`83fec836f8a832fae9c46e100739b635be3b3636d14887e1c7616e2dba1a88c0`.

Below is an example of a bucket policy providing this permission. You may need
to adapt this to allow things such as your application to read the bucket and
its objects.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantWriteAccessToSpecificCanonicalUser",
            "Effect": "Allow",
            "Principal": {
                "CanonicalUser": "83fec836f8a832fae9c46e100739b635be3b3636d14887e1c7616e2dba1a88c0"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*"
        }
    ]
}
```

> Remember to replace `YOUR_BUCKET_NAME` with the name of your bucket.

If you have any questions relating to this please feel free to [contact us].

[access control list]: /receiving_email/store-email-attachments-in-s3-azure-google-storage
