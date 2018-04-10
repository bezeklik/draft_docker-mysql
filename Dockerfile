# This code was in reference to the following official images.
# https://github.com/mysql/mysql-docker/blob/mysql-server/5.7/Dockerfile
# https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile
# https://github.com/docker-library/healthcheck/blob/master/mysql/Dockerfile

FROM centos:7
LABEL maintainer "Bezeklik"

RUN yum --assumeyes install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum --assumeyes install mysql-community-server && \
    mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY healthcheck.sh /usr/local/bin/
RUN ln -s usr/local/bin/healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=10s &&
            --timeout=3s &&
            --start-period=5s &&
            --retries=5 &&
            CMD /healthcheck.sh

EXPOSE 3306

CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_bin"]
