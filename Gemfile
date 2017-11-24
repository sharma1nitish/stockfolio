source 'https://rubygems.org'

ruby '2.4.0'

# Stack
gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'pg'
gem 'foreman'

# View
gem 'slim-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'

# Auth
gem 'devise'

# Misc
gem 'httparty'
gem 'jbuilder', '~> 2.5'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'byebug'
end

group :development, :test do
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
end

# Logging
group :production, :staging do
  gem 'rails_12factor'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
