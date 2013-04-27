---
title: Receiving Email with Ruby
skip_erb: true
---

# Receiving Email with Ruby

<div class="warning">This example may be outdated. You can now find examples for newer POST formats within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

## Rails 3

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

Alternatively Rails can handle the parsed versions of CloudMailin's [HTTP POST Formats](/http_post_formats/) automatically. An example reading the subject and body from address might be:

    class IncomingMailsController < ApplicationController    
      skip_before_filter :verify_authenticity_token
  
      def create
        Rails.logger.info params[:headers][:subject]
        Rails.logger.info params[:plain]
        Rails.logger.info params[:html]
    
        # Do some other stuff with the mail message
        if params[:envelope][:from] != 'expected_user@example.com'
          render :text => 'success', :status => 200
        else
          render :text => 'Unknown user', :status => 404 # 404 would reject the mail
        end
      end
    end

Then log into [CloudMailin](http://www.cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mails and thats it! 


## Rails (2.3.x)
First we are going to use the [mail gem](https://github.com/mikel/mail/). You could of course use TMail but we personally think mail's much nicer.

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

Then log into [CloudMailin](http://www.cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mails and thats it!


## Sinatra
Parsing incoming mail in Sinatra is really simple. Just make sure the mail gem is installed then you can require 'mail' and add a post method to deal with the message.

    require 'mail'

    post '/incoming_mail' do
      mail = Mail.new(params[:message])
      # do something with mail
      'success'
    end

Then log into [CloudMailin](http://www.cloudmailin.com) and make sure you set your address to deliver to http://yourdomain.com/incoming_mail and thats it!