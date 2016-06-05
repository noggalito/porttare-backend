# porttare-backend

[![CircleCI](https://circleci.com/gh/noggalito/porttare-backend.svg?style=svg)](https://circleci.com/gh/noggalito/porttare-backend)

## setting up

### requirements

- postgresql 9+
- ruby 2.3.0
- bundler

### running app

- bundle app

  ```
$ bundle
  ```

- create PostgreSQL DB & migrate

  ```
$ bundle exec rake db:create db:migrate
  ```

- launch rails server

  ```
$ bundle exec rails server
  ```
