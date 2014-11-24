FROM ubuntu:trusty
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Install Nginx.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx=1.4.6-1ubuntu3.1
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# Add supervisor cnfiguration and script
ADD start-nginx.sh /start-nginx.sh
ADD supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf

# Add sites-enabled
ADD sites-enabled/ /sites-enabled
RUN rm -rf /etc/nginx/sites-enabled/*

#Add Hello world app
ADD /hello-world-nginx /hello-world-nginx/

# Generate Self-signed certificate to enable HTTPS
RUN mkdir /etc/nginx/certs
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt \
       -subj '/O=Dell/OU=MarketPlace/CN=www.dell.com'

# Add startup script and make it executable.
ADD run.sh /run.sh
RUN chmod +x /*.sh

# Define Nginx mountable directories.
VOLUME ["/data/www", "/etc/nginx/sites-enabled", "/var/log/nginx"]

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["/run.sh"]
