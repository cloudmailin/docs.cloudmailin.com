---
title: Receiving Email with .Net 5 & 6
description: Receiving email with .Net and CloudMailin
image: net
---

# Receiving Email with .Net 5 & 6

While it's possible to receive email in number of different ways with .NET, such
as executing a script from an SMTP server or polling via IMAP, these solutions
have a number of disadvantages.

With CloudMailin you don't have to run an email server or poll regularly, you
can simply receive email via Webhook (HTTP POST) the instant an email is
received by the server. In order to receive email in C# using this method we
simply need to create a web application to listen to the callback.

## ASP.NET WebAPI C# (C Sharp)

ASP.NET offers a variety of options to run and structure a web application. Here
we're going to create an example Web API project, which will allow us to use
Swagger to aid with debugging if necessary.
Most of the code here can also easily be adapted to other forms of web
applications.

We'll need to create the following:

* [Models]
* [Helper]
* [Controller]

When we get to the controller we'll look at:

* [Accessing the Headers]
* [Accessing the Email Body]
* [Accessing Attachments]

> In order to receive email with ASP.NET we'll use CloudMailin's
> [JSON (Normalized)] format.

## Creating Models

In order to receive email in C# ASP.NET CloudMailin will send email via Webhook.
In order to receive the email we'll need to create a publicly available HTTP
endpoint.

To get started, we'll first create the necessary models for the webhook request:

```c#
using System.Collections.Generic;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace Cloudmailin
{
    public class CloudmailinEnvelope
    {
        [JsonPropertyName("to")]
        public string To { get; set; }

        [JsonPropertyName("from")]
        public string From { get; set; }

        [JsonPropertyName("helo_domain")]
        public string HeloDomain { get; set; }

        [JsonPropertyName("remote_ip")]
        public string RemoteIP { get; set; }

        [JsonPropertyName("recipients")]
        public string[] Recipients { get; set; }

        [JsonPropertyName("spf")]
        public SPF SPF { get; set; }

        [JsonPropertyName("tls")]
        public bool TLS { get; set; }
    }

    public class SPF
    {
        [JsonPropertyName("result")]
        public string Result { get; set; }

        [JsonPropertyName("domain")]
        public string Domain { get; set; }
    }

    public class CloudmailinAttachment
    {
        [JsonPropertyName("content")]
        public string? Content { get; set; }

        [JsonPropertyName("url")]
        public string? URL { get; set; }

        [JsonPropertyName("file_name")]
        public string FileName { get; set; }

        [JsonPropertyName("content_type")]
        public string ContentType { get; set; }

        [JsonPropertyName("size")]
        public int Size { get; set; }

        [JsonPropertyName("disposition")]
        public string? Disposition { get; set; }
    }

    public interface ICloudmailinRequest
    {
        [JsonPropertyName("envelope")]
        public CloudmailinEnvelope Envelope { get; set; }

        [JsonPropertyName("plain")]
        public string? Plain { get; set; }

        [JsonPropertyName("reply_plain")]
        public string? ReplyPlain { get; set; }

        [JsonPropertyName("html")]
        public string? HTML { get; set; }

        [JsonPropertyName("attachments")]
        public CloudmailinAttachment[] Attachments { get; set; }
    }

    public class CloudmailinRequest : ICloudmailinRequest
    {
        [JsonPropertyName("headers")]
        public IDictionary<string, string[]> Headers { get; set; }
        public CloudmailinEnvelope Envelope { get; set; }
        public string? Plain { get; set; }
        public string? ReplyPlain { get; set; }
        public string? HTML { get; set; }
        public CloudmailinAttachment[] Attachments { get; set; }
    }

    public class CloudmailinRequestDto : ICloudmailinRequest
    {
        [JsonPropertyName("headers")]
        public IDictionary<string, JsonElement> Headers { get; set; }
        public CloudmailinEnvelope Envelope { get; set; }
        public string? Plain { get; set; }
        public string? ReplyPlain { get; set; }
        public string? HTML { get; set; }
        public CloudmailinAttachment[] Attachments { get; set; }
    }
}
```

We need to do a little bit of conversion because CloudMailin headers may come as
either a `string or an array of strings`. Emails can contain a header one or
many times.

The email subject is a header that frequently is only specified once. However,
headers such as received will be added multiple times, once for each server that
processes the email.
We'll create a helper later to convert all header keys from this unknown format
to a strict array of strings every time.

CloudMailin's [JSON (Normalized)] format also uses lower-cased and underscored
names for the JSON keys. Thankfully we can make use of the `JsonPropertyName`
[data annotation] to help convert these properties.

These models represent the basic structure of an email:

| Object                | Description                                          |
|-----------------------|------------------------------------------------------|
| ICloudmailinRequest   | The CloudMailin Request Interface
| CloudmailinRequestDto | The DataTransfer object which string keys but JsonElement vague parameters for the values of our Headers.
| CloudmailinRequest    | The Actual interface once we've converted headers to string keys with an array of strings for values.
| CloudmailinAttachment | Represents the attachments of the email.
| CloudmailinEnvelope   | The envelope contains all of the information transmitted in the CloudMailin SMTP server transaction. Such as whether it used Transport Layer Security (TLS).
| SPF                   | Represents the SPF status of our received email.

More details of the parameters and all of the options available can be found
in the [JSON (Normalized)] documentation.

## Helper Function

As mentioned earlier. CloudMailin's format doesn't directly translate to a
strongly typed class in C#. We therefore need to use a helper to convert headers
from key / value pairs where the value can be a string or array of strings.

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;

namespace Cloudmailin
{
    public static class Helper
    {
        public static Dictionary<string, string[]> ConvertHeaderToDictionary(this IDictionary<string, JsonElement> source)
        {
            var dictionary = new Dictionary<string, string[]>();

            foreach (var item in source)
            {
                if (dictionary.ContainsKey(item.Key))
                {
                    Console.WriteLine("Header value already set.");
                }
                else
                {
                    var list = new List<string>();
                    if (item.Value.ValueKind == JsonValueKind.Array)
                    {
                        dictionary.TryAdd(item.Key, item.Value.EnumerateArray().Select(x => x.GetString()).ToArray());
                    }
                    else
                    {
                        dictionary.TryAdd(item.Key, new string[] { item.Value.GetString() });
                    }
                }
            }

            return dictionary;
        }
    }
}
```

With the helper in place we can now access headers from the dictionary. For
example we can get the email subject with the following:

```c#
if (mail.Headers.TryGetValue("subject", out var subject)){
    Console.WriteLine(subject.First()); // headers["subject"] value
}
```

## The Controller

With the helper in place we can create a controller to handle the actual
webhook.

### Receiving the Webhook with C#

In the next step we create a controller that is accessed by the webhook of
Cloudmailin.

```c#
using Microsoft.AspNetCore.Mvc;
using System;

namespace Cloudmailin.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WebhookController : Controller
    {
        [HttpPost]
        public IActionResult CloudMailin(CloudmailinRequestDto request)
        {
            var mail = new CloudmailinRequest()
            {
                Headers = request.Headers.ConvertHeaderToDictionary(),
                Envelope = request.Envelope,
                Plain = request.Plain,
                ReplyPlain = request.ReplyPlain,
                HTML = request.HTML,
                Attachments = request.Attachments
            };

            if (mail.Headers.TryGetValue("to", out var to)){
                Console.WriteLine(to.First()); // header["to"] value

                if (to.First().StartsWith("noreply")) {
                    Response.StatusCode = 422;
                    return Content("NoReply");
                }
            }

            return Json(mail);
        }
    }
}
```

The code above receives the email and makes use of the models and helper
outlined above.

> Often you don't want the to/from address in the envelope (SMTP) if your email
> is being forwarded. The intended information is normally available in the
> headers and is often different and preferable. Feel free to [contact us] if
> you need help deciding which to use.

In CloudMailin the HTTP status code that your return matters (see
[HTTP Status Codes]). The above code will bounce the email (by returning
HTTP 422 error) if the to address starts with "noreply".

### Receiving email Headers in C#

As we mentioned previously email headers can be added to the top of the email
as the email passes through the SMTP chain. Generally this means that headers
can occur once or multiple times.

Normally headers such as the to, from or subject only occur once. Other headers,
though such as the received header will occur multiple times.

To access the email subject we can do the following:

```c#
if (mail.Headers.TryGetValue("subject", out var subject)){
    Console.WriteLine(subject.First());
}
```

The received headers can be iterated like the following:

```c#
if (mail.Headers.TryGetValue("received", out var received)){
    foreach(string item in received){
        Console.WriteLine(item);
    }
}
```

### Receiving email body in C#

When we receive an email via our Webhook CloudMailin will attempt to parse the
reply from the plain part of email if it's possible.
With the following code we can extract the Reply or Plain part if the reply
isn't present and the HTML part of the email.

```c#
var body = mail.ReplyPlain != "" ? mail.ReplyPlain : mail.Plain;
Console.WriteLine(body);
Console.WriteLine(mail.HTML)
```

### Receiving Email Attachments in C#

Finally we can receive our email attachments, parsed and easy to use within the
C# code.

If we have [Attachment Stores] enabled, CloudMailin will parse the email
attachments and upload them to your own Cloud Storage, such as AWS S3, Google
Cloud Storage or Azure Blob Storage.
In this case we'll receive a the `URL` for the file that was extracted from the
email and uploaded.

If we are not using the email attachment parsing and storage then we'll receive
the full attachment content in the `Content` parameter as a Base64 encoded
string.

The following is an example accessing the URL attachment:

```c#
if (mail.Attachments?.Length > 0){
    var attachment = mail.Attachments[0];
    Console.WriteLine(attachment.FileName);
    Console.WriteLine(attachment.URL);
}
```

As always we recommend taking a look at the [JSON (Normalized)] documentation.

---

<%= items["/receiving_email/examples/_summary/"].raw_content %>

[Models]: #creating-models
[Helper]: #helper-function
[Controller]: #the-controller
[Accessing the Headers]: #accessing-email-headers-in-c-
[Accessing the Email Body]: #accessing-email-body-in-c-
[Accessing Attachments]: #accessing-email-attachments-in-c-

[Attachment Stores]: <%= url_to_item('/receiving_email/store-email-attachments-in-s3-azure-google-storage/') %>
[Data Annotation]: https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/customize-properties?pivots=dotnet-6-0
[JSON (Normalized)]: <%= url_to_item('/http_post_formats/json_normalized/') %>
[Status Codes]: <%= url_to_item('/receiving_email/http_status_codes/') %>
