# Roll Your Own

This is the fastest way I know of to get a Wordpress project bootstrapped on a local machine. Just follow the prompts and be amazed as everything is taken care of. No need to `mkdir`'s or copy paste salts or fiddle with `wp-config.php`'s or even go and download Wordpress in the first place. Just start MAMP, type `create-wordpress` in the terminal, and in two minutes you can navigate to `yournewsite.test`. Happy building! 

requirements:

You need MAMP configured to allow virtualhosts and symlinks. 
There's a 5 minute tutorial for that [right here in this repo](). 

Simplest way to use:

Copy the script to /usr/local/bin and set the permissions.

```shell
sudo mv create-wordpress.sh /usr/local/bin/create-wordpress
sudo chmod +x /usr/local/bin/create-wordpress
```

Then run `create-wordpress` and follow the prompts.







