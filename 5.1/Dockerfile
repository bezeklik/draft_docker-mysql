FROM centos:6
LABEL maintainer "Bezeklik"

RUN yum --assumeyes install mysql-server && \
    sed -i '/\[mysqld\]/a character-set-server=utf8' /etc/my.cnf && \
    sed -i '/\[mysqld\]/a collation-server=utf8_bin' /etc/my.cnf && \
    sed -i '/\[mysqld\]/a slow_query_log=ON' /etc/my.cnf && \
#    sed -i '/\[mysqld\]/a slow_query_log_file=/var/run/mysqld/mysqld-slow.log' /etc/my.cnf && \
    sed -i '/\[mysqld\]/a long_query_time=1' /etc/my.cnf && \
    sed -i '/\[mysqld\]/a log_queries_not_using_indexes=ON' /etc/my.cnf && \
    ln -s /var/run/mysqld/mysqld-slow.log /var/log/mysqld-slow.log && \
    echo -e '[mysql]' >> ~/.my.cnf && \
    echo -e 'default-character-set=utf8' >> ~/.my.cnf && \
    echo -e 'pager=less -SFXin' >> ~/.my.cnf && \
    # http://ftp.nchu.edu.tw/MySQL/doc/refman/5.1/en/mysql-install-db.html
    # http://ftp.nchu.edu.tw/MySQL/doc/refman/5.1/en/mysql-install-db-problems
    mysql_install_db --user=mysql --rpm && \
    # http://ftp.nchu.edu.tw/MySQL/doc/refman/5.1/en/mysql-tzinfo-to-sql.html
    # https://bugs.mysql.com/bug.php?id=20545
    mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | mysql mysql && \
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

# http://ftp.nchu.edu.tw/MySQL/doc/refman/5.1/en/mysqld-safe.html
CMD ["mysqld_safe"]
