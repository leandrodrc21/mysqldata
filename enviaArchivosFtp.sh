#! /bin/sh
ftp -n 192.168.1.135 <<EOF
user doker 12345678
binary 
prompt
cd /home/doker/Documentos/docker
lcd /var/lib/mysql-files
mput *.sql
quit
EOF
cd /var/lib/mysql-files
rm *.sql