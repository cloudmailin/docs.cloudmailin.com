---
title: CloudMailin IP Address Ranges
---

# CloudMailin IP Address Ranges

CloudMailin's default cluster uses AWS in `us-east-1`, `eu-west-1` and `Brightbox UK`.

**We do not recommend that customers restrict access to their website from our
cluster based on IP address**. Because our cloud scales up and down as required
IP addresses can change from time to time. This results in a large number of
IP addresses being required.

Instead we highly recommend using [HTTPS and Basic Auth]
(/receiving_email/securing_your_email_url_target/#basic-authentication-and-https)
to secure the endpoint that CloudMailin contacts.

However for reference the possible list of IP addresses as ranges is as follows:

## AWS US-EAST-1

```
<%= aws_ip_range('us-east-1', 'EC2') %>
```

## AWS EU-WEST-1

```
<%= aws_ip_range('eu-west-1', 'EC2') %>
```

## Brightbox

```
109.107.32.0/19
```
