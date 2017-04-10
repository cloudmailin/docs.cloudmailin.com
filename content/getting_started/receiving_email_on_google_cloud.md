---
title: Receiving Email on Google Cloud
name: Getting Started on Google Cloud Platform
---

# Receiving email within the Azure Cloud Platform

Google has an amazing history in Cloud computing and it's Cloud Platform is no different.
From compute to machine learning Google has some really interesting offerings.

[CloudMailin](http://www.cloudmailin.com/). is a tool for developers to make it easy to receive
email via a API WebHook.
You send CloudMailin an email and it will come as an HTTP POST to your site. Leaving you free
to do what you do best and not having to worry about managing email servers.

CloudMailin was designed from the ground up to work well with Cloud and allows you to easily scale
up email receiving needs as demand increases.

## Storing Email Attachments in Google Cloud Storage

CloudMailin can automatically send message attachments to Google Cloud Storage. We call this
feature [Attachment Stores](/receiving_email/attachments/).
This offloads the handling of attachments and can really reduce the burden on your API.
The rest of the email is sent to your website, without having to receive the attachment as well.

This can help improve performance but also makes it much faster to get started with CloudMailin.

In addition we have the ability to store the entire email, either RAW or in JSON form in
Google Cloud Storage.

In order to enable this feature or if you want more details please
[contact us](http://www.cloudmailin.com/contact_us).

## Regions and Setup

CloudMailin contacts your servers via HTTP POST, making it fully independent of the Cloud used.
It is however, possible to create dedicated servers within the Google infrastructure in order to
reduce latency or to prevent content leaving a specific region if your application requires it.

Google Cloud Storage is available in the following regions, we can support placing attachments or
dedicated servers into the following zones.

| Region                  | Name            |
|:------------------------|:----------------|
| Council Bluffs, IA      | us-central1     |
| Berkeley County, SC     | us-east1        |
| The Dalles, OR          | us-west1        |
| St. Ghislain, Belgium   | europe-west1    |
| Changhua County, Taiwan | asia-east1      |
| Tokyo, Japan            | asia-northeast1 |

### Other regions

We're quickly adding support for other regions so
[contact us](http://www.cloudmailin.com/contact_us)
if your preferred region isn't available.

## Getting Started

We also recommend you look at our general [Getting Started Guide](/getting_started/) as it explains
in more detail how you will be sent messages, how the HTTP Status codes you respond with affect the
message delivery and walks you through receiving your first email.

## Adding Some Code

We recommend taking a look at our [HTTP POST Formats](/http_post_formats/). These show the format
of the webhook POST to your website and some sample code to get started.

## Contact Us
If you need any help [contact us](http://www.cloudmailin.com/contact_us) and we can help you
get setup receiving email with the Google Cloud Platform.
