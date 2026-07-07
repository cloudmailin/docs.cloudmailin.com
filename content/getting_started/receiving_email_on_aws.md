---
title: Receiving Email on AWS
name: Getting Started on AWS
description:
  How to receive email in AWS. CloudMailin delivers inbound messages as an
  HTTP POST to Lambda, ECS, or EC2, and can store attachments or full
  messages directly in S3.
---

# Receiving Email on AWS

[CloudMailin](https://www.cloudmailin.com) receives email on your behalf and
delivers each message to your application as an HTTP POST. There's no mail
server to run, patch, or scale on EC2 or anywhere else in AWS.

## Receiving Email into Serverless AWS Compute

Because delivery is a standard HTTPS POST, the target can be any publicly
reachable endpoint in your AWS account, including:

* A [Lambda function URL](https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html)
  or a route behind API Gateway
* A container on ECS, Fargate, or App Runner
* An EC2 instance behind a load balancer

No CloudMailin-specific SDK or library is required. Your endpoint just needs
to return an HTTP status code, see [HTTP Status Codes](/receiving_email/http_status_codes/)
for how each code affects delivery, and [HTTP POST Formats](/http_post_formats/)
for the request body itself.

## Storing Attachments and Full Messages in S3

CloudMailin can write message attachments, or the entire message in raw or
JSON form, directly to an S3 bucket instead of, or as well as, posting them
to your endpoint. This keeps large attachments off your webhook, and because
S3 can emit an event notification for each object created, it also lets you
trigger a Lambda function directly from the object landing in the bucket
rather than from the webhook.

* [Sending attachments to S3](/receiving_email/store-email-attachments-in-s3-azure-google-storage/#how-can-i-send-email-attachments-to-aws-s3)
* [Sending the full message to S3](/receiving_email/store-full-email-in-aws-cloud-storage/#send-the-full-email-to-aws-s3)

## AWS Regions

CloudMailin's delivery infrastructure reaches your application over HTTPS,
so it works the same regardless of which AWS region your application runs
in.

### Where Your Email Is Received

If you're receiving email on your own custom domain, the MX records point at
CloudMailin's shared clusters — all hosted on AWS, split across three
regions:

| Cluster | AWS Region     | MX Record                |
|---------|----------------|---------------------------|
| US      | us-east-1      | `client1.cloudmailin.net` |
| EU      | eu-west-1      | `client2.cloudmailin.net` |
| AP      | ap-southeast-2 | `client3.cloudmailin.net` |

By default `cloudmailin.net` uses all three and weights MX priority toward
whichever cluster is closest to your DNS resolver. If you need your email
handled in a specific region — for example, entirely within the EU — set
your domain's MX records to point only at that cluster
(`client2.cloudmailin.net` for the EU). This works on the shared clusters;
no dedicated server is required. See
[Selecting the Region](/receiving_email/using-your-own-domain/#selecting-the-region)
for the full MX record setup instructions.

### Dedicated Servers

[Dedicated servers](https://www.cloudmailin.com/plans-and-pricing) offer
additional flexibility, for example restricting traffic so that it never
leaves the EU. [Contact us] to confirm current availability in your
preferred AWS region.

| AWS Region                | Region Code    |
|:---------------------------|:---------------|
| US East (N. Virginia)      | us-east-1      |
| US East (Ohio)             | us-east-2      |
| US West (N. California)    | us-west-1      |
| US West (Oregon)           | us-west-2      |
| Canada (Central)           | ca-central-1   |
| Canada West (Calgary)      | ca-west-1      |
| Mexico (Central)           | mx-central-1   |
| South America (São Paulo)  | sa-east-1      |
| Europe (Ireland)           | eu-west-1      |
| Europe (London)            | eu-west-2      |
| Europe (Paris)             | eu-west-3      |
| Europe (Frankfurt)         | eu-central-1   |
| Europe (Zurich)            | eu-central-2   |
| Europe (Stockholm)         | eu-north-1     |
| Europe (Milan)             | eu-south-1     |
| Europe (Spain)             | eu-south-2     |
| Middle East (Bahrain)      | me-south-1     |
| Middle East (UAE)          | me-central-1   |
| Israel (Tel Aviv)          | il-central-1   |
| Africa (Cape Town)         | af-south-1     |
| Asia Pacific (Mumbai)      | ap-south-1     |
| Asia Pacific (Hyderabad)   | ap-south-2     |
| Asia Pacific (Singapore)   | ap-southeast-1 |
| Asia Pacific (Sydney)      | ap-southeast-2 |
| Asia Pacific (Jakarta)     | ap-southeast-3 |
| Asia Pacific (Melbourne)   | ap-southeast-4 |
| Asia Pacific (Malaysia)    | ap-southeast-5 |
| Asia Pacific (New Zealand) | ap-southeast-6 |
| Asia Pacific (Thailand)    | ap-southeast-7 |
| Asia Pacific (Tokyo)       | ap-northeast-1 |
| Asia Pacific (Seoul)       | ap-northeast-2 |
| Asia Pacific (Osaka)       | ap-northeast-3 |
| Asia Pacific (Hong Kong)   | ap-east-1      |
| Asia Pacific (Taipei)      | ap-east-2      |

We also recommend you look at our general
[Getting Started Guide](/getting_started/) as it explains in more detail how
you will be sent messages, how the HTTP Status codes you respond with affect
message delivery, and walks you through receiving your first email.

## Adding Some Code

We recommend taking a look at our [HTTP POST Formats](/http_post_formats/).
These show the format of the webhook POST to your website and some sample
code to get started.

## Contact Us

If you need any help [contact us] and we can help you get set up receiving
email on AWS.
