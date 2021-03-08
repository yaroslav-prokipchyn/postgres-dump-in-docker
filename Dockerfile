FROM postgres:latest

ARG DUMP_FILE
ENV DUMP_FILE ${DUMP_FILE}

ENV PGDATA /data/

COPY ${DUMP_FILE} /tmp/dump.dump

EXPOSE 5432
