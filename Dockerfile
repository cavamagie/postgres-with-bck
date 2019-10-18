FROM postgres:10.7

MAINTAINER LLC Itmicus <order@itmicus.ru>

ENV POSTGIS_MAJOR 2.5
ENV POSTGRES_USER postgres
ENV POSTGRES_PASS postgres
ENV BACKUP_DIR '/backups'
ENV DBHOST localhost
ENV PGPASSWORD **None**
ENV DBNAMES all
ENV SCHEDULE '@daily'
COPY files/autopgsqlbackup.sh files/go-cron ./
RUN chmod -R 777 autopgsqlbackup.sh go-cron
RUN apt-get update \
      && apt-get install -y --no-install-recommends \
      postgresql-10-postgis-$POSTGIS_MAJOR \
      postgresql-10-postgis-scripts \
      && rm -rf /var/lib/apt/lists/*

# cleanup
RUN apt-get -qy autoremove


RUN mkdir -p /docker-entrypoint-initdb.d




VOLUME /backups

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["exec ./go-cron -s \"$SCHEDULE\" -p 8686 -- /autopgsqlbackup.sh"]

HEALTHCHECK --interval=5m --timeout=5s \
  CMD curl -f http://localhost:8686/ || exit 1