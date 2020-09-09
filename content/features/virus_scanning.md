---
title: Scanning Incoming Emails for Viruses
---

# Scanning Incoming Emails for Viruses

CloudMailin has the ability to scan incoming messages for viruses, malware and
other malicious content.

Through our partnership with [AttachmentScanner], we can scan all of the email attachments that
CloudMailin receives via the API. We also have the ability to prevent an HTTP POST from being made
to your website if we believe that a virus may have been found.

Please [contact us] if you would like more details about enabling virus scanning on your email
server.

## Virus Scanner Output

If virus scanning is enabled on your account, the following options will be added to the
HTTP POST that CloudMailin sends to your website.

```json
"scan_result":
  {
    "id": "ed157434-a8ec-4e91-9e27-16f2af5cb17d",
    "status": "found",
    "created_at": "2017-02-20T11:34:03+00:00",
    "callback": null,
    "url": "https://yourbucket.s3.amazonaws.com/eicar.com.txt",
    "filename": "eicar.com.txt",
    "content_length": 68,
    "md5": "44d88612fea8a8f36de82e1278abb02f",
    "matches": ["Eicar-Test-Signature"]
  }
```

### Scan statuses

The key statuses are:

| Status    | Details                                                                             |
|:----------|:------------------------------------------------------------------------------------|
| `ok`      | Nothing was found.                                                                  |
| `found`   | A potential threat was found. See the `matches` parameter for more details.         |
| `pending` | The scan wasn't completed. Call the AttachmentScanner API to get an updated result. |
| `failed`  | The scanner failed to perform the scan, contact support.                            |

More details can be found in the [AttachmentScanner] scan
[documentation](https://www.attachmentscanner.com/documentation).

Please [contact us] if you would like more details about enabling virus scanning for your
CloudMailin incoming email address.

[AttachmentScanner]: https://www.attachmentscanner.com/
