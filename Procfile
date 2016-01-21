worker: bundle exec sidekiq -e production -C config/sidekiq.yml -q default
heroku ps:scale worker=1
