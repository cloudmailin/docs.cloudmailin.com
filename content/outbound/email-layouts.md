---
title: Email Layouts (Templates)
image: out
---

# CloudMailin Email Layouts (Templates)

Email layouts can be used to wrap your email content in a consistent design.
This not only provides branding and visual impact but also helps improve the
deliverability of your emails.

> This feature is currently in Beta. You'll first need to be approved to use
> this feature. Please [contact us] to opt-in.

* [Available layouts](#the-available-layouts)
* [Customizing the layout](#customizing-the-layout)
* [Naming and using your Layouts](#naming-and-using-your-layouts)
* [Special Names](#special-names)

## The available layouts

CloudMailin provides two layouts at present:

* Hybrid - A layout with a header and footer that can be adapted to your needs.
* Plain - A simple layout with limited styling with simplicity in mind.

### Hybrid

#### Desktop

![Hybrid Layout](/content/assets/images/email-layouts/hybrid.png)

#### Mobile

![Hybrid Layout Mobile Size](/content/assets/images/email-layouts/hybrid-mobile.png)

### Plain Layout

#### Desktop

![Plain Layout](/content/assets/images/email-layouts/plain.png)

#### Mobile

![Plain Layout Mobile Size](/content/assets/images/email-layouts/plain-mobile.png)

## Customizing the layout

The layouts can be customized in two ways. Firstly you can pick from the
[available layouts](#the-available-layouts) and customize some basic variables
in the layout. Once you've done this you may edit the HTML for additional
customization.

By default each template has a set of variables in JSON format:

![Variables](/content/assets/images/email-layouts/full-email-layout-editor.png)

You can customize the following colors (in HEX format):

* `background` - The background color of the email.
* `color` - The text color of the email.
* `header_background` - The background color of the header.
* `header_color` - The text color of the header.
* `footer_color` - The text color of the footer.
* `button_background` - The background color of the buttons within the email

You can also customize the following text:

* `header_text` - The text to display in the header.
* `footer_text` - The text to display in the footer, this is normally used for
  contact information / address and a link to your website.

Once you save your template these variables will be used to generate the emails
and you may proceed to edit the HTML if required.

For more details regarding the configuration of the layout please see the
[variables](#variables) section.

## Naming and using your Layouts

When you create a new email layout you'll be asked to provide a name. Once you
have named the layout a parameterized version of this name will be visible.

### Using a CloudMailin Layout

Once you've created the layout you will be shown the parameterized name on the
layout page.

![Layout Name](/content/assets/images/email-layouts/edit-view.png)

Let's assume the layout was called `My Layout` (`my_layout` is the parameterized
version).

In order to use this layout we need to add a header to our email
`x-cloudmta-layout` with our parameterized value.

```email
... other headers
to: user@example.com
subject: hello
x-cloudmta-layout: my_layout

... email content
```

## Special Names

When you create a new email layout you can use special names to use the template
for every email sent in this account:

* `all_default` - This layout will be used for all emails sent from this account.
* `[ACCOUNT_ID]_default` - This layout will be used for all inbound emails. In
  this case ACCOUNT ID is the username you use to send emails and authenticate
  your SMTP / API transaction. If your account id was 12345 then the layout
  would be `12345_default`.

## Variables

> This section is liable to change in the beta. We can't ensure that the
> template structure used will continue to remain the same.

The basis of our customization is a simple variable replacement language.
Variables are inserted into the HTML using the following format:

```html
{{ variable_name }}
```

This is very similar to handlebars or mustache templates. However, we only
support simple variable replacement at present. You cannot use nested variables
or complex structures and the only additional thing available is to option to
use a default value.

```html
{{ variable_name | default_value }}
```

Our templates mostly have a default value in order to ensure that the email
still looks good even if you don't customize the variables.

> As always, if you have any questions or need help with this feature please
> [contact us] and we'll be happy to help.
