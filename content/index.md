---
title: CloudMailin Documentation
---

# CloudMailin Documentation

Thanks for trying out CloudMailin. We've done our best to create documentation that's helpful and contains the information you need. If you do need any help though feel free to [contact us](http://cloudmailin.com/contact_us).

Remember, all the documentation is also open source, so if you think there's something you could improve feel free to also send us a pull request to the [github](https://github.com/CloudMailin/docs.cloudmailin.com/) account.

## Getting Started
The Getting Started Guides cover getting CloudMailin setup and receiving your first emails.

<% for item in items_for_section('getting_started').sort_by(&:name) %>
  * [<%= item.name %>](<%= item.identifier %>)
<% end %>

## Receiving Email
The Receiving Email section covers a number of features and things that you need to know when working with CloudMailin such as the [HTTP Status Codes](/receiving_email/http_status_codes/) and [Using Your Own Domain](/receiving_email/forwarding_and_custom_domains/).

## Post Formats and Examples

If you're ready to start coding take a look at our [Post Formats](/http_post_formats/) to see the format of the HTTP POST that CloudMailin will send to your web application.

Alternatively check out the [Examples Section](/receiving_email/examples/).