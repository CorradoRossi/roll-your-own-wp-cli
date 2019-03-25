# Ultra Fast Wordpress Script

This script downloads and configures a Wordpress site in record time. A series of prompts takes care of everything from creating the directory to downloading from source to making the wp-config.php file to getting your salt and secret key.

requirements:

You need MAMP configured to allow virtualhosts and symlinks. There's a tutorial for that [right in this repo](). Create a database with phpmyadmin in MAMP and the script takes care of everything else!

Simplest way to use:

```shell
sudo mv create-wordpress.sh /usr/local/bin/create-wordpress
sudo chmod +x /usr/local/bin/create-wordpress
```

Then run `create-wordpress` and follow the prompts.







