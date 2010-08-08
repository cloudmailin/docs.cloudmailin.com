# Getting started with CloudMailin on Heroku
## Getting started with CloudMailin on Heroku

[CloudMailin](http://cloudmailin.com) allows you to receive incoming email messages in your web app via an HTTP POST request.

When you install the CloudMailin Add-on you will be automatically given an email address to send email to. Any email sent to that address will automatically be forwarded to the web address of your choice.

## Getting Started on Heroku
To get started simply install the CloudMailin Add-on using the following command:

    heroku addons:add cloudmailin
    
This will automatically create you a CloudMailin account and create an address that will forward to the default location. Your CloudMailin email address will be stored in your Heroku Environment which can be obtained from your app by calling:

    reply_to = env['CLOUDMAILIN_FORWARD_ADDRESS']

You can also retrieve this from your command line using the Heroku Gem by issuing the following command:

    heroku config --long

## Setting the Target Location
By default CloudMailin email addresses will forward to a default end point. This location will simply accept the message and do nothing with it. In order to forward your email to your own website login to the [CloudMailin website](http://cloudmailin.com) using the username and password that can also be found in the configuration. You can then click on the address and then choose edit target to set the delivery location.

Alternatively you can choose the Add-on from the Heroku Add-ons menu and click through to edit the website that your CloudMailin address will deliver to.

## The HTTP Post Format
The CloudMailin server will send each email as an HTTP POST request. The HTTP **POST** will be sent as a _multipart/form-data_ request with the following parameters:

* _message_ - The message itself. This will be the entire message and will need to be manually parsed by your code. Take a look at the [parsing email](parsing_email) documentation to see how you can do this if you are not familiar with email messages.

* _to_ - The recipient as specified by the server, this will be the CloudMailin email address. This could be different to the to address specified in the message itself if you are forwarding email from your domain you will want to extract the recipient from the email itself.

* _from_ - The sender as specified by the server. This can differ from the sender specified within the message itself.

* _subject_ - The subject of the message extracted from the message itself.

**Note**: the message is not sent as a file instead it is as if the user pasted the message contents into a textfield.

## Parsing the message in Ruby
### Rails 3.0 beta_x
Rails 3 already makes use of mail instead of using TMail that was default in Rails 2.x. In Rails 3 we just have to `rails generate controller incoming_mails` to generate our controller and add a create method.

    class IncomingMailsController < ApplicationController    
      require 'mail'
      skip_before_filter :verify_authenticity_token
  
      def create
        message = Mail.new(params[:message])
        Rails.logger.log message.subject #print the subject to the logs
        Rails.logger.log message.body.decoded #print the decoded body to the logs
    
        # Do some other stuff with the mail message
    
        render :text => 'success', :status => 200 # a status of 404 would reject the mail
      end
    end

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't raise an exception because we have no way of knowing the token.

Make sure your target is set to http://yourdomain.com/incoming_mails and thats it!

### Rails (2.3.x)
First we are going to use the [mail gem](http://github.com/mikel/mail/) you could of course use TMail but we personally think mail's much nicer.

    gem install mail

Once mail is installed lets add it to the environment.config

    config.gem 'mail'

Then create a controller `script/generate controller incoming_mails`, you are free to call the controller anything you like. Make sure you add your controller to your routes file (resources :incoming_mails) and then setup the create method like so.

    class IncomingMailsController < ApplicationController    
      require 'mail'
      skip_before_filter :verify_authenticity_token
      
      def create
        message = Mail.new(params[:message])
        Rails.logger.log message.subject #print the subject to the logs
        Rails.logger.log message.body.decoded #print the decoded body to the logs
        
        # Do some other stuff with the mail message
        
        render :text => 'success', :status => 200 # a status of 404 would reject the mail
      end
    end

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't raise an exception because we have no way of knowing the token.

Make sure your target is set to http://yourdomain.com/incoming_mails and thats it!


### Sinatra
Parsing incoming mail in Sinatra is really simple. Just make sure the mail gem is installed then you can require 'mail' and add a post method to deal with the message.

    require 'mail'

    post '/incoming_mail' do
      mail = Mail.new(params[:message])
      # do something with mail
      'success'
    end

Make sure your target is set to http://yourdomain.com/incoming_mail and thats it!

## Rejecting the Message
If your web app accepts the message and returns a response code of 200 the server will assume everything was ok and the message was saved. However if the server receives a 404 response it will tell the server not to retry the delivery of this message. Any other response will result in a redelivery of the message after an interval.

## More Details
More details and an FAQ can be found on the [CloudMailin Docs Website](http://docs.cloudmailin.com)