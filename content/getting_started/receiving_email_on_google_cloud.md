---
title: Receiving Email on Google Cloud (GCP)
name: Getting Started on Google Cloud Platform
description:
  How to receive email on Google Cloud (GCP). CloudMailin delivers inbound
  messages as an HTTP POST to Cloud Functions, Cloud Run, or Compute Engine,
  and can store attachments or full messages directly in Cloud Storage.
---

# Receiving Email on Google Cloud Platform (GCP)

[CloudMailin](https://www.cloudmailin.com/) receives email on your behalf
and delivers each message to your application as an HTTP POST. There's no
mail server to run, patch, or scale anywhere on Google Cloud.

## Receiving Email into Serverless Google Cloud Compute

Because delivery is a standard HTTPS POST, the target can be any publicly
reachable endpoint in your GCP project, including:

* A [Cloud Functions](https://cloud.google.com/functions) HTTP-triggered
  function
* A Cloud Run service
* A Compute Engine instance behind a load balancer

No CloudMailin-specific SDK or library is required. Your endpoint just needs
to return an HTTP status code, see [HTTP Status Codes](/receiving_email/http_status_codes/)
for how each code affects delivery, and [HTTP POST Formats](/http_post_formats/)
for the request body itself.

## Storing Attachments and Full Messages in Google Cloud Storage

CloudMailin can write message attachments, or the entire message in raw or
JSON form, directly to a Cloud Storage bucket instead of, or as well as,
posting them to your endpoint. This keeps large attachments off your
webhook, and because Cloud Storage can emit an event through Eventarc, it
also lets you trigger a Cloud Function or Cloud Run service directly from
the object being created rather than from the webhook.

* [Sending attachments to Google Cloud Storage](/receiving_email/store-email-attachments-in-s3-azure-google-storage/#sending-email-attachments-to-google-cloud-storage)
* [Sending the full message to Google Cloud Storage](/receiving_email/store-full-email-in-aws-cloud-storage/#send-the-full-email-to-google-cloud-storage)

## Regions, Latency, and Data Residency

### Where Your Email Is Received

When you receive email on your own custom domain, the MX records point at
CloudMailin's shared, multi-tenant clusters. These run on AWS rather than
Google Cloud, split across three regions:

| Cluster | AWS Region     | MX Record                 |
|---------|----------------|---------------------------|
| US      | us-east-1      | `client1.cloudmailin.net` |
| EU      | eu-west-1      | `client2.cloudmailin.net` |
| AP      | ap-southeast-2 | `client3.cloudmailin.net` |

By default all three clusters are used, with MX priority weighted toward
the cluster closest to your DNS resolver. If you need your email handled in
a specific region — for example, entirely within the EU — set your domain's
MX records to point only at that cluster (`client2.cloudmailin.net` for the
EU). This works on the shared clusters at no extra cost; no dedicated
server is required.
See [Selecting the Region](/receiving_email/using-your-own-domain/#selecting-the-region)
for the MX record setup.

The cross-cloud hop isn't something you need to worry about: delivery is a
standard HTTPS POST over the public internet rather than a private in-cloud
call, so it adds a few milliseconds at most — negligible next to your own
application's response time.

### Google Cloud Regions

CloudMailin's delivery infrastructure reaches your application over HTTPS,
so it works exactly the same regardless of which Google Cloud region your
application runs in, including all of the following:

#### Americas

| Region                  | Location                    |
|:------------------------|:-----------------------------|
| us-central1             | Council Bluffs, Iowa         |
| us-east1                | Moncks Corner, South Carolina|
| us-east4                | Ashburn, Virginia            |
| us-east5                | Columbus, Ohio               |
| us-south1               | Dallas, Texas                |
| us-west1                | The Dalles, Oregon           |
| us-west2                | Los Angeles, California      |
| us-west3                | Salt Lake City, Utah         |
| us-west4                | Las Vegas, Nevada            |
| northamerica-northeast1 | Montréal, Canada             |
| northamerica-northeast2 | Toronto, Canada              |
| southamerica-east1      | São Paulo, Brazil            |
| southamerica-west1      | Santiago, Chile               |

#### Europe

| Region            | Location             |
|:-------------------|:--------------------|
| europe-west1       | St. Ghislain, Belgium |
| europe-west2       | London, UK           |
| europe-west3       | Frankfurt, Germany   |
| europe-west4       | Eemshaven, Netherlands |
| europe-west6       | Zurich, Switzerland  |
| europe-west8       | Milan, Italy         |
| europe-west9       | Paris, France        |
| europe-west10      | Berlin, Germany      |
| europe-west12      | Turin, Italy         |
| europe-north1      | Hamina, Finland      |
| europe-central2    | Warsaw, Poland       |
| europe-southwest1  | Madrid, Spain        |

#### Middle East and Africa

| Region        | Location             |
|:---------------|:--------------------|
| me-central1    | Doha, Qatar          |
| me-central2    | Dammam, Saudi Arabia |
| me-west1       | Tel Aviv, Israel     |
| africa-south1  | Johannesburg, South Africa |

#### Asia Pacific

| Region                  | Location                     |
|:------------------------|:------------------------------|
| asia-east1              | Changhua County, Taiwan       |
| asia-east2              | Hong Kong                     |
| asia-northeast1         | Tokyo, Japan                  |
| asia-northeast2         | Osaka, Japan                  |
| asia-northeast3         | Seoul, South Korea            |
| asia-south1             | Mumbai, India                 |
| asia-south2             | Delhi, India                  |
| asia-southeast1         | Jurong West, Singapore        |
| asia-southeast2         | Jakarta, Indonesia            |
| australia-southeast1    | Sydney, Australia             |
| australia-southeast2    | Melbourne, Australia          |

### Dedicated Servers

[Dedicated servers](https://www.cloudmailin.com/plans-and-pricing) provide
a single-tenant CloudMailin instance. Like the shared clusters, dedicated
servers run on AWS — see the
[available AWS regions](/getting_started/receiving_email_on_aws/#dedicated-servers)
for the full list. If your application runs on Google Cloud and you'd like
one, [contact us] and we'll set it up in the AWS region closest to your GCP
deployment.

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
email with Google Cloud Platform.
