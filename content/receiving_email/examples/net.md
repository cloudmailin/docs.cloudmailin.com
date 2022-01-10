---
title: Receiving Email with .Net
description: Receiving email with .Net and CloudMailin
skip_erb: true
image: net
---

# Receiving Email with .Net 5

## ASP.NET WebAPI C Sharp

<div class="warning">This example may be outdated. You can now find examples for newer POST formats within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

There are different options for ASP.NET projects. In this case we simply use an Web API project using Swagger for simple debug uses.

First we need the necessary models for the webhook request.

    // Model.cs
    public class CloudmailinEnvelope
    {
        [JsonPropertyName("to")]
        public string To { get; set; }

        [JsonPropertyName("from")]
        public string From { get; set; }

        [JsonPropertyName("helo_domain")]
        public string HeloDomain { get; set; }

        [JsonPropertyName("remote_ip")]
        public string RemoteIp { get; set; }

        [JsonPropertyName("recipients")]
        public string[] Recipients { get; set; }

        [JsonPropertyName("spf")]
        public Spf Spf { get; set; }

        [JsonPropertyName("tls")]
        public bool Tls { get; set; }
    }

    public class Spf
    {
        [JsonPropertyName("result")]
        public string Result { get; set; }

        [JsonPropertyName("domain")]
        public string Domain { get; set; }
    }

    public class CloudmailinAttachment
    {
        [JsonPropertyName("content")]
        public string Content { get; set; }

        [JsonPropertyName("file_name")]
        public string FileName { get; set; }

        [JsonPropertyName("content_type")]
        public string ContentType { get; set; }

        [JsonPropertyName("size")]
        public int Size { get; set; }

        [JsonPropertyName("disposition")]
        public string Disposition { get; set; }
    }

    public interface ICloudmailinRequest
    {
        [JsonPropertyName("envelope")]
        public CloudmailinEnvelope Envelope { get; set; }

        [JsonPropertyName("plain")]
        public string Plain { get; set; }

        [JsonPropertyName("html")]
        public string Html { get; set; }

        [JsonPropertyName("attachments")]
        public CloudmailinAttachment[] Attachments { get; set; }
    }

    public class CloudmailinRequest : ICloudmailinRequest
    {
        [JsonPropertyName("headers")]
        public IDictionary<string, string[]> Headers { get; set; }
        public CloudmailinEnvelope Envelope { get; set; }
        public string Plain { get; set; }
        public string Html { get; set; }
        public CloudmailinAttachment[] Attachments { get; set; }
    }

    public class CloudmailinRequestDto : ICloudmailinRequest
    {
        [JsonPropertyName("headers")]
        public IDictionary<string, JsonElement> Headers { get; set; }
        public CloudmailinEnvelope Envelope { get; set; }
        public string Plain { get; set; }
        public string Html { get; set; }
        public CloudmailinAttachment[] Attachments { get; set; }
    }

In the next step we create a controller that is accessed by the webhook of Cloudmailin.


    // Controllers/WebhookController.cs
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
                Html = request.Html,
                Plain = request.Plain,
                Attachments = request.Attachments
            };

            Console.WriteLine(mail.Headers.TryGetValue("to", out var to)); // access headers

            return Json(mail);
        }
    }

To convert the header properties in a .NET manner we need additionally a helper class that handles array and string parameters into an array property.

    // Helper.cs
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
