---
title: Securing HTTP POSTS you receive from CloudMailin emails
---

# Ensuring that the Email and HTTP POST comes from CloudMailin

CloudMailin will send your email as an HTTP POST, but how can you ensure that the POST is actually coming from CloudMailin and not from another source attempting to send messages on our behalf?

CloudMailin provides two solutions to this problem:

| Type                                                    | Availability      | Description                                               |
|---------------------------------------------------------|-------------------|-----------------------------------------------------------|
| [Basic Authentication](#basic-authentication-and-https) | `All Formats`     | When used with HTTPS this provides a simple and effective way to secure your target and ensure that only CloudMailin has permission to post to it |
| [Signed Requests](#signed-requests) | `Original Format` | Provided for the Original Format but **now Deprecated**. |

## Basic Authentication and HTTPS

We recommend that all requests CloudMailin makes to your target URL are over HTTPS using basic authentication. This ensures that only CloudMailin is able to POST requests to this URL.

Unlike the Signed requests using Basic Authentication to secure your request is really simple. You simply pass a username and password within your target URL as you set it. We will then extract this username and password and add it the headers of each request that we make. For example:

```
https://user:mypass@cloudmailin.com/target/200
```

The example above would pass along the username and password would pass `user` and `mypass` along to the application. This would add the following HTTP header to the request:

```http
Authorization: Basic dXNlcjpteXBhc3M=
```

The string `dXNlcjpteXBhc3M=` is simply a Base64 encoded representation of `user:mypass`. Most frameworks will even deal with this for you. For example in Rails you can use the following method to check Basic Authenticationt.

```ruby
class MyController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "mypass"
end
```


### URL Encoding Usernames and Passwords

It's important to remember that you're specifying your username and password as part of a URL. Therefore if you want to use usernames and passwords that contain certain symbols (such as the `@` symbol) you'll need to URL encode them.

For example `youremail@yourdomain.com` should be encoded as `youremail%40yourdomain.com`. This would make the URL something like the following:

```
https://youremail%40yourdomain.com:password@yourdomain.com/incoming_mails/
```

Note that the actual `@` character is used to show that we're passing credentials and the `:` is used to seperate the username and password. If you need help converting to the URL encoded format checkout [this converter](http://meyerweb.com/eric/tools/dencoder/) by Eric Meyer. We've also included a few common characters in the table below:

| Character | URL Encoded Version |
|-----------|---------------------|
| `!`       | `%21`               |
| `[space]` | `%20`               |
| `@`       | `%40`               |
| `$`       | `%24`               |
| `%`       | `%25`               |
| `^`       | `%5E`               |
| `&`       | `%26`               |
| `*`       | `%2A`               |
| `(`       | `%28`               |
| `)`       | `%29`               |
| `?`       | `%3F`               |
| `,`       | `%2C`               |
| `=`       | `%3D`               |


## Signed Requests

> The original POST format also includes a signature parameter.
> We no longer recommend the use of this signature and instead we recommend HTTPS and basic authentication.

When an email is posted to your web server by the original POST format it will be signed to enable you to check that the message was received by CloudMailin and it is not an attempt by another system to falsely present itself as the CloudMailin server. If you do not wish to validate the message then you don't have to do anything.

To ensure that the message comes from CloudMailin the server uses a private shared secret that is specific to that CloudMailin address. To check the signature first you need to get your secret. The secret can be found by logging into your CloudMailin account and looking for the secret on the address page.

Once you know the secret it is simply a case of creating your own signature for the message and ensuring that the signature given matches the one that you have created.

The steps to create the signature are as follows:

  1. Remove the signature from the list of parameters passed to your application.
  2. Take each of the other parameters and sort them alphabetically by the keys.
  3. Create a string by appending only the values of the parameters in this new order.
  4. Add the secret to the end of the new string.
  5. Create an MD5 hash of this string.

__Note:__ It is important to realise that this does not prevent users from constructing emails that fake headers to falsify information such as the message sender. For this we recommend using the disposable email + syntax in the CloudMailin address to give each sender a unique email address to send to. [SPF](/features/spf/) can also be used to verify that the sending IP address has permission to send this email.

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

A more advanced example can also flatten the parameters passed to the signature verification function for use when attachments are passed.

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

We recommend using a before filter to run this code. More details can be found in [this example](https://github.com/CloudMailin/cloudmailin-rails3/blob/master/app/controllers/incoming_mails_controller.rb) in the [Rails Sample App](https://github.com/CloudMailin/cloudmailin-rails3). The CloudMailin incoming mail example on Github contains with a more detailed example that will flatten the parameters for validation when attachments are also included.

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
