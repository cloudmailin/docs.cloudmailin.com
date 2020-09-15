---
title: Receiving Email with Ruby and Rails
skip_erb: true
---

# Receiving Inbound Email with Ruby and Rails

<div class="warning">This example may be outdated. You can now find examples for newer POST formats
within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

* [Rails 6](#receiving-email-with-rails-6)
* [Rails 3, 4 and 5](#receiving-email-with-rails-5)
* [Gridder CloudMailin](#griddler-cloudmailin-and-rails)
* [Sinatra](#receiving-mail-with-sinatra)

## Receiving email with Rails 6

Rails will automatically parse and understand our
[multipart normalized](/http_post_formats/multipart_normalized/) and
[json normalized](/http_post_formats/json_normalized/) formats.

CloudMailin will make an HTTP POST request with the content of your email message.
If you're receiving attachments we actually recommend the multipart format,
however, both will work similarly.

We'll start by making a controller to receive our mails:

```console
rails g controller IncomingMails --no-javascripts --no-stylesheets
```

Then we need to add the route for the controller. Since CloudMailin makes an
HTTP POST with the message content we'll use the create action.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :incoming_mails, only: [:create]
end
```

Then we need to add the following to our `IncomingMailsController` at
`app/controllers/incoming_mails.rb`

```ruby
# app/controllers/incoming_mails.rb
class IncomingMailsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    Rails.logger.debug params.inspect
    Rails.logger.debug "Received: #{mail_params[:headers][:subject]} for #{mail_params[:envelope][:to]}"
  end

  protected

  # We might need to permit parameters here because we're going
  # to ensure only CloudMailin can post we will permit all here.
  # You might want to review this yourself.
  def mail_params
    params.permit!
  end
end
```

Thats it! We now just make sure that our target is set to `http://example.com/incoming_mails`
(replace example.com with your app's URL) and send our first message.

For more details see the [POST formats](/http_post_formats/) section.

### Securing the endpoint

CloudMailin uses basic auth to secure your endpoint and prevent and unwanted posts.
We also use the [HTTP status](/receiving_email/http_status_codes/)
to ensure that we want to accept the message.

We can handle these two things by doing something like the following:

```ruby
class IncomingMailsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_cloudmailin, only: [:create]

  def create
    Rails.logger.debug params.inspect
    Rails.logger.debug "Received: #{params[:headers][:subject]} for #{params[:envelope][:to]}"

    if ENV['CLOUDMAILIN_ADDRESS'].blank? || params[:envelope][:to] == ENV['CLOUDMAILIN_ADDRESS']
      head :created
    else
      render plain: "Unknown user #{params[:envelope][:to]}", status: :not_found
    end
  end

  protected

  def authenticate_cloudmailin
    auth = authenticate_with_http_basic do |username, password|
      username == 'cloudmailin' && password == (ENV['password'] || 'password')
    end
    return true if auth

    render plain: "Invalid credentials", status: :unauthorized
  end
end
```

Now when we send a message we first make sure that the basic auth username and password match.
If not we'll raise a `401` status code. This will in turn bounce the email.
If they do then we're also checking to see that the recipient matches an email address we expect.
If it does then we'll accept the message and return `201 created` if not a `404 not found`.

The text content can then be seen within the CloudMailin dashboard for that message if an error
is returned to aid debugging.

### Attachments

Attachments are made really easy by Rails in the multipart format.
All of your attachments are stored like normal file uploads in the attachments parameter.

You can access the attachments like so:

```ruby
class IncomingMailsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    params[:attachments].each do |attachment|
      Rails.logger.debug attachment.inspect
    end
  end
end
```

This will output something like the following to the logs:

```
Processing by IncomingMailsController#create as */*
...
Received: Test Subject for client_test@cloudmailin.net
#<ActionDispatch::Http::UploadedFile:0x007fcf10001e00 @tempfile=#<Tempfile:/var/folders/q2/qvbyz825247_9973sb_58jv40000gn/T/RackMultipart20170411-47907-evo59l.png>, @original_filename="rails.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"attachments[]\"; filename=\"rails.png\"\r\nContent-Type: image/png\r\n">
#<ActionDispatch::Http::UploadedFile:0x007fcf10001dd8 @tempfile=#<Tempfile:/var/folders/q2/qvbyz825247_9973sb_58jv40000gn/T/RackMultipart20170411-47907-1snmk5v.png>, @original_filename="favicon.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"attachments[]\"; filename=\"favicon.png\"\r\nContent-Type: image/png\r\n">
Completed 201 Created in 1ms (ActiveRecord: 0.0ms)
```

## Receiving email with Rails 5 and older

Inbound email to Rails 4 and 5 are very similar to the Rails 6 example above.

Rails 3 already makes use of mail instead of using TMail that was default in Rails 2.x. In Rails 3
we just have to `rails generate controller incoming_mails` to generate our controller and add a create method.

```ruby
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
```

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't
raise an exception because we have no way of knowing the token.

Alternatively Rails can handle the parsed versions of CloudMailin's
[HTTP POST Formats](/http_post_formats/) automatically. An example reading the subject and body
from address might be:

```ruby
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
```

Then log into [CloudMailin] and make sure you set your address to deliver
to `http://example.com/incoming_mails` (replace example.com with your app's URL)
and send our first message. and thats it!


## Rails (2.3.x)
First we are going to use the [mail gem](https://github.com/mikel/mail/). You could of course use
TMail but we personally think mail's much nicer.

    gem install mail

Once mail is installed lets add it to the environment.config

    config.gem 'mail'

Then create a controller `script/generate controller incoming_mails`. You are free to call the
controller anything you like. Make sure you add your controller to your routes file
(resources :incoming_mails) and then setup the create method like so.

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

Notice the call to `skip_before_filter :verify_authenticity_token` to make sure that rails doesn't
raise an exception because we have no way of knowing the token.

Then log into [CloudMailin] and make sure you set your address to deliver
to `http://example.com/incoming_mail` (replace example.com with your app's URL)
and send our first message. and thats it!

## Griddler CloudMailin and Rails

[Griddler](https://github.com/thoughtbot/griddler) is a rails engine that can be used to help
receive email messages with Rails.

There's a [CloudMailin adapter](https://github.com/thoughtbot/griddler-cloudmailin) for Griddler
that allows you to use CloudMailin to receive emails.

First install the gem:

```
gem 'griddler'
gem 'gridder-cloudmailin'
```

Then add the route to your routes:

```ruby
# config/routes.rb

mount_griddler('/incoming_mails')
```

You then need to configure the adapater:

```ruby
Griddler.configure do |config|
  config.processor_class = EmailProcessor # CommentViaEmail
  config.email_class = Griddler::Email # MyEmail
  config.processor_method = :process # :create_comment (A method on CommentViaEmail)
  config.reply_delimiter = '-- REPLY ABOVE THIS LINE --'
  config.email_service = :cloudmailin
end
```

Then log into [CloudMailin] and make sure you set your address to deliver
to `http://example.com/incoming_mail` (replace example.com with your app's URL)
and send our first message. and thats it!

For more details checkout the [gem](https://github.com/thoughtbot/griddler-cloudmailin).

## Receiving mail with Sinatra
Parsing incoming mail in Sinatra is really simple. Using the multipart format you can simply use
something like the following:

```ruby
post '/incoming_mail' do
  puts params.inspect
  puts params[:headers][:subject]
  puts params[:envelope][:to]
  'success'
end
```

For more details see the [POST formats](/http_post_formats/) section.

You can also just use the [mail gem](https://github.com/mikel/mail). Once the gem is installed then
you can require 'mail' and add a post method to deal with the message.

```ruby
require 'mail'

post '/incoming_mail' do
  mail = Mail.new(params[:message])
  # do something with mail
  'success'
end
```

Then log into [CloudMailin] and make sure you set your address to deliver
to `http://example.com/incoming_mail` (replace example.com with your app's URL)
and send our first message. and thats it!
