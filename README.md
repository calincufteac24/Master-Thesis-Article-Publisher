# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
  ``
  yarn
  ``

* Database creation
  ``
  rake db:create
  ``
* Database initialization
  ``
  rake db:create
  ``
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Run rails server
    `foreman start`


* Clear Sidekiq jobs
  ``
  require 'sidekiq/api'

  # Clear retry set

  Sidekiq::RetrySet.new.clear

  # Clear scheduled jobs

  Sidekiq::ScheduledSet.new.clear

  # Clear 'Dead' jobs statistics

  Sidekiq::DeadSet.new.clear

  # Clear 'Processed' and 'Failed' jobs statistics

  Sidekiq::Stats.new.reset

  # Clear specific queue

  stats = Sidekiq::Stats.new
  stats.queues
  # => {"main_queue"=>25, "my_custom_queue"=>1}

  queue = Sidekiq::Queue.new('my_custom_queue')
  queue.count
  queue.clear

  ``


* Test ActionMailbox
  `http://localhost:3000/rails/conductor/action_mailbox/inbound_emails/`

* Restart app in production
  `passenger-config restart-app`

* Setup localhost for using Google Storage service
OCR for PDF and TIFF files works only with files that are stored on a G.S. bucket. So, even in dev
mode we need to use one GS storage.

For this to work Cross Origin settings must be made. Created the cors.json file as mentioned here
https://github.com/rails/rails/issues/40852 and using gsutil service I have successfully managed
to make the bucket available in dev mode.
