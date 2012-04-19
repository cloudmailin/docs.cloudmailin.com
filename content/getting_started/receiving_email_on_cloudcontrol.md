---
title: Receiving Email on cloudControl
name: Getting Started on cloudControl
---

# Getting Started On cloudControl

CloudMailin can be added to your cloudControl deployment with:

    $ cctrlapp APP_NAME/DEP_NAME addon.add cloudmailin.OPTION

## Access Credentials

Your CloudMailin address details are provided within a `CRED_FILE` on cloudControl. You can read out the location of the file from the env variable `CRED_FILE`. The benefit of using the environment variable is that you don't need to hardcode the add-on credentials. That way CloudMailin can automatically update any of your details without you having to deploy new code.

There's an example demonstrating how to read a `CRED_FILE` on github [here](https://github.com/cloudControl/add_on_cred_file/blob/master/_config.php).

The JSON file has the following structure:

    {
       "CLOUDMAILIN":{
          "CLOUDMAILIN_SECRET":"12341337asdf1335asdfqwert",
          "CLOUDMAILIN_USERNAME":"depxasdfqwert@cloudcontrolled.com",
          "CLOUDMAILIN_PASSWORD":"1337asdf1234",
          "CLOUDMAILIN_FORWARD_ADDRESS":"12345asdf73@cloudmailin.net"
       }
    }

## Upgrading

Upgrading to a different CloudMailin plan can be done like so:

    $ cctrlapp APP_NAME/DEP_NAME addon.upgrade cloudmailin.OPTION_OLD cloudmailin.OPTION_NEW 

You can also remove the CloudMailin add-on by typing:

    $ cctrlapp APP_NAME/DEP_NAME addon.remove cloudmailin.OPTION

## Example

cloudControl have put together an example PHP app that makes use of cloudControl and CloudMailin together. The example is on github [here](https://github.com/cloudControl/CloudMailInAddonUsage)