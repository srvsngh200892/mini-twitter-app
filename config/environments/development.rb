TwitterApp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = true
  config.cache_store = :dalli_store
  #config.s3_bucket = 'nightpanda-dev'

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_controller.perform_caching = true
  
  #uncomment this to send mail in development mode
  config.action_mailer.delivery_method = :letter_opener

  #I don't want mails to be send in development mode
  # config.action_mailer.delivery_method = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  config.action_mailer.default_url_options = { host: 'localhost', port: 8080 }

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.aws_link = ""
  
  # Enable online bookings
  config.website_bookings_enabled = "true"
  # Enable online payments
  config.website_payments_enabled = "true"
  # config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # Custom Configurations
  config.send_mail = true
  config.send_sms = false
  config.send_gcm = false
  $otpForDevelopement = "100900"
  config.paper_trail = ENV['PAPER_TRAIL_ENABLED'] || "true"
  # Development only - warn of n+1 queries and potentially unused eager loading
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false
    Bullet.bullet_logger = true
    Bullet.console = true
    # Bullet.growl = true
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    Bullet.rails_logger = true
    # Bullet.airbrake = true
    Bullet.add_footer = true
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
    ######### Valid OTP For Development 

  end
end
