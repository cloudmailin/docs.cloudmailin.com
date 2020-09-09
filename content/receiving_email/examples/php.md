---
title: Receiving Email with PHP
skip_erb: true
---

# Receiving Email with PHP

<div class="warning">This example may be outdated. You can now find examples for newer POST formats within the <a href="/http_post_formats/">HTTP POST Formats documentation</a>.</div>

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

In this example if the recipient doesn't match the known user we are bouncing the message using a 403 error. The example is based upon the original format's parameters but could easily be extended to work with the new features.

Then log into [CloudMailin] and make sure you set your address to deliver
to `http://example.com/incoming_mail.php` (replace example.com with your app's URL)
and send our first message. and thats it!
