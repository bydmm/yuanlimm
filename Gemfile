source 'http://gems.ruby-china.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use Puma as the app server
gem 'puma', '~> 3.7'

# DB
# Mysql
gem 'mysql2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# ETC
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'hiredis'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
# crontab
gem 'whenever', '0.10.0'
# job queue
gem 'sidekiq', '~> 5.1.0'
# simple DSL for accessing HTTP and REST resources
gem 'rest-client', '~> 2.0.2'
# Group by Time
gem 'groupdate'
# Pageing
gem 'kaminari'
# Error Log
gem "sentry-raven"
# CC protect
gem 'rack-attack'
# Log helper
gem "lograge"
# json faster
gem 'oj'

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'fabrication'
  gem 'faker'
  gem 'webmock'
  gem 'vcr'
  gem 'therubyracer'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
