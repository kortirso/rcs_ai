source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.8'
gem 'pg', '~> 0.19'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'

gem 'figaro'
gem 'whenever', require: false
gem 'slim'

group :development, :test do
    gem 'spring'
    gem 'rspec-rails'
    gem 'factory_girl_rails'
end

group :development do
    gem 'capistrano', require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano-rails', require: false
    gem 'capistrano-rvm', require: false
end

group :test do
    gem 'shoulda-matchers'
    gem 'json_spec'
end
