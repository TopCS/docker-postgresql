# PostgreSQL

FROM zumbrunnen/base
MAINTAINER David Zumbrunnen <zumbrunnen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DB_PASSWORD docker

RUN apt-get -qq update
RUN apt-get -yqq upgrade
RUN apt-get -yqq install wget ca-certificates
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get -qq update
RUN apt-get -yqq install postgresql-9.3

ADD postgresql.conf /etc/postgresql/9.3/main/postgresql.conf
ADD pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD ./startup.sh /opt/startup.sh

VOLUME ["/var/lib/postgresql"]
EXPOSE 5432

CMD ["/bin/bash", "/opt/startup.sh"]
