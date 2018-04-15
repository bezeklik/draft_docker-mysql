# This code was in reference to the following official images.
# https://github.com/mysql/mysql-docker/blob/mysql-server/5.7/Dockerfile
# https://github.com/mysql/mysql-docker/blob/mysql-server/genOracleLinux.sh
# https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile
# https://github.com/docker-library/healthcheck/blob/master/mysql/Dockerfile

FROM centos:7
LABEL maintainer "Bezeklik"

RUN yum --assumeyes install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum --assumeyes install mysql-community-server && \
    echo -e '\ncharacter-set-server=utf8mb4' >> /etc/my.cnf && \
    echo -e 'collation-server=utf8mb4_bin' >> /etc/my.cnf && \
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
    mysqld --initialize-insecure --user=mysql && \
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

# 33060 is the default port for the mysqlx plugin, new to 5.7
EXPOSE 3306 33060

CMD ["mysqld"]
