---
title: SPF - Sender Policy Framework Support via HTTP POST
---

# Verifying the message Sender using SPF

SPF (or Sender Policy Framework) is a method of ensuring that the IP address connecting to your server is allowed to send email for a given domain. SPF ensures that a given user has permission to send emails on behalf of the domain of the email address they're sending from.

SPF was introduced in RFC4408 and involves adding a TXT or SPF record to your DNS containing the servers that you wish to allow to send email on behalf of that domain.

There are several states that can be returned as a result of an SPF check:

| State     | Return Value | Description                                                                                                     |
|-----------|--------------|-----------------------------------------------------------------------------------------------------------------|
| None      | `none`       | A result of "None" means that no records were published by the domain or that the domain couldn't be determined |
| Neutral   | `neutral`    | The domain owner has explicitly stated that he cannot or does not want to assert whether or not the IP address is authorized. |
| Pass      | `pass`       | A "Pass" result means that the client is authorized to inject mail with the given identity.                     |
| Fail      | `fail`       | A "Fail" result is an explicit statement that the client is not authorized to use the domain in the given identity. |
| SoftFail  | `softfail`   | A "SoftFail" result should be treated as somewhere between a "Fail" and a "Neutral".  The domain believes the host is not authorized but is not willing to make that strong of a statement.                                                                     |
| TempError | `temperror`  | A temporary error was encountered.                                                                              |
| PermError | `permerror`  | A permenant error was encountered.                                                                              |

The SPF details passed will comprise of following parts:

| Item     | Description                                                                                                      |
|----------|------------------------------------------------------------------------------------------------------------------|
| `result` | The result of the SPF check                                                                                      |
| `domain` | The domain used to perform the SPF check. This will be the domain in the from address. However, if there is no domain in the from address then the helo_domain will be used instead.                                                                            |

CloudMailin will return an SPF result as part of the envelope that it sends. Please see the [HTTP Post Formats](http://localhost:3002/http_post_formats/) for details of how to retrieve the SPF result within each format.