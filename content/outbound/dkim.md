---
title: DKIM Signing for Outbound Email
description: Setting up DKIM DNS records for CloudMailin outbound email with CNAME or TXT records.
---

# DKIM Signing for Outbound Email

CloudMailin automatically generates a unique 2048-bit DKIM key for each sending domain and signs all outgoing messages. You just need to publish the DNS record so receiving servers can verify your signatures.

Your DKIM settings, including the exact DNS records to add, are available on your [domain's settings page](https://www.cloudmailin.com/outbound/domains/).

## Why We Use 2048-bit Keys

CloudMailin generates 2048-bit DKIM keys for all sending domains. While some email providers still use shorter 1024-bit keys for simplicity, we use 2048-bit keys because:

- **1024-bit keys are no longer considered secure.** Advances in computing power mean 1024-bit RSA keys can potentially be cracked. Major email providers like Google and Microsoft recommend 2048-bit keys.
- **Industry standards require it.** RFC 8301 recommends a minimum of 2048 bits for DKIM keys, and many receiving servers will flag or reject messages signed with shorter keys.
- **Future-proofing.** A 2048-bit key provides a much larger security margin and won't need to be upgraded as quickly.

The trade-off is that 2048-bit keys are longer than the 255-character limit for a single DNS TXT string, which is why some DNS providers require you to split the key. Our recommended CNAME method avoids this issue entirely - CloudMailin hosts the key for you.

## Setting Up Your DKIM DNS Record

There are two ways to publish your DKIM key: using a CNAME record (recommended) or a TXT record.

### CNAME Record (Recommended)

The simplest approach is to add a single CNAME record that points to CloudMailin's DNS. This means:

- No need to handle the long 2048-bit key yourself
- CloudMailin manages key rotation automatically
- Single, simple record to add

Add the following CNAME record to your DNS:

| Hostname | Type | Value |
|----------|------|-------|
| `{selector}._domainkey.yourdomain.com` | CNAME | `{selector}.dkim.clients.cloudmta.net` |

For example, if your selector is `a1b2c3d4e5cm` and your domain is `example.com`:

```
a1b2c3d4e5cm._domainkey.example.com  CNAME  a1b2c3d4e5cm.dkim.clients.cloudmta.net
```

The exact values for your domain are shown on your [domain settings page](https://www.cloudmailin.com/outbound/domains/).

### TXT Record (Alternative)

If you prefer to manage the DKIM key directly in your DNS, you can add a TXT record instead. This gives you full control over the key but requires more setup.

Add a TXT record with your full DKIM public key:

| Hostname | Type | Value |
|----------|------|-------|
| `{selector}._domainkey.yourdomain.com` | TXT | `v=DKIM1; h=sha256; k=rsa; s=email; p={public_key}` |

#### Splitting 2048-bit Keys

2048-bit DKIM keys are longer than the 255-character limit for a single DNS TXT string. Most modern DNS providers handle this automatically, but some require you to split the key into multiple quoted strings.

If your DNS provider requires manual splitting, format the record like this:

```
"v=DKIM1; h=sha256; k=rsa; s=email; " "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA..." "...rest_of_key..."
```

Each string should be enclosed in quotes and be under 255 characters. The receiving mail server will automatically concatenate them.

> If you're having trouble with key length, we recommend using the CNAME method instead.

## Verifying Your DKIM Setup

Once you've added the DNS record:

1. Go to your [domain settings page](https://www.cloudmailin.com/outbound/domains/)
2. Click **Verify** to check the DNS record

DNS changes can take up to 48 hours to propagate, though most updates are visible within a few minutes.

For detailed instructions on verifying DKIM using command line tools and checking Authentication-Results headers, see our [How to Verify DKIM is Working](/guides/verify-dkim/) guide.

## Parent Domain DKIM

If you're sending from a subdomain (e.g., `mta.example.com`), you can place the DKIM DNS record on either:

- The subdomain: `{selector}._domainkey.mta.example.com`
- The parent domain: `{selector}._domainkey.example.com`

Placing the record on the parent domain can simplify DNS management if you have many subdomains, as you only need to maintain one DKIM record. CloudMailin will check both locations and verify accordingly. Your domain settings page will show which domain the DKIM record was found on.

## Inbound DKIM Verification

Looking to verify DKIM signatures on emails you *receive* through CloudMailin? See [DKIM Verification for Inbound Email](/features/dkim/).
