---
title: DMARC Verification for Inbound Email
---

# Verifying Incoming Email with DMARC

DMARC (Domain-based Message Authentication, Reporting and Conformance) builds on SPF and DKIM to provide a policy framework for email authentication. It tells receiving servers what to do when an email fails authentication checks and provides reporting back to domain owners.

> **Beta Feature:** DMARC verification for inbound email is available on request. Please [contact us] to enable this feature for your account. As this is a beta feature, the format may change. If it does, we'll email you to let you know.

## How DMARC Verification Works

When DMARC verification is enabled, CloudMailin will:

1. Look up the DMARC policy for the domain in the message's From header
2. Check SPF (using the envelope sender) and DKIM, and whether each one aligns with the From header domain
3. Pass the result and details to your webhook in the envelope

CloudMailin only adds this information to the envelope. We never reject, bounce or hold a message because of its DMARC result or the sender's policy, so the message is delivered to your target as normal and it's up to you to decide what to do with it.

## DMARC Results

The overall `result` is always one of two values:

| Result | Description |
|--------|-------------|
| `pass` | SPF or DKIM passed and aligned with the From header domain, under a published DMARC policy. |
| `fail` | Anything else, including when the domain publishes no DMARC policy and when the DNS lookups fail. |

Because `fail` covers several situations, use the `details` to tell them apart (see [No DMARC Record](#no-dmarc-record) and [DNS Errors](#dns-errors) below).

## Envelope Format

When DMARC verification is enabled, the envelope will include a `dmarc` object. A message that passes:

```json
"envelope": {
  ...
  "dmarc": {
    "success": true,
    "result": "pass",
    "details": {
      "spf_result": "pass",
      "dmarc_spf_result": "pass",
      "dmarc_dkim_result": "pass",
      "domain": "example.com",
      "policy": "quarantine",
      "dkim_results": [
        {
          "result": "pass",
          "domain": "example.com",
          "selector": "selector1"
        }
      ]
    }
  }
}
```

A message from a domain with `p=reject` where SPF and DKIM both passed, but for a different domain, so neither aligned:

```json
"dmarc": {
  "success": true,
  "result": "fail",
  "details": {
    "spf_result": "pass",
    "dmarc_spf_result": "fail",
    "dmarc_spf_error_message": "policy not aligned",
    "dmarc_dkim_result": "fail",
    "dkim_error_message": "policy not aligned",
    "domain": "example.com",
    "policy": "reject",
    "dkim_results": [
      {
        "result": "pass",
        "domain": "sender.example.net",
        "selector": "selector1"
      }
    ]
  }
}
```

### DMARC Fields

| Field | Description |
|-------|-------------|
| `success` | Whether the DMARC check ran (boolean). See [Errors](#errors). |
| `result` | The overall DMARC result, `pass` or `fail`. |
| `details` | Additional information about the verification. |

### Details Fields

| Field | Description |
|-------|-------------|
| `domain` | The From header domain that was checked. This is empty if the message has no From address, or From addresses with different domains. |
| `policy` | The policy that applies to the domain (`none`, `quarantine`, `reject`). This is `none` when the domain has no DMARC record. |
| `spf_result` | The raw SPF result for the envelope sender (`pass`, `fail`, `softfail`, `neutral`, `none`, `temperror`, `permerror`). |
| `dmarc_spf_result` | The SPF result after the DMARC alignment check (`pass`, `fail`, `none`, `temperror`, `permerror`). |
| `dmarc_spf_error_message` | Only present when `dmarc_spf_result` is not `pass` or `none`, for example `policy not aligned`. |
| `dmarc_dkim_result` | The DKIM result after the DMARC alignment check (`pass`, `fail`, `none`, `temperror`, `permerror`). |
| `dkim_error_message` | Only present when `dmarc_dkim_result` is not `pass` or `none`, for example `policy not aligned`. |
| `dkim_results` | Array of DKIM verification results (same format as the [DKIM envelope](/features/dkim/)). |

The error message fields are there to help with debugging. Their wording comes from the underlying library and may change, so we recommend not matching on them.

## No DMARC Record

When the From domain doesn't publish a DMARC record (and neither does its organizational domain), `result` is `fail` and `policy` is `none`. The raw `spf_result` and `dkim_results` are still filled in, but no alignment check is made, so `dmarc_spf_result` and `dmarc_dkim_result` are both `none` even if SPF and DKIM passed for the From domain:

```json
"dmarc": {
  "success": true,
  "result": "fail",
  "details": {
    "spf_result": "pass",
    "dmarc_spf_result": "none",
    "dmarc_dkim_result": "none",
    "domain": "example.com",
    "policy": "none",
    "dkim_results": [
      {
        "result": "pass",
        "domain": "example.com",
        "selector": "selector1"
      }
    ]
  }
}
```

If you want to check the sender of a message from a domain without DMARC, look at `spf_result` and `dkim_results` directly.

The DMARC record itself isn't included, so a `policy` of `none` can mean either that there is no record or that the domain publishes `p=none`. When neither SPF nor DKIM passes, the two cases look the same. Either way, the domain isn't asking you to quarantine or reject failing mail.

## DNS Errors

If the DNS lookup for the DMARC record fails, `result` is `fail`, `policy` is `none`, and `dmarc_spf_result` and `dmarc_dkim_result` are `temperror` (or `permerror`), each with an error message. Treat this as unknown rather than as a failure by the sender.

## Errors

If verification couldn't be run at all, for example because the message couldn't be parsed, the envelope contains only:

```json
"dmarc": {
  "success": false
}
```

The message is still delivered as normal.

## Multipart Formats

In the [multipart](/http_post_formats/multipart/) and [raw](/http_post_formats/raw/) formats the same object is sent as form fields. Nested fields and arrays are flattened, every value is sent as a string (so `success` is `"true"`), and empty arrays are left out:

```
envelope[dmarc][success]=true
envelope[dmarc][result]=pass
envelope[dmarc][details][spf_result]=pass
envelope[dmarc][details][dmarc_spf_result]=pass
envelope[dmarc][details][dmarc_dkim_result]=pass
envelope[dmarc][details][domain]=example.com
envelope[dmarc][details][policy]=quarantine
envelope[dmarc][details][dkim_results][0][result]=pass
envelope[dmarc][details][dkim_results][0][domain]=example.com
envelope[dmarc][details][dkim_results][0][selector]=selector1
```

## Using DMARC Results

To check if a message passed DMARC verification:

```javascript
function dmarcPassed(envelope) {
  const dmarc = envelope.dmarc;
  if (!dmarc || !dmarc.success) return false;

  return dmarc.result === 'pass';
}
```

```typescript
type DmarcCheckResult = 'pass' | 'fail' | 'none' | 'temperror' | 'permerror';

interface DkimResult {
  result: 'pass' | 'fail' | 'neutral' | 'temperror' | 'permerror';
  error_message?: string;
  domain?: string;
  selector?: string;
}

interface DmarcDetails {
  domain: string;
  policy: 'none' | 'quarantine' | 'reject';
  spf_result: 'pass' | 'fail' | 'softfail' | 'neutral' | 'none' | 'temperror' | 'permerror';
  dmarc_spf_result: DmarcCheckResult;
  dmarc_spf_error_message?: string;
  dmarc_dkim_result: DmarcCheckResult;
  dkim_error_message?: string;
  dkim_results: DkimResult[];
}

interface Envelope {
  dmarc?: {
    success: boolean;
    result?: 'pass' | 'fail';
    details?: DmarcDetails;
  };
}

function dmarcPassed(envelope: Envelope): boolean {
  const dmarc = envelope.dmarc;
  if (!dmarc || !dmarc.success) return false;

  return dmarc.result === 'pass';
}
```

```ruby
def dmarc_passed?(envelope)
  dmarc = envelope['dmarc']
  return false unless dmarc && dmarc['success']

  dmarc['result'] == 'pass'
end
```

```python
def dmarc_passed(envelope):
    dmarc = envelope.get('dmarc')
    if not dmarc or not dmarc.get('success'):
        return False

    return dmarc.get('result') == 'pass'
```

```php
function dmarc_passed($envelope) {
    $dmarc = $envelope['dmarc'] ?? null;
    if (!$dmarc || !$dmarc['success']) {
        return false;
    }

    return $dmarc['result'] === 'pass';
}
```

```go
func dmarcPassed(envelope map[string]interface{}) bool {
    dmarc, ok := envelope["dmarc"].(map[string]interface{})
    if !ok || dmarc["success"] != true {
        return false
    }

    return dmarc["result"] == "pass"
}
```

These examples are for the JSON format. With the multipart formats, `success` is the string `"true"`.

## Understanding DMARC Alignment

DMARC requires that either SPF or DKIM "aligns" with the From header domain. This means:

- **SPF alignment**: SPF passed and the envelope sender (Return-Path) domain matches the From header domain
- **DKIM alignment**: a DKIM signature passed and its domain (`d=` tag) matches the From header domain

Unless the domain's policy asks for strict alignment, a match on the organizational domain counts (for example `mail.example.com` aligns with `example.com`).

The `dmarc_spf_result` and `dmarc_dkim_result` fields show the result after checking alignment, which may differ from the raw SPF/DKIM results. Alignment is only checked when the underlying check passed, so these fields are `none` when SPF didn't pass or no DKIM signature passed, and also when the domain has no DMARC record.

## DMARC Policies

The sender's DMARC policy tells you what action they recommend when authentication fails:

| Policy | Description |
|--------|-------------|
| `none` | No specific action requested (monitoring mode), or no DMARC record. |
| `quarantine` | Treat failing messages with suspicion (e.g., move to spam). |
| `reject` | Reject failing messages outright. |

CloudMailin doesn't apply the policy for you. You can use the policy field to decide how strictly to handle messages that fail DMARC.

## Enable DMARC Verification

DMARC verification for inbound email is a beta feature available on request. Please [contact us] to discuss enabling it for your account.

[contact us]: https://www.cloudmailin.com/contact_us
