FROM mysql:8.0
MAINTAINER MERSYS  leandro@mersys.com.mx
RUN apt-get update && apt-get -y install cron
RUN apt-get install -y sudo 
RUN apt-get install -y vim
RUN apt-get install -y vsftpd
RUN apt-get install -y ftp
RUN apt-get install -y ufw
RUN mkdir /var/lib/mysql-files
RUN chmod 777 /var/lib/mysql-files
RUN mkdir chmod 777 tempo
RUN sed  -i 's|secure-file-priv= NULL|secure-file-priv= /var/lib/mysql-files|g' /etc/mysql/my.cnf
COPY enviaArchivosFtp.sh /tempo
RUN apt-get update
RUN apt-get upgrade
RUN chmod +x /tempo/enviaArchivosFtp.sh
COPY crontab /etc/cron.d/ftp-cron
RUN chmod 0644 /etc/cron.d/ftp-cron
RUN touch /var/log/cron.log
COPY dump.sql  /docker-entrypoint-initdb.d/dump.sql
RUN chmod  -R  775 /docker-entrypoint-initdb.d
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /
ENV MYSQL_ROOT_PASSWORD mypass
EXPOSE 1306
