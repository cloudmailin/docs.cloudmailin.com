---
title: Send email with Python & Django
description: In this guide we'll cover sending email in Python and Django over SMTP with CloudMailin.
---

# Sending Email with Python and Django

* [Sending Email with Django](#sending-mail-with-django)
* [Sending Email with Plain Python](#sending-mail-with-python)

> To obtain your SMTP credentials you can create a free [outbound account] with CloudMailin.

## Sending mail with Django

Django includes the `django.core.mail` module to make sending email simple ([django docs]).

```python
from django.core.mail import send_mail

send_mail(
    'Subject here',
    'Here is the message.',
    'from@example.com',
    ['to@example.net'],
    fail_silently=False,
)
```

Mail is sent using the following settings:

```python
# settings.py
EMAIL_HOST = 'host from account page'
EMAIL_HOST_USER = 'username from account page'
EMAIL_HOST_PASSWORD= 'password from account page'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
```

## Sending mail with Plain Python

The `django.core.mail` module is really just a useful wrapper around the [smtplib] module.
We can use the core `smtplib` to send email using STARTTLS and login authentication like the
following:

```python
import smtplib, ssl

hostname = "host from account page"
username = "username from account page"
password = "password from account page"

message = """\
Subject: Test from Python
To: to@example.net
From: from@example.com

This message is sent from Python."""

server = smtplib.SMTP(hostname, 587)
server.ehlo() # Can be omitted
server.starttls(context=ssl.create_default_context()) # Secure the connection
server.login(username, password)
server.sendmail("from@example.com", "to@example.net", message)
server.quit
```

It's imporant to note that CloudMailin will only allow auth after the starttls command has been
passed.

<%= render 'outbound_summary' %>

[django docs]: https://docs.djangoproject.com/en/3.1/topics/email/
[smtplib]: https://docs.python.org/3/library/smtplib.html#module-smtplib
