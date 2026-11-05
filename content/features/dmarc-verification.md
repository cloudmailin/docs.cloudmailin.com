---
title: DMARC Verification for Inbound Email
---

# Verifying Incoming Email with DMARC

DMARC (Domain-based Message Authentication, Reporting and Conformance) builds on SPF and DKIM to provide a policy framework for email authentication. It tells receiving servers what to do when an email fails authentication checks and provides reporting back to domain owners.

> **Beta Feature:** DMARC verification for inbound email is available on request. Please [contact us] to enable this feature for your account. As this is a beta feature, the format may change.

## How DMARC Verification Works

When DMARC verification is enabled, CloudMailin will:

1. Look up the DMARC policy for the domain in the message's From header
2. Check SPF (using the envelope sender) and DKIM, and whether each one aligns with the From header domain
3. Pass the result and details to your webhook in the envelope

CloudMailin only adds this information to the envelope. We never reject, bounce or hold a message because of its DMARC result or the sender's policy, so the message is delivered to your target as normal and it's up to you to decide what to do with it.

## DMARC Results

The overall `result` is one of five values:

| Result | Description |
|--------|-------------|
| `pass` | SPF or DKIM passed and aligned with the From header domain, under a published DMARC policy. |
| `fail` | The From domain publishes a DMARC policy and nothing aligned passed. This is the only result where the sender's `policy` is meant to be applied. |
| `temperror` | The check was inconclusive: an aligned SPF or DKIM check, or the DMARC record lookup, hit a DNS error or ran out of time. See [Temporary and Permanent Errors](#temporary-and-permanent-errors). |
| `permerror` | The DMARC record lookup failed for a lasting reason, for example the From domain isn't a valid DNS name. |
| `none` | DMARC doesn't apply: the From domain publishes no DMARC record (see [No DMARC Record](#no-dmarc-record)), or the message has no single From domain. |

Only `fail` is a failure by the sender. A `temperror` or `permerror` says that we couldn't complete the check, and `none` says there was no policy to check against, so neither should be treated as a reason to reject the message.

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
| `result` | The overall DMARC result (`pass`, `fail`, `temperror`, `permerror`, `none`). |
| `details` | Additional information about the verification. |

### Details Fields

| Field | Description |
|-------|-------------|
| `domain` | The From header domain that was checked. This is empty if the message has no From address, or From addresses with different domains. |
| `policy` | The policy that applies to the domain (`none`, `quarantine`, `reject`). This is `none` when the domain has no DMARC record, and `unknown` when the record lookup [timed out](#temporary-and-permanent-errors). |
| `spf_result` | The raw SPF result for the envelope sender, or for the HELO domain when the message has a null sender (`pass`, `fail`, `softfail`, `neutral`, `none`, `temperror`, `permerror`). |
| `spf_error_message` | Only present when SPF couldn't be evaluated at all, so `spf_result` is `temperror`, for example because the SPF lookups timed out. |
| `dmarc_spf_result` | The SPF result after the DMARC alignment check (`pass`, `fail`, `none`, `temperror`, `permerror`). |
| `dmarc_spf_error_message` | Only present when `dmarc_spf_result` is not `pass` or `none`, for example `policy not aligned`. |
| `dmarc_dkim_result` | The DKIM result after the DMARC alignment check (`pass`, `fail`, `none`, `temperror`, `permerror`). |
| `dkim_error_message` | Only present when `dmarc_dkim_result` is not `pass` or `none`, for example `policy not aligned`. |
| `dkim_results` | Array of DKIM verification results (same format as the [DKIM envelope](/features/dkim/)). |

The error message fields are there to help with debugging. Their wording comes from the underlying library and may change, so we recommend not matching on them.

## No DMARC Record

When the From domain doesn't publish a DMARC record (and neither does its organizational domain), `result` is `none` and `policy` is `none`. The raw `spf_result` and `dkim_results` are still filled in, but no alignment check is made, so `dmarc_spf_result` and `dmarc_dkim_result` are both `none` even if SPF and DKIM passed for the From domain:

```json
"dmarc": {
  "success": true,
  "result": "none",
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

The DMARC record itself isn't included, so a `policy` of `none` can mean either that there is no record or that the domain publishes `p=none`. The overall `result` tells them apart: a domain with no record gives `none`, while a domain publishing `p=none` gives `pass` or `fail` like any other policy. Either way, the domain isn't asking you to quarantine or reject failing mail.

A record without a `p=` tag counts as `p=none` when it has a `rua=` reporting address, and is otherwise treated as no record.

## Temporary and Permanent Errors

A `temperror` means the check was inconclusive. It is not a failure by the sender and shouldn't be treated as a reason to reject the message. It happens when:

- the DNS lookup for the DMARC record hits a temporary error. `dmarc_spf_result` and `dmarc_dkim_result` are both `temperror`, each with an error message, and `policy` is `none`.
- the DMARC record lookup runs out of time. `dmarc_spf_result` and `dmarc_dkim_result` are both `temperror` and `policy` is `unknown`, because we couldn't find out what the domain publishes. The raw `spf_result` and `dkim_results` are still filled in.
- SPF or a DKIM signature that aligns with the From domain can't be checked, for example because its DNS lookup timed out. Only an aligned check can do this: a `temperror` on a signature for an unrelated domain is ignored, so it can't turn a `fail` into a `temperror`.

A `permerror` means the DMARC record lookup failed for a lasting reason, for example the From domain isn't a valid DNS name. `dmarc_spf_result` and `dmarc_dkim_result` are both `permerror`, each with an error message, and `policy` is `none`.

For example, a message whose DMARC record lookup timed out:

```json
"dmarc": {
  "success": true,
  "result": "temperror",
  "details": {
    "spf_result": "pass",
    "dmarc_spf_result": "temperror",
    "dmarc_spf_error_message": "dmarc policy lookup timed out after 5s",
    "dmarc_dkim_result": "temperror",
    "dkim_error_message": "dmarc policy lookup timed out after 5s",
    "domain": "example.com",
    "policy": "unknown",
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
  result: 'pass' | 'fail' | 'neutral' | 'temperror' | 'permerror' | 'none';
  error_message?: string;
  domain?: string;
  selector?: string;
}

interface DmarcDetails {
  domain: string;
  policy: 'none' | 'quarantine' | 'reject' | 'unknown';
  spf_result: 'pass' | 'fail' | 'softfail' | 'neutral' | 'none' | 'temperror' | 'permerror';
  spf_error_message?: string;
  dmarc_spf_result: DmarcCheckResult;
  dmarc_spf_error_message?: string;
  dmarc_dkim_result: DmarcCheckResult;
  dkim_error_message?: string;
  dkim_results: DkimResult[];
}

interface Envelope {
  dmarc?: {
    success: boolean;
    result?: DmarcCheckResult;
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

- **SPF alignment**: SPF passed and the envelope sender (Return-Path) domain, or the HELO domain for a null sender, matches the From header domain
- **DKIM alignment**: a DKIM signature passed and its domain (`d=` tag) matches the From header domain

Unless the domain's policy asks for strict alignment, a match on the organizational domain counts (for example `mail.example.com` aligns with `example.com`).

The `dmarc_spf_result` and `dmarc_dkim_result` fields show the result after checking alignment, which may differ from the raw SPF/DKIM results. Alignment is only checked when the underlying check passed or was a `temperror`, so these fields are `none` when SPF didn't pass or no DKIM signature passed, and also when the domain has no DMARC record. An aligned `temperror` is passed through as `temperror`; an unaligned one is reported as `none`.

## DMARC Policies

The sender's DMARC policy tells you what action they recommend when authentication fails:

| Policy | Description |
|--------|-------------|
| `none` | No specific action requested (monitoring mode), or no DMARC record. |
| `quarantine` | Treat failing messages with suspicion (e.g., move to spam). |
| `reject` | Reject failing messages outright. |
| `unknown` | The record lookup timed out, so we don't know what the domain publishes. Only appears with a `result` of `temperror`. |

The policy shown is the one that applies to the From domain, so a subdomain may get the record's `sp=` (or `np=`) policy rather than its `p=`, and a record in test mode (`t=y`) is reported one level down (`reject` as `quarantine`, `quarantine` as `none`).

CloudMailin doesn't apply the policy for you. You can use the policy field to decide how strictly to handle messages that fail DMARC.

## Enable DMARC Verification

DMARC verification for inbound email is a beta feature available on request. Please [contact us] to discuss enabling it for your account.

[contact us]: https://www.cloudmailin.com/contact_us
