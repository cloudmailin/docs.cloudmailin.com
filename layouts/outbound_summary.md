## Summary

We should now have received a message in our inbox. Using CloudMailin we can also track the status
of each of our emails and see the delivery details. Any tags you've added as a `x-cloudmta-tags`
header can be used to filter the email messages and search.

If you need any SMTP credentials you can create an account for free and get your SMTP credentials
on the [outbound account] page.

> Make sure you changed the from address to match your verified domain and set a recipient

![Outbound Dashboard Showing Message](/assets/images/outbound_summary.png)

The SMTP transaction will reply with the message-id of the message to use for bounce tracking
if required.

    250 Thanks! Queued as: f78b876d-dd97-4e10-9a61-067f98044cc7

Of course if there are any questions feel free to [contact us] and we'll do our best to help you
get setup sending email.
