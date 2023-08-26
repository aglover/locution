# Locution

Rails an Postgres

## Postgres docker setup

https://geshan.com.np/blog/2021/12/docker-postgres/
https://hub.docker.com/_/postgres

First time: `docker compose up -d` and then use `start` and to stop, use `docker compose stop` and to start over (remove things) use `down`. 

To fix PG lib errors: https://stackoverflow.com/questions/6209797/cant-find-the-postgresql-client-library-libpq

Connect to Postgres

` psql postgresql://postgres:locution@127.0.0.1:5432/locution`