---
title: Signed HTTP Requests in the Original Format
description:
  Previously CloudMailin allowed you to sign HTTP requests using a hash based
  algorithm. That approach is now deprecated and we recommend you used HTTPS
  and Basic Authentication instead.
---

## The Original format and MD5 Signed Requests (Deprecated)

> The original POST format also includes a signature parameter. We no longer
> recommend the use of this signature and instead we recommend
> [HTTPS and basic authentication].

[HTTPS and basic authentication]: /receiving_email/securing_your_email_url_target/

When an email is posted to your web server by the original POST format it will
be signed to enable you to check that the message was received by CloudMailin
and it is not an attempt by another system to falsely present itself as the
CloudMailin server. If you do not wish to validate the message then you don't
have to do anything.

To ensure that the message comes from CloudMailin the server uses a private
shared secret that is specific to that CloudMailin address. To check the
signature first you need to get your secret. The secret can be found by logging
into your CloudMailin account and looking for the secret on the address page.

Once you know the secret it is simply a case of creating your own signature for
the message and ensuring that the signature given matches the one that you have
created.

The steps to create the signature are as follows:

  1. Remove the signature from the list of parameters passed to your application.
  2. Take each of the other parameters and sort them alphabetically by the keys.
  3. Create a string by appending only the values of the parameters in this new order.
  4. Add the secret to the end of the new string.
  5. Create an MD5 hash of this string.

__Note:__ It is important to realise that this does not prevent users from
constructing emails that fake headers to falsify information such as the message
sender. For this we recommend using the disposable email + syntax in the
CloudMailin address to give each sender a unique email address to send to.
[SPF](/features/spf/) can also be used to verify that the sending IP address has
permission to send this email.

### Examples

  * [Rails](#rails)
  * [Play](#play)

#### Rails
The following code can be used to validate the signature in Rails.

```ruby
def verify_signature
  provided = request.request_parameters.delete(:signature)
  signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + SECRET)

  if provided != signature
    render :text => "Message signature fail #{provided} != #{signature}", :status => 403
    return false
  end
end
```

A more advanced example can also flatten the parameters passed to the signature
verification function for use when attachments are passed.

```ruby
def verify_signature
  provided = request.request_parameters.delete(:signature)
  signature = Digest::MD5.hexdigest(flatten_params(request.request_parameters).sort.map{|k,v| v}.join + SECRET)

  if provided != signature
    render :text => "Message signature fail #{provided} != #{signature}", :status => 403, :content_type => Mime::TEXT.to_s
    return false
  end
end

def flatten_params(params, title = nil, result = {})
  params.each do |key, value|
    if value.kind_of?(Hash)
      key_name = title ? "#{title}[#{key}]" : key
      flatten_params(value, key_name, result)
    else
      key_name = title ? "#{title}[#{key}]" : key
      result[key_name] = value
    end
  end

  return result
end
```

We recommend using a before filter to run this code. More details can be found
in
[this example](https://github.com/CloudMailin/cloudmailin-rails3/blob/master/app/controllers/incoming_mails_controller.rb)
in the [Rails Sample App](https://github.com/CloudMailin/cloudmailin-rails3).
The CloudMailin incoming mail example on Github contains with a more detailed
example that will flatten the parameters for validation when attachments are
also included.

#### Play!

These utility methods verify the signature on Cloudmailin's HTTP POST. See `Mail.incomingMail` for example usage:

```java
public class Mail extends Controller {

    public static void incomingMail(String to, String from, String disposable, List<Map> attachments) {
        boolean verified = verifySignature(params);
        if (verified == true) {
          // Do something with mail
        } else {
          badRequest();
        }
    }

    @Util
    public static boolean verifySignature(Params params) {
        java.util.SortedMap<String,String> sortedParams = new java.util.TreeMap<String,String>(params.allSimple());
        String provided = sortedParams.remove("signature");
        String created = createSignature(sortedParams);
        return created.equals(provided);
    }

    @Util
    static String createSignature(java.util.SortedMap params) {
        params.remove("signature");
        Collection values = params.values();
        StringBuilder valuesString = new StringBuilder();
        for (Object v : values) {
            valuesString.append((String) v);
        }
        valuesString.append(CLOUDMAILIN_SECRET);
        return md5(valuesString.toString());
    }

    @Util
    static String md5(String inputString) {
        byte[] inputBytes = {};
        java.security.MessageDigest md5 = null;
        try {
            inputBytes = inputString.toString().getBytes("UTF-8");
            md5 = java.security.MessageDigest.getInstance("MD5");
        } catch (java.security.NoSuchAlgorithmException e) {
            Logger.error(e.getMessage());
        } catch (UnsupportedEncodingException e) {
            Logger.error(e.getMessage());
        }
        byte[] digestBytes = md5.digest(inputBytes);

        // Generate a 32-char hex string from the bytes. Each byte must be
        // represented by a 2-char string. For bytes whose value is less than
        // 0x10, pad string with a leading "0", e.g. "09" instead of "9"
        StringBuilder result = new StringBuilder();
        for (byte b : digestBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                result.append("0");
            }
            result.append(hex);
        }
        return result.toString();
    }
}
```
