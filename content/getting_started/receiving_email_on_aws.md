---
title: Receiving Email on AWS
name: Getting Started on AWS
---

# Getting Started On AWS

AWS provides a number of Cloud Services and is a perfect fit for building your API.

[CloudMailin](http://www.cloudmailin.com) allows you to receive incoming email on AWS without having
to manage and configure email servers.

CloudMailin was designed from the ground up to work well with AWS and allows you to easily scale up
your email receiving needs as demand increases.

## Storing Email Attachments in S3

CloudMailin can automatically send message attachments to Amazon's S3. We call this feature
[Attachment Stores](/receiving_email/attachments/).
This offloads the handling of attachments and can really reduce the burden on your API.
The rest of the email is sent to your website, without having to receive the attachment as well.

This can help improve performance but also makes it much faster to get started with CloudMailin.

In addition we have the ability to store the entire email, either RAW or in JSON form in S3.
This can allow you to create systems that work with email in queue form or using technologies such
as AWS Lambda.

See the section on [Attachment Stores](/receiving_email/attachments/) for more details or
[contact us](http://www.cloudmailin.com/contact_us) to enable sending the entire email to S3.

## AWS Regions

Because CloudMailin makes a standard HTTP POST request with the content of your email it's able to
work from any AWS region without the need for specific changes.

### Custom Domains

By default CloudMailin operates two clouds, when you setup incoming email on your own domain you can
include one or both or these regions:

| Cloud  | Location                                      |
|--------|-----------------------------------------------|
| cloud1 | AWS (us-east-1)                               |
| cloud2 | Brightbox UK (EU only Cloud), AWS (eu-west-1) |

### Dedicated Servers

[Dedicated servers](http://www.cloudmailin.com/plans) offer additional flexiblity.
This can be especially useful if you want to restrict traffic so that it never leaves the EU for
example. Dedicated servers can be placed into any of the following regions:

| AWS Region                | Region Name    |
|:--------------------------|:---------------|
| US East (N. Virginia)     | us-east-1      |
| US East (Ohio)            | us-east-2      |
| US West (N. California)   | us-west-1      |
| US West (Oregon)          | us-west-2      |
| Canada (Central)          | ca-central-1   |
| Asia Pacific (Mumbai)     | ap-south-1     |
| Asia Pacific (Seoul)      | ap-northeast-2 |
| Asia Pacific (Singapore)  | ap-southeast-1 |
| Asia Pacific (Sydney)     | ap-southeast-2 |
| Asia Pacific (Tokyo)      | ap-northeast-1 |
| EU (Frankfurt)            | eu-central-1   |
| EU (Ireland)              | eu-west-1      |
| EU (London)               | eu-west-2      |
| South America (São Paulo) | sa-east-1      |

We also recommend you look at our general [Getting Started Guide](/getting_started/) as it explains
in more detail how you will be sent messages, how the HTTP Status codes you respond with affect the
message delivery and walks you through receiving your first email.

## Adding Some Code

We recommend taking a look at our [HTTP POST Formats](/http_post_formats/). These show the format
of the webhook POST to your website and some sample code to get started.

## Contact Us
If you need any help [contact us](http://www.cloudmailin.com/contact_us) and we can help you
get setup receiving email on the Amazon Web Services platform.
