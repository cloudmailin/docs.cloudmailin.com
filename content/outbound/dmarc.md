---
title: DMARC Setup for Sending Email
description: Quick setup guide for DMARC with CloudMailin - automatic report collection and dashboard included.
---

# DMARC Setup for Sending Email

DMARC (Domain-based Message Authentication, Reporting and Conformance) protects your domain from spoofing by telling receiving email servers what to do when messages fail authentication. Your DMARC policy determines whether failing messages are delivered, quarantined, or rejected. CloudMailin automatically collects and parses the reports that show how your policy is working.

## CloudMailin Handles the Prerequisites

DMARC requires both SPF and DKIM to be configured. CloudMailin automatically:

- **Signs all messages with DKIM** - Your 2048-bit DKIM key is automatically applied to every outbound message
- **Configures SPF via CNAME** - SPF is automatically set up when you add the required DNS records
- **Aligns authentication** - Both DKIM and SPF align with your sending domain

You just need to add the DMARC DNS record and [choose your policy](#policy-progression) to protect your domain.

> **Beta Feature:** DMARC report collection and dashboard is currently in beta. Your DMARC settings and report collection address are available on your [domain's settings page](https://www.cloudmailin.com/outbound/domains/).

## Setting Up Your DMARC DNS Record

Add a TXT record to your DNS:

| Hostname | Type | Value |
|----------|------|-------|
| `_dmarc.yourdomain.com` | TXT | `v=DMARC1; p=none; pct=100; rua=mailto:YOUR_RUA_ADDRESS; aspf=r;` |

Your unique report address (`rua`) is shown on your [domain settings page](https://www.cloudmailin.com/outbound/domains/). Replace `YOUR_RUA_ADDRESS` with the address from your settings. For example:

```
_dmarc.example.com  TXT  "v=DMARC1; p=none; pct=100; rua=mailto:YOUR_RUA_ADDRESS; aspf=r;"
```

### Adding to an Existing DMARC Record

If you already have a DMARC record, add CloudMailin's report address using a comma:

```
v=DMARC1; p=quarantine; rua=mailto:existing@example.com,mailto:YOUR_RUA_ADDRESS;
```

## Policy Progression

Your DMARC policy tells receiving servers what action to take when messages fail authentication:

| Policy | Action |
|--------|--------|
| `p=none` | Monitor only - failing messages are delivered normally |
| `p=quarantine` | Failing messages are treated as suspicious (typically marked as spam) |
| `p=reject` | Failing messages are blocked and not delivered |

> **Recommendation:** Start with `p=none` to monitor without affecting delivery. See our [Complete DMARC Guide](https://www.cloudmailin.com/blog/dmarc-email-authentication-complete-guide-2026#policy-progression-strategy) for guidance on policy progression.

## Recommended: SPF Alignment

For full DMARC compliance, ensure your SPF record includes CloudMailin's sending servers. If you're sending from a subdomain (e.g., `mta.example.com`), SPF is automatically configured via CNAME.

For parent domains, add your sending subdomain to your SPF:

```
v=spf1 include:mta.example.com ~all
```

This ensures SPF alignment with your From domain for stronger DMARC authentication.

## DMARC Reports Dashboard

> **Beta Feature:** CloudMailin automatically collects DMARC reports from all major email providers and displays them in an easy-to-use dashboard. Reports are parsed from XML and categorized by authentication status.

DMARC reports are sent daily by receiving servers. Wait 24-48 hours after adding your DNS record for the first reports to arrive.

## Learn More

For a complete guide to DMARC policies, alignment, report interpretation, and best practices, see our [Complete DMARC Guide](https://www.cloudmailin.com/blog/dmarc-email-authentication-complete-guide-2026).
