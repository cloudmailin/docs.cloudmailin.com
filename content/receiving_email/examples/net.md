---
title: Receiving Email with .Net
description: Receiving email with .Net and CloudMailin
skip_erb: true
image: net
---

# Receiving Email with .Net

## ASP.NET C Sharp

<div class="warning">This example may be outdated. You can now find examples for newer POST formats within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

This is an extremely simple version of getting the CloudMailin HTTP POST parameters (original format) from an ASP.net application. Any help expanding this example would be greatly appreciated. This example has only been tested in .net version 2.0 which is now a little dated.

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" validateRequest=false %>
      <script language="C#" runat="server">
        void Page_Load(object sender, EventArgs e) {
          String from = Request.Form["from"];
          String plain = Request.Form["plain"];
          String html = Request.Form["html"];
        }
      </script>
    </html>

In this example the message parameter is ignored although you could use a mime parsing component to read in the full message if required.
