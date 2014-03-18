# VERSION 0.1
# DOCKER-VERSION  0.9.0
# AUTHOR:         TopCS
# DESCRIPTION:    Image with posgres 9.3 and extensions
# TO_BUILD:       docker build --rm -t postgres-9.3 .
# TO_RUN:         docker run -d -p 5432:5432 -v /data/postgres:/var/lib/postgresql postgres-9.3

# PostgreSQL
FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive
ENV DB_USER postgres
ENV DB_PASSWORD postgres

# apt-cache on 192.168.0.45
RUN echo 'Acquire::http { Proxy "http://192.168.0.45:3142"; };' >> /etc/apt/apt.conf.d/02proxy

RUN apt-get update
RUN apt-get install -y wget git build-essential make
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y install postgresql-9.3 postgresql-9.3-postgis-2.1 postgresql-9.3-plv8 libpq-dev postgresql-server-dev-9.3

RUN locale-gen en_US en_US.UTF-8 it_IT it_IT.UTF-8

ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD ./startup.sh /opt/startup.sh

#Install amqp plugin
RUN git clone https://github.com/omniti-labs/pg_amqp.git /tmp/pg_amqp
RUN make -C /tmp/pg_amqp
RUN make -C /tmp/pg_amqp install

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432

CMD ["/bin/bash", "/opt/startup.sh"]
