---
title: DKIM Verification for Inbound Email
---

# Verifying Incoming Email with DKIM

DKIM (DomainKeys Identified Mail) verification checks that incoming emails have a valid cryptographic signature from the sending domain. This helps confirm that the message hasn't been altered in transit and that it genuinely originated from the claimed sender's mail server.

> **Experimental Feature:** DKIM verification for inbound email is available on request. Please [contact us] to enable this feature for your account.

## How DKIM Verification Works

When DKIM verification is enabled, CloudMailin will:

1. Extract the DKIM signature from the incoming email headers
2. Fetch the sender's public key from DNS
3. Verify the signature against the message content
4. Pass the result to your webhook in the envelope

## DKIM Results

The DKIM verification result is included in the `envelope` parameter of the HTTP POST. Unlike SPF which returns a single result, DKIM can return multiple results if the message has multiple signatures.

| Result | Description |
|--------|-------------|
| `pass` | The DKIM signature was verified successfully. The message is authentic and unaltered. |
| `fail` | The signature verification failed. The message may have been altered, or the signature is invalid. |
| `neutral` | The message has no DKIM signature, or the check could not be performed. |
| `temperror` | A temporary error occurred (e.g., DNS timeout when fetching the public key). |
| `permerror` | A permanent error occurred (e.g., malformed signature or missing DNS record). |

## Envelope Format

When DKIM verification is enabled, the envelope will include a `dkim` object with the verification results:

```json
"envelope": {
  ...
  "dkim": {
    "success": true,
    "result": [
      {
        "result": "pass",
        "domain": "cloudmailin.net",
        "selector": "selector1"
      }
    ]
  }
}
```

The `dkim.result` field is an array because a single email can have multiple DKIM signatures (e.g., from the original sender and from a mailing list processor).

### DKIM Fields

| Field | Description |
|-------|-------------|
| `success` | Whether the DKIM check completed successfully (boolean). |
| `result` | An array of verification results, one per DKIM signature found. |

Each entry in the `result` array contains:

| Field | Description |
|-------|-------------|
| `result` | The verification result (`pass`, `fail`, `neutral`, `temperror`, `permerror`). |
| `domain` | The domain that signed the message (from the `d=` tag in the signature). |
| `selector` | The DKIM selector used (from the `s=` tag in the signature). |

## Using DKIM Results

To check if a message passed DKIM verification, look for at least one `pass` result in the array:

```javascript
function dkimPassed(envelope) {
  const dkim = envelope.dkim;
  if (!dkim || !dkim.success || !dkim.result) return false;

  return dkim.result.some(r => r.result === 'pass');
}
```

```typescript
interface DkimResult {
  result: 'pass' | 'fail' | 'neutral' | 'temperror' | 'permerror';
  domain: string;
  selector: string;
}

interface Envelope {
  dkim?: {
    success: boolean;
    result: DkimResult[];
  };
}

function dkimPassed(envelope: Envelope): boolean {
  const dkim = envelope.dkim;
  if (!dkim || !dkim.success || !dkim.result) return false;

  return dkim.result.some(r => r.result === 'pass');
}
```

```ruby
def dkim_passed?(envelope)
  dkim = envelope['dkim']
  return false unless dkim && dkim['success'] && dkim['result']

  dkim['result'].any? { |r| r['result'] == 'pass' }
end
```

```python
def dkim_passed(envelope):
    dkim = envelope.get('dkim')
    if not dkim or not dkim.get('success') or not dkim.get('result'):
        return False

    return any(r.get('result') == 'pass' for r in dkim['result'])
```

```php
function dkim_passed($envelope) {
    $dkim = $envelope['dkim'] ?? null;
    if (!$dkim || !$dkim['success'] || !$dkim['result']) {
        return false;
    }

    foreach ($dkim['result'] as $r) {
        if ($r['result'] === 'pass') {
            return true;
        }
    }
    return false;
}
```

```go
func dkimPassed(envelope map[string]interface{}) bool {
    dkim, ok := envelope["dkim"].(map[string]interface{})
    if !ok || dkim["success"] != true {
        return false
    }

    results, ok := dkim["result"].([]interface{})
    if !ok {
        return false
    }

    for _, r := range results {
        if result, ok := r.(map[string]interface{}); ok {
            if result["result"] == "pass" {
                return true
            }
        }
    }
    return false
}
```

## Combining with SPF and DMARC

For the strongest email authentication, combine DKIM verification with [SPF](/features/spf/) and [DMARC](/features/dmarc/) checking. Together, these form the standard email authentication stack.

A message should ideally pass both SPF and DKIM to be considered fully authenticated. However, legitimate emails sometimes fail one check due to forwarding or mailing list processing, so consider your use case when deciding how strictly to enforce these checks.

## Enable DKIM Verification

DKIM verification for inbound email is an experimental feature available on request. Please [contact us] to discuss enabling it for your account.

[contact us]: https://www.cloudmailin.com/contact_us
