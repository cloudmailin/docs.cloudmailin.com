# Parsing Email
## Ruby

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