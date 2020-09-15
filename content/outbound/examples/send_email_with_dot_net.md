---
title: Send Email with .Net (C#)
description: In this guide we'll cover sending email in C# and .Net over SMTP with CloudMailin's SMTP settings.
---

# Sending Email with .Net (C#)

.Net has built in support for sending mail with the System.Net.Mail namespace. Although the example
below uses C# this applies to each of the .Net framework languages to send email.

The System.Net.Mail requires that you create a `MailMessage` and then an `SmtpClient` to sent that
message.

> To obtain your SMTP credentials you can create a free [outbound account] with CloudMailin.

### The Mail Message Itself

The `MailMessage` gives access to a number of properties to create a message:

```c#
string to = "debug@example.com";
string from = "csharp@example.com";
MailMessage message = new MailMessage(from, to);
message.Subject = "Using the new SMTP client.";
message.Body = @"Using this new feature, you can send an email message from an application very easily.";
```

To add HTML you can simply send `IsBodyHtml` and pass HTML to the body parameter:

```c#
string to = "debug@example.com";
string from = "csharp@example.com";
MailMessage message = new MailMessage(from, to);
message.Subject = "Using the new SMTP client.";
message.Body = @"<h1>Send Messages</h1>You can send an <strong>email message</strong>.";
message.IsHtml = true;
```

### Adding Attachments

Attachments can be added to the mail message using `Attachments.Add`:

```c#
var attachment = new Attachment("attachment.jpg", MediaTypeNames.Image.Jpeg);
message.Attachments.Add(attachment);
```

### Setting the correct SMTP parameters

Here we'll set the required parameters to send our `MailMesage` using `SmtpClient`.

```c#
SmtpClient client = new SmtpClient("HOSTNAME");
client.Port = 587;
client.UseDefaultCredentials = false;
client.EnableSsl = true;
client.Credentials = new System.Net.NetworkCredential("USERNAME", "PASSWORD")
```

The default system of authentication in .Net is a little picky as the [SmtpClient] documentation
states if the mail server requires authentication (which we do), then you **must set**
`UseDefaultCredentials` property is set to `false`.

```c#
client.UseDefaultCredentials = false;
```

In addition it's important to note that the .Net framework's SMTP Client will perform STARTTLS on
a connection if `EnableSsl` is set to `true` (an alternate system of using SSL by default on port
465 is not supported by .Net).

```c#
client.EnableSsl = true;
```

Finally once we have our `SmtpClient` and our `MailMessage` we can send the message with the
following:

```c#
client.Send(message);
```

### A full example

The full example sending an email using the .Net framework in C# is as follows:

```c#
using System;
using System.Net.Mail;

public class Program
{
 public static void Main()
 {
  string to = "debug@example.com";
  string from = "csharp@example.com";
  MailMessage message = new MailMessage(from, to);
  message.Subject = "Using the new SMTP client.";
  message.Body = @"Using this new feature, you can send an email message from an application very easily.";
  SmtpClient client = new SmtpClient("HOSTNAME");
  client.Port = 587;
  // Credentials are necessary if the server requires the client
  // to authenticate before it will send email on the client's behalf.
  client.UseDefaultCredentials = false;
  client.EnableSsl = true;
  client.Credentials = new System.Net.NetworkCredential("USERNAME", "PASSWORD")
  client.Send(message);
 }
}
```

<%= render 'outbound_summary' %>

[SmtpClient]: https://docs.microsoft.com/en-us/dotnet/api/system.net.mail.smtpclient.credentials?view=netcore-3.1
