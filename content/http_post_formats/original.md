---
title: Original HTTP POST Format
---

# Original HTTP POST Format

The original HTTP POST Format transfers emails to your web app using `multipart/form-data` requests. The POST contains the following parameters:

| Parameter     | Description |
|------------------------|
| `message`         | The message itself. This will be the entire message and will need to be manually parsed by your code if you wish to make use of this parameter. | 
| `plain`           | The plain text extracted from the raw message. This will be the first text/plain part of the email if the message is multipart and the body if the content is not multipart. |
| `html`            | The html text extracted from the raw message. This will be the first text/html part of an email if the message is multipart. |
| `to`              | The form header as specified in the envelope by the sending server. This could be different to the to address specified in the message itself. If you are forwarding email from your domain you will want to extract the recipient from the email using the `x_header_to` parameter. |
| `disposable`      | The disposable part of the email address if it exists. For example if your email address was example+something@example.com, the disposable would contain 'something'. |
| `x_to_header`     | The to addresses found in the message itself and will be listed separated by a comma. |
| `x_cc_header`     | This is a new header that is being tested and we would appreciate feedback for. The CC addresses found in the message header will be listed separated by a comma.
| `from`            | The form header as specified in the envelope by the sending server. |
| `x_from_header`   | The from addresses found in the message itself and will be listed separated by a comma.
| `x_sender`        | This will send the x-sender header from the mail message if it is present. This parameter will likely always be experimental as only some servers will include this header. |
| `subject`         | The subject of the message extracted from the message itself. |
| `x_forwarded_for `| This will send the x-forwarded-for header from the mail message if it is present. This is often included by forwarding email servers to show the original to address the message was sent to. This parameter will likely always be experimental as only some servers will include this header.
| `reply_plain`     | The plain text reply extracted from this message is present / found. |
| `signature`       | The signature of the message encoded with your private key. You can use this to ensure that the HTTP POST data has come from CloudMailin. See [here](#validating_the_sender) for more details.
| `spf`             | The [SPF](/features/spf/) result for the given IP address and Domain. Passed as `spf['result']` and `spf['domain']`. |

## Attachments

It is possible to have CloudMailin extract the attachments from your email and send those attachments directly to an attachment store (S3 bucket).

With this format if you do not use an attachment store then attachments will remain nested within the email itself.
You can parse the attachments yourself from the `message` parameter.
If you wish to have attachments parsed and sent directly to your app we suggest you look at the other [http_post_formats](/http_post_formats/).
However, if you choose to use an attachment store the following additional parameters will be delivered:

| Parameter                           | Description                              |
|--------------------------------------------------------------------------------|
| `attachments[index][file_name]`     | The original file name of the attachment |
| `attachments[index][content_type]`  | The content type of the attachment |
| `attachments[index][url]`           | The url of the file uploaded to S3. This can be used to extract the bucket, path and filename if required. |
| `attachments[index][size]`          | The length of the attachment store in S3 sent in bytes |
| `attachments[index][disposition]`   | The content disposition of the attachment. This is useful for determining if the attachment was inline. *Note:* this will only be passed if the disposition is **not attachment** |

Index refers to the current attachment number starting at 0.

Some frameworks will automatically extract these nested parameters using the brackets into an array or hash. In Rails for example these attachments will form a hash like the following:
    
    {'attachments' => {'0' => {'file_name' => 'test.jpg'}}}
    puts params[:attachments]['0'][:file_name] #outputs test.jpg
    
More details about configuring attachments to be sent directly to an attachment store can be found [here](/receiving_email/attachments/).

## Validating the Sender
The original POST format also includes a signature parameter. We no longer recommend the use of this signature and instead we recommend HTTPS and basic authentication.

When an email is posted to your web server by the original POST format it will be signed to enable you to check that the message was received by CloudMailin and it is not an attempt by another system to falsely present itself as the CloudMailin server. If you do not wish to validate the message then you don't have to do anything.

To ensure that the message comes from CloudMailin the server uses a private shared secret that is specific to that CloudMailin address. To check the signature first you need to get your secret. The secret can be found by logging into your CloudMailin account and looking for the secret on the address page.

Once you know the secret it is simply a case of creating your own signature for the message and ensuring that the signature given matches the one that you have created.

The steps to create the signature are as follows:

  1. Remove the signature from the list of parameters passed to your application.
  2. Take each of the other parameters and sort them alphabetically by the keys.
  3. Create a string by appending only the values of the parameters in this new order.
  4. Add the secret to the end of the new string.
  5. Create an MD5 hash of this string.
  
__Note:__ It is important to realise that this does not prevent users from constructing emails that fake headers to falsify information such as the message sender. For this we recommend using the disposable email + syntax in the CloudMailin address to give each sender a unique email address to send to.

### Examples

  * [Rails](#rails)
  * [Play](#play)

#### Rails
The following code can be used to validate the signature in Rails.

    def verify_signature
      provided = request.request_parameters.delete(:signature)
      signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + SECRET)

      if provided != signature
        render :text => "Message signature fail #{provided} != #{signature}", :status => 403
        return false 
      end
    end
    
A more advanced example can also flatten the parameters passed to the signature verification function for use when attachments are passed.

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

We recommend using a before filter to run this code. More details can be found in [this example](https://github.com/CloudMailin/cloudmailin-rails3/blob/master/app/controllers/incoming_mails_controller.rb) in the [Rails Sample App](https://github.com/CloudMailin/cloudmailin-rails3). The CloudMailin incoming mail example on Github contains with a more detailed example that will flatten the parameters for validation when attachments are also included.

#### Play!

These utility methods verify the signature on Cloudmailin's HTTP POST. See `Mail.incomingMail` for example usage:

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
