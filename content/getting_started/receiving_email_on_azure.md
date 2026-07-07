---
title: Receiving Email on Azure
name: Getting Started on Azure
description:
  How to receive email in Azure. CloudMailin delivers inbound messages as an
  HTTP POST to Azure Functions, Container Apps, or App Service, and can
  store attachments or full messages directly in Blob Storage.
---

# Receiving Email on Azure

[CloudMailin](https://www.cloudmailin.com) receives email on your behalf and
delivers each message to your application as an HTTP POST. There's no mail
server to run, patch, or scale anywhere in Azure.

## Receiving Email into Serverless Azure Compute

Because delivery is a standard HTTPS POST, the target can be any publicly
reachable endpoint in your Azure subscription, including:

* An [Azure Functions HTTP trigger](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger)
* A Container App or an App Service Web App
* A Logic App with an HTTP request trigger

No CloudMailin-specific SDK or library is required. Your endpoint just needs
to return an HTTP status code, see [HTTP Status Codes](/receiving_email/http_status_codes/)
for how each code affects delivery, and [HTTP POST Formats](/http_post_formats/)
for the request body itself.

## Storing Attachments and Full Messages in Azure Blob Storage

CloudMailin can write message attachments, or the entire message in raw or
JSON form, directly to an Azure Blob Storage container instead of, or as
well as, posting them to your endpoint. This keeps large attachments off
your webhook, and because Blob Storage events can be routed through Event
Grid, it also lets you trigger an Azure Function directly from the blob
being created rather than from the webhook.

* [Sending attachments to Azure Blob Storage](/receiving_email/store-email-attachments-in-s3-azure-google-storage/#sending-email-attachments-to-azure-storage)
* [Sending the full message to Azure Blob Storage](/receiving_email/store-full-email-in-aws-cloud-storage/#send-the-full-email-to-azure-blob-storage)

## Regions, Latency, and Data Residency

### Where Your Email Is Received

When you receive email on your own custom domain, the MX records point at
CloudMailin's shared, multi-tenant clusters. These run on AWS rather than
Azure, split across three regions:

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

### Azure Regions

CloudMailin's delivery infrastructure reaches your application over HTTPS,
so it works exactly the same regardless of which Azure region your
application runs in, including all of the following:

#### Americas

| Region           | Location    |
|-------------------|------------|
| East US           | Virginia          |
| East US 2         | Virginia          |
| Central US        | Iowa              |
| North Central US  | Illinois          |
| South Central US  | Texas             |
| West Central US   | Wyoming           |
| West US           | California        |
| West US 2         | Washington        |
| West US 3         | Phoenix           |
| Canada Central    | Toronto           |
| Canada East       | Quebec            |
| Mexico Central    | Querétaro State   |
| Brazil South      | Sao Paulo State   |
| Chile Central     | Santiago          |

#### Europe

| Region            | Location    |
|-------------------|-------------|
| North Europe      | Ireland     |
| West Europe       | Netherlands |
| UK South          | London      |
| UK West           | Cardiff     |
| Germany West Central | Frankfurt |
| France Central    | Paris       |
| Italy North       | Milan       |
| Spain Central     | Madrid      |
| Poland Central    | Warsaw      |
| Sweden Central    | Gävle       |
| Norway East       | Norway      |
| Switzerland North | Zurich      |
| Austria East      | Vienna      |
| Belgium Central   | Brussels    |
| Denmark East      | Copenhagen  |

#### Middle East and Africa

| Region         | Location    |
|----------------|-------------|
| UAE North      | Dubai       |
| Qatar Central  | Doha        |
| Israel Central | Israel      |
| South Africa North | Johannesburg |

#### Asia Pacific

| Region              | Location        |
|---------------------|-----------------|
| Southeast Asia      | Singapore       |
| East Asia           | Hong Kong       |
| Australia East      | New South Wales |
| Australia Southeast | Victoria        |
| Central India       | Pune            |
| South India         | Chennai         |
| West India          | Mumbai          |
| Japan East          | Tokyo, Saitama  |
| Japan West          | Osaka           |
| Korea Central       | Seoul           |
| Korea South         | Busan           |
| Malaysia West       | Kuala Lumpur    |
| Indonesia Central   | Jakarta         |
| New Zealand North   | Auckland        |
| Australia Central  | Canberra         |

### Dedicated Servers

[Dedicated servers](https://www.cloudmailin.com/plans-and-pricing) provide
a single-tenant CloudMailin instance. Like the shared clusters, dedicated
servers run on AWS — see the
[available AWS regions](/getting_started/receiving_email_on_aws/#dedicated-servers)
for the full list. If your application runs on Azure and you'd like one,
[contact us] and we'll set it up in the AWS region closest to your Azure
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
email in Azure.
