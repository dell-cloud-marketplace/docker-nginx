FROM ubuntu:trusty
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Install Nginx.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx=1.4.6-1ubuntu3.1
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
#RUN chown -R www-data:www-data /var/lib/nginx

# Make a copy of sites-enabled
RUN mkdir /nginx
RUN cp -r /etc/nginx/sites-enabled/ /nginx 

# Add scripts and make them executable.
ADD run.sh /run.sh
RUN chmod +x /*.sh

# Define Nginx mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/var/log/nginx"]

# Expose ports
EXPOSE 80
EXPOSE 443

CMD ["/run.sh"]
