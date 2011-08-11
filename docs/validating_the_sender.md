# Ensuring the message is from CloudMailin

## Using HTTPS and Basic Auth
It is possible to deliver CloudMailin messages to an HTTPS secured end point. When using HTTPS you can also pass a username and password via basic authentication in order to prevent unauthorized users posting to your application. When setting your target you can set the address in the following format for basic authentication parameters to be passed.

    https://username:password@yourdomain.com

## Checking the signature of a message

When an email is posted to your web server it will be signed to enable you to check that the message was received by CloudMailin and it is not an attempt by another system to falsely present itself as the CloudMailin server. If you do not wish to validate the message then you don't have to do anything.

To ensure that the message comes from CloudMailin the server uses a private shared secret that is specific to that CloudMailin address. To check the signature first you need to get your secret. The secret can be found by logging into your CloudMailin account and looking for the secret on the address page.

Once you know the secret it is simply a case of creating your own signature for the message and ensuring that the signature given matches the one that you have created.

The steps to create the signature are as follows:

  1. Remove the signature from the list of parameters passed to your application.
  2. Take each of the other parameters and sort them alphabetically by the keys.
  3. Create a string by appending only the values of the parameters in this new order.
  4. Add the secret to the end of the new string.
  5. Create an MD5 hash of this string.
  
__Note:__ It is important to realise that this does not prevent users from constructing emails that fake headers to falsify information such as the message sender. For this we recommend using the disposable email + syntax in the CloudMailin address to give each sender a unique email address to send to.

## Examples:
### Rails
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

We recommend using a before filter to run this code. More details can be found in [this example](https://github.com/CloudMailin/cloudmailin-rails3/blob/master/app/controllers/incoming_mails_controller.rb) in the [Rails Sample App](http://github.com/CloudMailin/cloudmailin-rails3). The CloudMailin incoming mail example on Github contains with a more detailed example that will flatten the parameters for validation when attachments are also included.