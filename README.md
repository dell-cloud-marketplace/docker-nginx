docker-nginx
=====================

This image installs [Nginx](http://nginx.org/), a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server.

## Components

The stack comprises the following components:

Name            | Version                   | Description
----------------|---------------------------|------------------------------
Nginx           | 1.4.6                     | HTTP server & Reverse proxy
Ubuntu          | Trusty                    | Operating system

## Usage

### Start the Container

#### A. Basic Usage

Start your container with:

* Ports 80, 443 (Nginx) exposed
* A named container (**nginx**)

As follows: 

```no-highlight
sudo docker run -d -p 80:80 -p 443:443 --name nginx dell/nginx
```

<a name="advanced-usage"></a>
#### B. Advanced Usage

Start your container with:

* Ports 80, 443 (Nginx) exposed
* A named container (**nginx**)
* Three data volumes (which will survive a restart or recreation of the container). The Nginx website configuration files are available in **/etc/nginx/sites-enabled** on the host. The Nginx application files are available in **/data/www** on the host. The Nginx log files are available in **/var/log/nginx** on the host.

As follows: 

```no-highlight
sudo docker run -d -p 80:80 \
-p 443:443 \
-v /etc/nginx/sites-enabled:/etc/nginx/sites-enabled \
-v /var/log/nginx:/var/log/nginx  \
-v /data/www:/data/www \
--name nginx \
dell/nginx
```

## Test your deployment

By default, the container deploys a Hello world page as welcome page.
To access the welcome page, open:
```no-highlight
http://localhost
```

Or:
```no-highlight
https://localhost
```

**We strongly recommend that you connect via HTTPS**, for this step, and all subsequent administrative tasks, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

Or with cURL:
```no-highlight
curl http://localhost
```

### Edit Nginx configuration

If you used the volume mapping optionned as listed in the [Advanced Usage](#advanced-usage), you can directly change the Nginx configuration under **/etc/nginx/sites-enabled/** on the host.

### Loading your custom application

In order to replace the "Hello World" application that comes bundled with this docker image, replace the files located under **/data/www** with your website content. If you used the volume mapping option mentioned in the advanced example, you can directly copy the content of your custom application to **/data/www** on the host.

#### Enable PHP content 

* Login to the container using **nsenter**
* Install **php5-fpm**

```no-highlight
apt-get install php5-fpm
```
* Edit the configuration file **/etc/nginx/sites-enabled/default** 
* Add **index.php** to the index line:

```no-highlight
index index.php index.html index.htm;
```
* Uncomment the following lines in the PHP section:

```no-highlight
location ~ \.php$ {
    fastcgi_split_path_info ^(.+\.php)(/.+)$;
    # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini

#   # With php5-cgi alone:
#   fastcgi_pass 127.0.0.1:9000;
    # With php5-fpm:
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_index index.php;
    include fastcgi_params;
}
```
* Save the configuration file
* Create a new file info.php or copy your website content under **/data/www**

```no-highlight
echo '<?php phpinfo(); ?>' > /data/www/info.php
```
* Restart php5-fm

```no-highlight
service php5-fpm restart
```

* Reload Nginx configuration

```no-highlight
nginx -s reload
```
* Access your PHP page

```no-highlight
http://localhost/info.php (or any file of your website)
```

### Nginx as Reverse Proxy

One of the frequent uses of Nginx is setting it up as a proxy server, which means a server that receives requests, passes them to the proxied servers, retrieves responses from them, and sends them to the clients.


### Nginx configuration
For other information on how to use Nginx, refer to the following documentation:
[Nginx starting guide](http://nginx.org/en/docs/beginners_guide.html)

## Reference

### Image Details

Inspired by [tutum/nginx](https://github.com/tutumcloud/tutum-docker-nginx)

Pre-built Image | [https://registry.hub.docker.com/u/dell/nginx](https://registry.hub.docker.com/u/dell/nginx) 
