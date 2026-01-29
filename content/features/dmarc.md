---
title: DMARC Verification for Inbound Email
---

# Verifying Incoming Email with DMARC

DMARC (Domain-based Message Authentication, Reporting and Conformance) builds on SPF and DKIM to provide a policy framework for email authentication. It tells receiving servers what to do when an email fails authentication checks and provides reporting back to domain owners.

> **Experimental Feature:** DMARC verification for inbound email is available on request. Please [contact us] to enable this feature for your account.

## How DMARC Verification Works

When DMARC verification is enabled, CloudMailin will:

1. Check the sender's DMARC policy in DNS
2. Verify SPF and DKIM alignment with the From header domain
3. Apply the domain's DMARC policy
4. Pass the result and details to your webhook in the envelope

## DMARC Results

| Result | Description |
|--------|-------------|
| `pass` | The message passed DMARC verification (either SPF or DKIM aligned and passed). |
| `fail` | The message failed DMARC verification. |
| `none` | No DMARC policy was found for the domain. |
| `temperror` | A temporary error occurred during verification. |
| `permerror` | A permanent error occurred (e.g., malformed DMARC record). |

## Envelope Format

When DMARC verification is enabled, the envelope will include a `dmarc` object:

```json
"envelope": {
  ...
  "dmarc": {
    "success": true,
    "result": "pass",
    "details": {
      "domain": "cloudmailin.net",
      "policy": "quarantine",
      "spf_result": "pass",
      "dmarc_spf_result": "pass",
      "dmarc_dkim_result": "pass",
      "dkim_results": [
        {
          "result": "pass",
          "domain": "cloudmailin.net",
          "selector": "selector1"
        }
      ]
    }
  }
}
```

### DMARC Fields

| Field | Description |
|-------|-------------|
| `success` | Whether the DMARC check completed successfully (boolean). |
| `result` | The overall DMARC result (`pass`, `fail`, `none`, `temperror`, `permerror`). |
| `details` | Additional information about the verification. |

### Details Fields

| Field | Description |
|-------|-------------|
| `domain` | The domain that was checked for DMARC policy. |
| `policy` | The sender's DMARC policy (`none`, `quarantine`, `reject`). |
| `spf_result` | The raw SPF result. |
| `dmarc_spf_result` | The SPF result after DMARC alignment check. |
| `dmarc_dkim_result` | The DKIM result after DMARC alignment check. |
| `dkim_results` | Array of DKIM verification results (same format as the [DKIM envelope](/features/dkim/)). |

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
interface DmarcDetails {
  domain: string;
  policy: 'none' | 'quarantine' | 'reject';
  spf_result: string;
  dmarc_spf_result: string;
  dmarc_dkim_result: string;
  dkim_results: Array<{
    result: string;
    domain: string;
    selector: string;
  }>;
}

interface Envelope {
  dmarc?: {
    success: boolean;
    result: 'pass' | 'fail' | 'none' | 'temperror' | 'permerror';
    details: DmarcDetails;
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

## Understanding DMARC Alignment

DMARC requires that either SPF or DKIM "aligns" with the From header domain. This means:

- **SPF alignment**: The domain in the Return-Path matches the From header domain
- **DKIM alignment**: The domain in the DKIM signature (`d=` tag) matches the From header domain

The `dmarc_spf_result` and `dmarc_dkim_result` fields show the result after checking alignment, which may differ from the raw SPF/DKIM results.

## DMARC Policies

The sender's DMARC policy tells you what action they recommend when authentication fails:

| Policy | Description |
|--------|-------------|
| `none` | No specific action requested (monitoring mode). |
| `quarantine` | Treat failing messages with suspicion (e.g., move to spam). |
| `reject` | Reject failing messages outright. |

You can use the policy field to decide how strictly to handle messages that fail DMARC.

## Enable DMARC Verification

DMARC verification for inbound email is an experimental feature available on request. Please [contact us] to discuss enabling it for your account.

[contact us]: https://www.cloudmailin.com/contact_us
