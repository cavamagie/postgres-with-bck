FROM postgres:10.7

MAINTAINER cavamagie

ENV POSTGIS_MAJOR 2.5
ENV POSTGRES_USER postgres
ENV POSTGRES_PASS postgres
ENV BACKUP_DIR '/backups'
ENV DBHOST localhost
ENV PGPASSWORD **None**
ENV DBNAMES 'all'
ENV SCHEDULE '@daily'
COPY files/autopgsqlbackup.sh ./
RUN chmod -R 777 autopgsqlbackup.sh
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      postgresql-10-postgis-$POSTGIS_MAJOR \
      postgresql-10-postgis-$POSTGIS_MAJOR-scripts \
      libgeos-c1v5
      && rm -rf /var/lib/apt/lists/*

# cleanup
RUN apt-get -qy autoremove


RUN mkdir -p /docker-entrypoint-initdb.d




VOLUME /backups

HEALTHCHECK --interval=5m --timeout=5s \
  CMD pg_isready || exit 1
