# This code was in reference to the following official images.
# https://github.com/mysql/mysql-docker/blob/mysql-server/5.6/Dockerfile
# https://github.com/docker-library/mysql/blob/master/5.6/Dockerfile

FROM centos:7
LABEL maintainer "Bezeklik"

RUN yum --assumeyes install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum --assumeyes install yum-utils && \
    yum-config-manager --disable mysql57-community && \
    yum-config-manager --enable mysql56-community && \
    yum --assumeyes install mysql-community-server && \
    echo -e '\ncharacter-set-server=utf8mb4' >> /etc/my.cnf && \
    echo -e 'collation-server=utf8mb4_bin' >> /etc/my.cnf && \
    echo -e 'innodb_large_prefix=ON' >> /etc/my.cnf && \
    echo -e 'innodb_file_format=Barracuda' >> /etc/my.cnf && \
    echo -e 'innodb_file_format_max=Barracuda' >> /etc/my.cnf && \
    echo -e '\nslow_query_log=ON' >> /etc/my.cnf && \
    echo -e 'slow_query_log_file=/var/log/mysqld-slow.log' >> /etc/my.cnf && \
    echo -e 'long_query_time=1' >> /etc/my.cnf && \
    echo -e 'log_queries_not_using_indexes=ON' >> /etc/my.cnf && \
    touch /var/log/mysqld-slow.log && \
    chown mysql:mysql /var/log/mysqld-slow.log && \
    chcon -t mysqld_log_t /var/log/mysqld-slow.log && \
    echo -e '[mysql]' >> ~/.my.cnf && \
    echo -e 'default-character-set=utf8mb4' >> ~/.my.cnf && \
    echo -e 'pager=less -SFXin' >> ~/.my.cnf && \
    mysql_install_db --user=mysql --rpm --keep-my-cnf && \
    mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY healthcheck.sh /usr/local/bin/
RUN ln -s /usr/local/bin/healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=10s \
            --timeout=3s \
            --start-period=5s \
            --retries=5 \
            CMD /healthcheck.sh

EXPOSE 3306

CMD ["mysqld"]
