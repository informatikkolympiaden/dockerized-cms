FROM ubuntu:18.04

# Install deps
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y build-essential openjdk-8-jdk-headless fp-compiler \
    postgresql postgresql-client python3.6 cppreference-doc-en-html \
    cgroup-lite libcap-dev zip wget python3-pip python3.6-dev libpq-dev \
    libcups2-dev libyaml-dev libffi-dev python3-pip python

# Install cms
RUN cd /root/ && \
    wget https://github.com/cms-dev/cms/releases/download/v1.4.rc1/v1.4.rc1.tar.gz && \
    tar -xvf v1.4.rc1.tar.gz && \
    cd cms && \
    python3 prerequisites.py --as-root -y install && \
    pip3 install -r requirements.txt && \
    python3 setup.py install

# Setup postgres
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER cmsuser WITH SUPERUSER PASSWORD 'your_password_here';" && \
    createdb --username=postgres --owner=cmsuser cmsdb && \
    psql --username=postgres --dbname=cmsdb --command='ALTER SCHEMA public OWNER TO cmsuser' && \
    psql --username=postgres --dbname=cmsdb --command='GRANT SELECT ON pg_largeobject TO cmsuser'
USER root

# Configuring cms
ADD cms.conf /usr/local/etc/cms.conf

# Fix locale bug
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
RUN apt-get install -y locales && \
    locale-gen en_US.UTF-8

RUN /etc/init.d/postgresql start && \
    cmsInitDB

ADD entrypoint.sh /root/

VOLUME  ["/var/log/postgresql", "/var/lib/postgresql"]

# Contest web service
EXPOSE 8888

# Admin web service
EXPOSE 8889

ENTRYPOINT /root/entrypoint.sh
