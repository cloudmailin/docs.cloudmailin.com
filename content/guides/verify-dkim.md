---
title: How to Verify DKIM is Working
description: Check your DKIM DNS records and Authentication-Results headers to verify email signing is configured correctly.
---

# How to Verify DKIM is Working

DKIM (DomainKeys Identified Mail) signs your outgoing emails so receiving servers can verify they haven't been tampered with. But how do you know it's actually working?

There are two ways to verify DKIM:

1. **Check your DNS records** - Confirm the public key is published correctly
2. **Check Authentication-Results headers** - Confirm emails are being signed and verified

## Verifying DKIM DNS Records

Your DKIM public key is published as a DNS TXT record at `{selector}._domainkey.yourdomain.com`. You can check it's published correctly using command line tools.

### Using dig

```bash
dig +short TXT selector._domainkey.example.com
```

A successful response shows your DKIM record:

```
"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA..."
```

### Using host

```bash
host -t TXT selector._domainkey.example.com
```

### Checking a CNAME-based DKIM Record

If your DKIM is set up using a CNAME (pointing to your email provider), first check the CNAME resolves:

```bash
dig +short CNAME selector._domainkey.example.com
```

Then verify it resolves to a TXT record:

```bash
dig +short TXT selector._domainkey.example.com
```

The `dig` command will automatically follow the CNAME and return the TXT record.

### Common DNS Issues

| Problem | Cause | Solution |
|---------|-------|----------|
| No record returned | DNS not published or propagating | Wait for propagation (up to 48 hours) or check the record was added correctly |
| `NXDOMAIN` | Record doesn't exist | Verify the selector and domain are correct |
| Truncated key | 2048-bit key not split correctly | Split the key into multiple quoted strings under 255 characters each |
| `SERVFAIL` | DNS server error | Check your DNS provider's status |
| Intermittent failures | Split record strings returned out of order | See [Verifying Split Records](#verifying-split-records) below |

### Verifying Split Records

2048-bit DKIM keys must be split into multiple quoted strings because DNS TXT records have a 255-character limit per string. When split correctly, the record looks like:

```
"v=DKIM1; k=rsa; p=MIIBIjANBgkqhki..." "...rest_of_key..."
```

However, some DNS providers return these strings in an unpredictable order, which can cause **intermittent DKIM failures**. The signature verifies sometimes but fails other times, depending on which order the strings are returned.

To check if your split record is being returned correctly:

```bash
dig +short TXT selector._domainkey.example.com
```

You should see a single concatenated key. If you see multiple separate strings, check they're in the correct order by looking for:

- `v=DKIM1` at the start
- `p=` followed by the key (starting with `MII...`)
- No gaps or breaks in the base64-encoded key

**If you're experiencing intermittent DKIM failures with a split record**, consider:

1. **Contact your DNS provider** - Report the issue and ask if they can ensure TXT record strings are returned in the correct order
2. **Use a CNAME instead** - Point to your email provider's DNS where they host the full key. [CloudMailin](/outbound/dkim/) offers CNAME-based DKIM that avoids split record issues entirely

While 1024-bit keys don't need splitting, **we strongly recommend sticking with 2048-bit keys**. 1024-bit keys are no longer considered secure - they can potentially be cracked with modern computing power, and major email providers like Google and Microsoft recommend 2048-bit as the minimum. The DNS complexity is worth the security.

## Checking Authentication-Results Headers

The best way to verify DKIM is working end-to-end is to send a test email and inspect the `Authentication-Results` header added by the receiving server.

### Finding the Authentication-Results Header

**Gmail:**
1. Open the message
2. Click the three dots menu (⋮)
3. Select "Show original"
4. Search for `Authentication-Results`

**Outlook:**
1. Open the message
2. Click File → Properties
3. Look in "Internet headers"

**Apple Mail:**
1. Open the message
2. View → Message → All Headers (or View → Message → Raw Source to see the full email)

**Command line (for raw email files):**
```bash
grep -i "authentication-results" email.eml
```

### Reading the Authentication-Results Header

A successful DKIM verification looks like this:

```
Authentication-Results: mx.google.com;
    dkim=pass header.i=@example.com header.s=selector1 header.b=abc123;
    spf=pass smtp.mailfrom=example.com;
    dmarc=pass header.from=example.com
```

The key fields are:

| Field | Description |
|-------|-------------|
| `dkim=pass` | The DKIM signature was verified successfully |
| `header.i=@example.com` | The signing identity (your domain) |
| `header.s=selector1` | The DKIM selector used |
| `header.b=abc123` | Truncated signature hash (for identification) |

### DKIM Result Codes

| Result | Meaning |
|--------|---------|
| `dkim=pass` | Signature verified successfully |
| `dkim=fail` | Signature verification failed |
| `dkim=neutral` | No DKIM signature present |
| `dkim=temperror` | Temporary DNS error fetching the public key |
| `dkim=permerror` | Permanent error (malformed record or missing key) |

## Troubleshooting Failed DKIM

If you see `dkim=fail` in the Authentication-Results header:

### 1. Check the DNS Record

```bash
dig +short TXT selector._domainkey.example.com
```

Verify it returns a valid DKIM record starting with `v=DKIM1`.

### 2. Verify the Selector

The selector in the email's `DKIM-Signature` header must match your DNS record. Check the email headers for:

```
DKIM-Signature: v=1; a=rsa-sha256; d=example.com; s=selector1; ...
```

The `s=` value is your selector.

### 3. Check for Message Modification

DKIM signatures cover specific headers and the body. If anything is modified after signing, verification fails. Common causes:

- Mailing lists that modify subject lines or add footers
- Email forwarding services
- Security gateways that rewrite content

### 4. Wait for DNS Propagation

If you recently added or changed your DKIM record, DNS propagation can take up to 48 hours. Most updates are visible within minutes, but some DNS resolvers cache aggressively.

### 5. Check Key Length

Some older systems don't support 2048-bit keys. If you're having issues, check if your key is 1024-bit or 2048-bit:

```bash
dig +short TXT selector._domainkey.example.com | wc -c
```

A 2048-bit key produces a much longer output (around 400+ characters).

## Testing Tools

Several tools can help verify your DKIM setup:

- Send a test email to a Gmail account and check "Show original"
- Check your email provider's dashboard for verification status
- Use mail testing services that report authentication results, like CloudMailin's Deliverability Tester

> CloudMailin's Deliverability Tester checks DKIM, SPF, and DMARC. [Contact us](https://www.cloudmailin.com/contact_us) if you'd like access.

## Let CloudMailin Handle DKIM

Setting up and maintaining DKIM can be complex, especially with 2048-bit keys that need splitting for DNS.

[CloudMailin](https://www.cloudmailin.com) automatically generates and manages DKIM keys for your sending domains. Just add a single CNAME record and we handle the rest - including key rotation and DNS hosting.

[Get started with CloudMailin →](https://www.cloudmailin.com)
