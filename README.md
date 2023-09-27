# Locution

Simple Rails and Postgres application. Extremely simple. The goal w/this project is to document how to get up and running w/[ReadySet](https://github.com/readysettech/readyset) in a Rails environment. If you're ready to stand it up, follow [the steps](#steps-to-set-this-application-up) below! 


## Steps to set this application up

To successfully run this application, there are a few prerequisites: 

1. Ruby 3.2.2 is installed. 
2. Docker is installed.
3. This application works with [PostgreSQL](https://www.postgresql.org/). The application provides a Postgres `docker-compose.yml` file; however, you'll still need the `psql` client to seed the database, for instance. Postgres doesn't have to be installed locally; nevertheless, you'll need to configure this application to communicate with whatever instance of Postgres you have. You'll need to provide connection information in a `.env` file, which you'll create. 

If those prerequisites are available, then follow these steps: 

1. Clone this repository. 
2. You'll need access to a Postgres instance either locally or remotely in AWS, for example. Either way, just like any other application, you will need to ensure this Rails application can communicate w/your desired Postgres instance. There is an included `docker-compose.yml` file that will fire up a Postgres container. [See below for more details](#postgres-docker-setup). Make sure the database is running before the next steps.
3. Once you have a database available, you'll need to create a `.env` file in the root of the application that contains specific keys and values. [See below for specific details](#generic-setup-regardless-of-database). 
4. Make sure you are in the root directory of this project and then run `bundle install`. Note, the Postgres Ruby Gem requires some native code to successfully compile. This might mean that you'll need to install some [native libraries](https://stackoverflow.com/questions/6209797/cant-find-the-postgresql-client-library-libpq) depending on your OS. 
5. Run a database migration `bin/rails db:migrate`. 
6. Start the application via `bin/rails server`. 
7. If you didn't change the port, go to `http://localhost:3000/words/` and you should see an underwhelming blank-ish screen where you can elect to create a word. 
8. You can seed the database via the Postgres client, `psql` with a sample `.sql` file found in the `etc/` directory called `all-words-data-only-export.sql`. [See below for more details](#generic-setup-regardless-of-database).
9. Refresh `http://localhost:3000/words/` and you should see some words. 
10. You now have a simple dictionary-ish application. You can see words in alphabetical order and you can search for words using the format (i.e. an HTTP `GET`): `http://localhost:3000/words/<your word>`.
11. Out-of-the-box, this application does bundle a [ReadySet Docker compose file](#readyset). It's up to you if you want to use it or can follow our [install directions](https://docs.readyset.io/deploy/deploy-with-docker). Regardless on how you fire up ReadySet, you'll need to manually configure it. Please see [ReadySet's RoR documentation](https://docs.readyset.io/connect/connect-an-application-via-an-orm/ruby-on-rails-with-readyset) for instructions.  

## Generic setup regardless of database

Once you've configured a database -- locally via Docker or via RDS (either Postgres or Aurora Postgres), you'll need to create a `.env` file with the following keys:

```
POSTGRES_USER='some_user'
POSTGRES_PASSWORD='some_password'
POSTGRES_HOST='a_url'
POSTGRES_DB='locution'
POSTGRES_TEST_DB='locution'
READY_SET_HOST='another_url'
```

You'll see that the `database.yml` is seeking the values of these keys to configure things. You'll first need to run a migration to set up the database structure: `bin/rails db:migrate`. 

Go to `http://localhost:3000/words/` and you should see a simple blank page with a link to create a new word. If you've gotten this far, then things are working. If you'd like to seed the database with a dictionary's worth of words you can run the following command from the root of this project:

```
psql postgresql://user:password@database_url:5432/database < etc/all-words-data-only-export.sql
```

Depending on your database and the network between you and it, this might take awhile. Like hours. 

## Postgres docker setup

First time: `docker compose up -d` and then use `start` and to stop, use `docker compose stop` and to start over (remove things) use `down`. 

## Connecting to Postgres

Simply run `psql postgresql://postgres:locution@127.0.0.1:5432/locution` and if you want to connect directly to ReadySet, replace `5432` w/`5433`

ReadySet running on port 5433. Allow full materialization set to false by default. If you want to test w/it on, `--allow-full-materialization`

## Some helpful details

A few things to note, nevertheless:

 1. There's a Ruby script in the `etc` directory dubbed `seed_database.rb` that will pump quite a lot of words and corresponding definitions into Postgres. This is an alternative to using the seed file found in the [section above on setting up Postgres](#generic-setup-regardless-of-database). 
 
Helpful links

* [Rails command line](https://guides.rubyonrails.org/command_line.html)
* [Setting up Postgres w/Docker](https://geshan.com.np/blog/2021/12/docker-postgres/)
* [Postgres docker image](https://hub.docker.com/_/postgres)
* Rails uses a Ruby gem to connect to Postgres and this gem requires native code. To fix PG lib errors on OSX, see [SO](https://stackoverflow.com/questions/6209797/cant-find-the-postgresql-client-library-libpq)
* Pagination done via [kaminari](https://betterprogramming.pub/pagination-in-rails-b3a9ba25b3c3)
* Having trouble installing Ruby 3.2.x on OSX? Using Homebrew too? Ensure you have [OpenSSL installed and try running](https://github.com/rvm/rvm/issues/5261) `rvm install 3.2.x --with-openssl-dir=/opt/homebrew/opt/openssl@1.1`

## ReadySet

If you run ReadySet w/the provided `readyset-compose.yml` file, you'll have access to a Grafana dashboard. This'll be helpful later on and you can go to `http://localhost:4000/` to see a few things; namely, what queries are cached and which are proxied (i.e. are passed directly to Postgres). With full materialization disabled, only a few queries are cache-able. They are:

```
SELECT "definitions".* FROM "definitions" WHERE ("definitions"."word_id" = $1)
SELECT "words".* FROM "words" WHERE ("words"."id" = $1)
SELECT "words".* FROM "words" WHERE ("words"."id" = $1) ORDER BY "words"."id" ASC
```

This is a simple application and it turns out that almost all functionality of using dictionary refers to these queries. Because full materialization is off by default, you'll see a few queries that load _everything_ such as `SELECT "words".* FROM "words" ORDER BY "words"."id" ASC` or even `SELECT count(*) FROM "words"` that are marked as `unsupported`. 

## Prometheus metrics

There's a `metrics/` endpoint associated with this application that emits Prometheus style metrics. You can find a corresponding `prometheus.yml` file in the `etc/` directory that configures Prometheus. To run Prometheus, type:

```
 docker run -p 9090:9090 -v ./etc/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```

Note, the configuration assumes that Rails is running in a non-containerized environment; hence, you'll note that Prometheus is configured to hit `host.docker.internal:3000/metrics`. 
