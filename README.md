# Roll Your Own

### A create-wordpress bash script

This is the fastest way I know of to get a Wordpress project bootstrapped on a local machine. Just follow the prompts and be amazed as everything is taken care of. No need to `mkdir`'s or copy paste salts or fiddle with `wp-config.php`'s--or even download Wordpress in the first place. Just start MAMP, type `create-wordpress` in the terminal, and in two minutes you can navigate to `whateveryournewsiteiscalled.test`. Happy building! 

**Caveats**

Before anyone says it--yes, I know Wordpress has a nice cli, and yes I also have been slowly moving away from MAMP and toward a Dockerized Vagrant/Virtualbox workflow for local/staging/production parity. Nonetheless, this really is unbeatable for speed and ease of use. And it was a pet project. I'm really enjoying learning bash so what they hey!

**requirements:**

You need MAMP configured to allow virtualhosts and symlinks. 
There's a 5 minute tutorial for that **[right here in this repo](https://github.com/CorradoRossi/roll-your-own-wp-cli/blob/master/setup-mamp-for-vhosts.md)**. 

**Simplest way to use:**

Copy the script to /usr/local/bin and set the permissions.

```shell
sudo mv create-wordpress.sh /usr/local/bin/create-wordpress
sudo chmod +x /usr/local/bin/create-wordpress
```

Then run `create-wordpress` and follow the prompts.







