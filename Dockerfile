FROM centos:7

MAINTAINER AttractGroup

RUN yum update -y && yum clean all
RUN yum install -y yum-utils
RUN yum-config-manager --enable cr
RUN yum install -y epel-release \
                    python-pip \
                    python-setuptools \
                    nginx \
                    python-devel \
                    supervisor \
                    rabbitmq-server \
                    mysql \
                    postgresql-devel \
                    openssl-devel \
                    libffi-devel \
                    libxml2-devel \
                    libxslt-devel \
                    gcc \
                    python-devel \
                    mysql-devel \
                    postgresql-libs \
                    unixODBC \
                    libjpeg-devel \
                    git \
                    cronie

RUN pip install uwsgi

# Set work directory
ENV DIRPATH /home/docker/code/

ADD ./req.txt /home/docker/code/req.txt

# Set local IP
RUN yum install -y iproute

# setup all the configfiles
RUN mkdir /etc/nginx/sites-enabled/
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default
RUN ln -s /home/docker/code/docker/conf/nginx.conf /etc/nginx/
RUN ln -s /home/docker/code/docker/conf/nginx-app.conf /etc/nginx/sites-enabled/
RUN ln -s /home/docker/code/docker/conf/supervisor-app.conf /etc/supervisord.d/supervisor-app.ini

## install sphinx
RUN yum install -y wget
RUN yum install -y initscripts
RUN wget http://sphinxsearch.com/files/sphinx-2.2.10-1.rhel7.x86_64.rpm
RUN rpm -Uhv sphinx-2.2.10-1.rhel7.x86_64.rpm
RUN mkdir -p /opt/log/sphinx
RUN chmod 777 /opt/log/sphinx
RUN mkdir -p /var/lib/sphinx/data
RUN chmod 777 /var/lib/sphinx/data

RUN mkdir /var/log/uwsgi/

# Celery config
ENV C_FORCE_ROOT 1
RUN mkdir -p /var/log/celery
RUN chmod 777 /var/log/celery
RUN mkdir -p /var/run/celery
RUN chmod 777 /var/run/celery

# Install phantomjs
RUN yum install -y bzip2
#RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2

# Install unrar
ADD ./unrar-5.0.3-1.el7.rf.x86_64.rpm /
RUN rpm -Uvh unrar-5.0.3-1.el7.rf.x86_64.rpm

# Install 7zip
RUN yum install -y p7zip p7zip-plugins

# adding an archive will automatically extract it
ADD ./phantomjs-2.1.1-linux-x86_64.tar.bz2 /
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
RUN rm -fr phantomjs-2.1.1-linux-x86_64
#RUN rm -fr phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mkdir -p /home/docker/code/media/pdf
RUN chmod 777 /home/docker/code/media/pdf

RUN pip install -r /home/docker/code/req.txt
RUN localedef -i en_US -f UTF-8 en_US.UTF-8