# Locution

Simple Rails and Postgres application. Extremely simple. The goal w/this project is to document how to get up and running w/[ReadySet](https://github.com/readysettech/readyset) in a Rails environment.

A few things to note, nevertheless:

 1. Use the provided `docker-compose.yml` file to fire up Postgres. This can be done w/`docker compose up -d`. If you want to stop Postgres, use `docker compose stop`. 
 2. The way things are configured assumes ReadySet is running on port 5433 -- see the `database.yml` file. If you do NOT have ReadySet running, simply change this port to 5432 (Postgres direct).  See the `etc`
 directory for a `readyset-compose.yml` file.  
 3. You'll need to run a database migration to set up the database. `bin/rails db:migrate`
 4. There's a Ruby script in the `etc` directory dubbed `seed_database.rb` that will pump quite a lot of words and corresponding definitions into Postgres. 
 

Helpful links

* [Rails command line](https://guides.rubyonrails.org/command_line.html)
* [Setting up Postgres w/Docker](https://geshan.com.np/blog/2021/12/docker-postgres/)
* [Postgres docker image](https://hub.docker.com/_/postgres)
* Rails uses a Ruby gem to connect to Postgres and this gem requires native code. To fix PG lib errors on OSX, see [SO](https://stackoverflow.com/questions/6209797/cant-find-the-postgresql-client-library-libpq)
* Pagination done via [kaminari](https://betterprogramming.pub/pagination-in-rails-b3a9ba25b3c3)

## Postgres docker setup

First time: `docker compose up -d` and then use `start` and to stop, use `docker compose stop` and to start over (remove things) use `down`. 

## Connecting to Postgres

Simply run `psql postgresql://postgres:locution@127.0.0.1:5432/locution` and if you want to connect directly to ReadySet, replace `5432` w/`5433`

ReadySet running on port 5433. Allow full materialization set to false by default. If you want to test w/it on, `--allow-full-materialization`

## ReadySet

If you run ReadySet w/the provided `readyset-compose.yml` file, you'll have access to a Grafana dashboard. This'll be helpful later on and you can go to `http://localhost:4000/` to see a few things; namely, what queries are cached and which are proxied (i.e. are passed directly to Postgres). With full materialization disabled, only a few queries are cache-able. They are:

```
SELECT "definitions".* FROM "definitions" WHERE ("definitions"."word_id" = $1)
SELECT "words".* FROM "words" WHERE ("words"."id" = $1)
SELECT "words".* FROM "words" WHERE ("words"."id" = $1) ORDER BY "words"."id" ASC
```

This is a simple application and it turns out that almost all functionality of using dictionary refers to these queries. Because full materialization is off by default, you'll see a few queries that load _everything_ such as `SELECT "words".* FROM "words" ORDER BY "words"."id" ASC` or even `SELECT count(*) FROM "words"` that are marked as `unsupported`. 