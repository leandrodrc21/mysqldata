FROM mysql:5.7
MAINTAINER MERSYS  mersys2@maersydss.com
COPY dump.sql  /docker-entrypoint-initdb.d/dump.sql
RUN chmod  -R  775 /docker-entrypoint-initdb.d
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /
ENV MYSQL_ROOT_PASSWORD mypass
EXPOSE 1306
