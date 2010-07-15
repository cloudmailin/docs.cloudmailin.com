Receiving the mail at the target
=

#The HTTP POST format and multipart/form-data
#-

When an email arrives at the CloudMailin server, an HTTP **POST** will be sent as a _multipart/form-data_ request with the following parameters:

* _message_ - The message itself. This will be the entire message and will need to be manually parsed by your code. Take a look at the [parsing email](parsing_email) documentation to see how you can do this if you are not familiar with email messages.

* _to_ - The recipient as specified by the server. This will be the CloudMailin email address. This could be different to the _TO_ address specified in the message itself. If you are forwarding email from your domain you will want to extract the recipient from the email.

* _from_ - The sender as specified by the server. This can differ from the sender specified within the message.

* _subject_ - The subject of the message extracted from the message itself.

**Note**: The message is not sent as a file. Instead it is as if the user pasted the message contents into a textfield.

For more details relating to parsing the message click [here](parsing_email).
