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
    public class CloudmailinHeader
    {
        public string return_path { get; set; }
        public string[] received { get; set; }
        public DateTime date { get; set; }
        public string[] from { get; set; }
        public string[] to { get; set; }
        public string message_id { get; set; }
        public string subject { get; set; }
        public string mime_version { get; set; }
        public string content_type { get; set; }
        public string[] delivered_to { get; set; }
        public string received_spf { get; set; }
        public string authentication_results { get; set; }
        public string user_agent { get; set; }
    }

    public class CloudmailinEnvelope
    {
        public string to { get; set; }
        public string from { get; set; }
        public string helo_domain { get; set; }
        public string remote_ip { get; set; }
        public string[] recipients { get; set; }
        public Spf spf { get; set; }
        public bool tls { get; set; }
    }

    public class Spf
    {
        public string result { get; set; }
        public string domain { get; set; }
    }

    public class CloudmailinAttachment
    {
        public string content { get; set; }
        public string file_name { get; set; }
        public string content_type { get; set; }
        public int size { get; set; }
        public string disposition { get; set; }
    }

    public interface ICloudmailinRequest
    {
        public CloudmailinEnvelope envelope { get; set; }
        public string plain { get; set; }
        public string html { get; set; }
        public CloudmailinAttachment[] attachments { get; set; }
    }

    public class CloudmailinRequest : ICloudmailinRequest
    {
        public IDictionary<string, string[]> headers { get; set; }
        public CloudmailinEnvelope envelope { get; set; }
        public string plain { get; set; }
        public string html { get; set; }
        public CloudmailinAttachment[] attachments { get; set; }
    }

    public class CloudmailinRequestDto : ICloudmailinRequest
    {
        public IDictionary<string, JsonElement> headers { get; set; }
        public CloudmailinEnvelope envelope { get; set; }
        public string plain { get; set; }
        public string html { get; set; }
        public CloudmailinAttachment[] attachments { get; set; }
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
                headers = request.headers.ConvertHeaderToDictionary(),
                envelope = request.envelope,
                html = request.html,
                plain = request.plain,
                attachments = request.attachments
            };

            Console.WriteLine(mail.headers["to"]); // access headers

            return Json(mail);
        }
    }

To convert the header properties in a .NET manner we need additionally a helper class that handles array and string parameters into an array property.

    // Helper.cs
    public static CloudmailinHeader ConvertHeader(this IDictionary<string, JsonElement> source)
    {
        var header = new CloudmailinHeader();
        var headerType = header.GetType();

        foreach (var item in source)
        {
            var prop = headerType.GetProperty(item.Key);
            if (prop.PropertyType.IsArray)
            {
                if (item.Value.ValueKind == JsonValueKind.Array)
                {
                    prop.SetValue(header, item.Value.EnumerateArray().Select(x => x.GetString()).ToArray(), null);
                }
                else
                {
                    prop.SetValue(header, new string[] { item.Value.GetString() }, null);
                }
            }
            else
            {
                if (prop.PropertyType == typeof(DateTime))
                {
                    prop.SetValue(header, DateTime.Parse(item.Value.GetString()), null);
                }
                else
                {
                    prop.SetValue(header, item.Value.GetString(), null);
                }
            }
        }

        return header;
    }
    
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
