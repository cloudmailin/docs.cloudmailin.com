# Ensuring the message is from CloudMailin
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
The following code can be used to validate the signature in Rails. We recommend using a before filter to run this code. More details can be found in [this commit](http://github.com/CloudMailin/cloudmailin-rails3/commit/77556d1959cc33c6f3b0669fa908c72ec732b1f9) to the [Rails Sample App](http://github.com/CloudMailin/cloudmailin-rails3).

    def verify_signature
      provided = request.request_parameters.delete(:signature)
      signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + SECRET)
    
      if provided != signature
        render :text => "Message signature fail #{provided} != #{signature}", :status => 403
        return false 
      end
    end