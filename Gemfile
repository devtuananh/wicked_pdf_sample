source "https://rubygems.org"

ruby "2.6.1"
gem "rails", "~> 5.2.2"

# Use Puma as the app server
gem "puma", "~> 3.7"
# Turbolinks makes navigating your web application faster
gem "turbolinks", "~> 5"

# Use sqlite3 as the database for Active Record
gem "sqlite3"
gem "config"
gem "figaro"

# Css jquery
gem "coffee-rails", "~> 4.2"
gem "jbuilder", "~> 2.5"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "bootstrap", "~> 4.0.0"
gem "jquery-rails", "~> 4.3.1"
gem "kaminari"
gem "bootstrap4-kaminari-views"
gem "font-awesome-rails"
gem "pdfjs_viewer-rails"

# import and import
gem "roo"
gem "activerecord-import"
gem "docx"
gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "rubyzip", "< 1.0.0"
gem "axlsx"
gem "axlsx_rails"
gem "sdoc", "~> 0.4.0", group: :doc

# upload
gem "carrierwave"
gem "fog-aws"
gem "aws-sdk-s3", "~>1"
gem 'toastr-rails'
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"
# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]