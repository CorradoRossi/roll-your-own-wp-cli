# Setup MAMP for virtualhosts

Configure MAMP once and then run [create-wordpress](#) as many times as your little heart desires! I don't know of a faster way to get a local Wordpress dev environment setup.

### Get MAMP

If you haven't already, install MAMP and make sure the document root is **Applications > MAMP > htdocs**. 

<img src="img/mamp-1.png" alt="understanding" width="70%">

That should be the default but might as well be certain. You can **CMD + Q** out of MAMP for now while we get the rest set up. 

### Allow virtual hosts

Go to **Applications >  MAMP > conf > Apache > httpd.conf** 

and open that file with your text editor.

Hit **CMD + f** and search for this line:

```shell
# Virtual hosts
#Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```

Uncomment the line so it looks like this:

```shell
# Virtual hosts
Include /Applications/MAMP/conf/apache/extra/httpd-vhosts.conf
```

### Allow Symlink override

In the same file find the snippet that looks like this:

```html
<Directory />
    Options Indexes FollowSymLinks
    AllowOverride None
</Directory>

```
And change AllowOverride from **none** to **all**.

```html
<Directory />
    Options Indexes FollowSymLinks
    AllowOverride All
</Directory>
```

### Change the listening port

Once again in the same file look for these two lines (they won't be right next to one another):

```js
listen 8888
ServerName localhost:8888
```

And change them to:

```js
listen 80
ServerName localhost:80
```

Then save the file.

### Add the virtual host path

Navigate to **Applications > MAMP > conf > apache > extra > httpd-vhosts.conf** and open the file in your text editor.

At the end of the document add this snippet:

```html
<VirtualHost *:80>
  ServerName newsite.test
  DocumentRoot "/path/to/directory"
</VirtualHost>
```

Where ServerName reflects the name you'd like to use for your new site and DocumentRoot reflects the directory that you made earlier for your new Wordpress project.

Save the file.

### Allow your computer to recognize the domain

Finally, we need to make it so that the computer will recognize the new domain we've created.

Open your terminal and type:

```shell
sudo pico /etc/hosts
```

After entering your password you'll be editing a text file with Nano that looks like this.

```shell
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
fe80::1%lo0     localhost

127.0.0.1       newsite.test
```

Press down until you get to the end of the file and add the line:

```shell
127.0.0.1       newsite.test
```

Then press **ctrl + o** to finish editing, **enter** to save the changes, and **ctrl + x** to exit back to your terminal screen.

### Change MAMP ports 

Open MAMP and navigate to **preferences > ports**. Change the ports to 80, 8888, and 3306.

<img src="img/mamp-2.png" alt="understanding" width="70%">

Exit out of MAMP. The next time you restart the server all of your changes will take effect.

Once you setup your Wordpress installation you'll be able to navigate to `newsite.test` in your browser and see it! If you want a little instant gratification (or if you want to make sure you did everything right) you can go to the directory you set up and create a file with some markup and name it **index.php**. After restarting MAMP you should be able to see the file at `newsite.test`!

### Rinse and repeat

The beauty of this setup is that it's repeatable for as many sites as you'd like and with the initial setup done, really easy to add new ones. Just follow the last couple steps for each new site: Add a new virtual host at the bottom of the `vhosts.conf` file with it's own `ServerName` and `DocumentRoot`:

```html
<VirtualHost *:80>
  ServerName newsite.test
  DocumentRoot "path/to/newsite"
</VirtualHost>

<VirtualHost *:80>
  ServerName anothernewsite.test
  DocumentRoot "path/to/anothernewsite"
</VirtualHost>
```

And allow your computer to recognize it by using the terminal command and Nano editing you used earlier:

```shell
sudo pico /etc/hosts
```

Now we can get down to the business of setting up Wordpress!