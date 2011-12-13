# Parsing Email

  * [Ruby](#ruby)
  * [Node.js](#node)
  * [Python](#python)
  * [.Net](#net)
  * [Java](#java)
  * [PHP](#php)
  * [Anything Else](#others)

## Ruby <a id="ruby"></a>

### Rails 3.0 beta_x
Rails 3 already makes use of mail instead of using TMail that was default in Rails 2.x. In Rails 3 we just have to `rails generate controller incoming_mails` to generate our controller and add a create method.

    class IncomingMailsController < ApplicationController    
      require 'mail'
      skip_before_filter :verify_authenticity_token
  
      def create
        message = Mail.new(params[:message])
        Rails.logger.log Logger::INFO, message.subject #print the subject to the logs
        Rails.logger.log Logger::INFO, message.body.decoded #print the decoded body to the logs
    
        # Do some other stuff with the mail message
    
        render :text => 'success', :status => 200 # a status of 404 would reject the mail
      end
    end

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't raise an exception because we have no way of knowing the token.

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mails and thats it! 


### Rails (2.3.x)
First we are going to use the [mail gem](http://github.com/mikel/mail/). You could of course use TMail but we personally think mail's much nicer.

    gem install mail

Once mail is installed lets add it to the environment.config

    config.gem 'mail'

Then create a controller `script/generate controller incoming_mails`. You are free to call the controller anything you like. Make sure you add your controller to your routes file (resources :incoming_mails) and then setup the create method like so.

    class IncomingMailsController < ApplicationController    
      require 'mail'
      skip_before_filter :verify_authenticity_token
      
      def create
        message = Mail.new(params[:message])
        Rails.logger.add Logger::INFO, message.subject #print the subject to the logs
        Rails.logger.add Logger::INFO, message.body.decoded #print the decoded body to the logs
        
        # Do some other stuff with the mail message
        
        render :text => 'success', :status => 200 # a status of 404 would reject the mail
      end
    end

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't raise an exception because we have no way of knowing the token.

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mails and thats it!


### Sinatra
Parsing incoming mail in Sinatra is really simple. Just make sure the mail gem is installed then you can require 'mail' and add a post method to deal with the message.

    require 'mail'

    post '/incoming_mail' do
      mail = Mail.new(params[:message])
      # do something with mail
      'success'
    end

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mail and thats it!

## Node.JS <a name="node"></a>
### Express
With express you will need to install some helpers in order to use CloudMailin's multipart form body format. In express there are two options you can either use the [connect-form](https://github.com/visionmedia/connect-form) middleware or, if you prefer, you can use the [node-formidable](https://github.com/felixge/node-formidable) module that connect-form relies on behind the scenes.

## Python <a name="python"></a>
### Django
[Jeremy Carbaugh](https://github.com/jcarbaugh) at Sunlight Foundation constructed a Django client for CloudMailin so that you can use CloudMailin to receive email easily from within your Django Apps.

The code and usage examples are up on [Github](https://github.com/CloudMailin/django-cloudmailin) so we suggest you take a look and try it out for yourself!

For this reason we decided to make our documentation system available on [Github](http://github.com/cloudmailin/docs.cloudmailin.com).
Please help us and the other people using your language out and contribute some examples and send us a pull request!

## .Net <a name="net"></a>
### ASP.NET C#
This is an extremely simple version of getting the CloudMailin HTTP POST parameters from an ASP.net application. Any help expanding this example would be greatly appreciated. This example has only been tested in .net version 2.0 which is now a little dated.

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <%@ Page Language="C#" ContentType="text/html" ResponseEncoding="UTF-8" validateRequest=false %>
      <script language="C#" runat="server">
        void Page_Load(object sender, EventArgs e) {
          String from = Request.Form["from"];
          String plain = Request.Form["plain"];
          String html = Request.Form["html"];
        }
      </script>
    </html>

In this example the message parameter is ignored although you could use a mime parsing component to read in the full message if required.

## PHP <a name="php"></a>
In PHP POST variables are available containing the fields posted by CloudMailin. Create the file `incoming_mail.php` and add the following

    <?php
      $from = $_POST['from'];
      $to = $_POST['to'];
      $plain_text = $_POST['plain'];

      header("Content-type: text/plain");

      if ($to == 'allowed@example.com'){
        header("HTTP/1.0 200 OK");
        echo('success');
      }else{
        header("HTTP/1.0 403 OK");
        echo('user not allowed here');
      }
      exit;
    ?>

In this example if the recipient doesn't match the known user we are bouncing the message using a 403 error.

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mail.php and thats it!

## Java <a name="java"></a>

### Play! 1.2.4

Here's an example of how to extract parameters from the Cloudmailin HTTP POST. First, set up a route to your controller's action in `conf/routes`:

    POST    /incoming_mail                       Mail.incomingMail

In the action method's signature, you can specify whichever parameters are relevant for your app. This example assigns `to`, `from`, `disposable`, and a list of `attachments`. All of the parameters are still available via the `params` object.

    public class Mail extends Controller {

        public static void incomingMail(String to, String from, String disposable, List<Map> attachments) {
            // Do something with mail
        }
    }

Then log into [CloudMailin](http://cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mail and thats it!

## Other Languages <a name="others"></a>
If your favourite framework is missing please let us know and we'll try to create an example. We would love to provide examples for every these languages but we feel that examples should come from people who really know the language well and with your help we can achieve that!

### Redmine
There is also a Redmine plugin for CloudMailin to allow you to [patch Redmine to use CloudMailin](http://github.com/mtah/redmine_cloudmailin_handler) to receive your incoming email.
