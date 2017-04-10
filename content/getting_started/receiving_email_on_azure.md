---
title: Receiving Email on Azure
name: Getting Started on Azure
---

# Receiving email within the Azure Cloud

[Azure](https://azure.microsoft.com/) provides a number of Cloud Services but it can be difficult
to receive email within a Cloud environment.

Many of the on-premise options aren't available in the Cloud and scale can become more of an issue.

[CloudMailin](http://www.cloudmailin.com) is a Cloud solution for developers that allows you to
receive any volume of incoming email, directly to your website in the Cloud via HTTP POST.

CloudMailin was designed from the ground up to work well with Cloud and allows you to easily scale
up email receiving needs as demand increases.

## Storing Email Attachments in Azure Storage

CloudMailin can automatically send message attachments to Azure's Cloud Storage. We call this
feature [Attachment Stores](/receiving_email/attachments/).
This offloads the handling of attachments and can really reduce the burden on your API.
The rest of the email is sent to your website, without having to receive the attachment as well.

This can help improve performance but also makes it much faster to get started with CloudMailin.

In addition we have the ability to store the entire email, either RAW or in JSON form in
Azure Storage.

In order to enable this feature or if you want more details please
[contact us](http://www.cloudmailin.com/contact_us).

## Regions and Setup

CloudMailin isn't specific to a single region. Because CloudMailin makes an HTTP POST to your site
it will work with any Azure Cloud region ([HTTP POST Formats](/http_post_formats/)).

We also know that sometimes jurisdictions require that data doesn't pass across certain borders.
The CloudMailin system can be configured to enable this, a key example being keeping data
within the EU.

In order to allow this we have the ability to create dedicated servers in the following locations:

#### Americas

| Region           | Location        |
|------------------|-----------------|
| East US          | Virginia        |
| East US 2        | Virginia        |
| Central US       | Iowa            |
| North Central US | Illinois        |
| South Central US | Texas           |
| West Central US  | West Central US |
| West US          | California      |
| West US 2        | West US 2       |
| Canada East      | Quebec City     |
| Canada Central   | Toronto         |
| Brazil South     | Sao Paulo State |

#### Europe

| Region            | Location       |
|-------------------|----------------|
| North Europe      | Ireland        |
| West Europe       | Netherlands    |
| Germany Central   | Frankfurt      |
| Germany Northeast | Magdeburg      |
| UK West           | Cardiff        |
| UK South          | London         |
| France Central    | France Central |
| France South      | France South   |

#### Asia Pacific

| Region              | Location        |
|---------------------|-----------------|
| Southeast Asia      | Singapore       |
| East Asia           | Hong Kong       |
| Australia East      | New South Wales |
| Australia Southeast | Victoria        |
| China East          | Shanghai        |
| China North         | Beijing         |
| Central India       | Pune            |
| West India          | Mumbai          |
| South India         | Chennai         |
| Japan East          | Tokyo, Saitama  |
| Japan West          | Osaka           |
| Korea Central       | Seoul           |
| Korea South         | Busan           |

### Other regions

We're quickly adding support for other regions so
[contact us](http://www.cloudmailin.com/contact_us)
if your preferred region isn't available.

## Security in the Cloud

Security in the Cloud can be a big worry for some customers. Our pioneering technology allows us
to place security at the forefront of everything that CloudMailin does.

If you want more details about the security of CloudMailin please just
[contact us](http://www.cloudmailin.com/contact_us).

## Getting Started

We also recommend you look at our general [Getting Started Guide](/getting_started/) as it explains
in more detail how you will be sent messages, how the HTTP Status codes you respond with affect the
message delivery and walks you through receiving your first email.

## Adding Some Code

We recommend taking a look at our [HTTP POST Formats](/http_post_formats/). These show the format
of the webhook POST to your website and some sample code to get started.

## Contact Us
If you need any help [contact us](http://www.cloudmailin.com/contact_us) and we can help you
get setup receiving email in Azure.
