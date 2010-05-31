# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional loadpaths for your own custom dirs
    # config.load_paths += %W( #{RAILS_ROOT}/extras )

    # Specify gems that this application depends on and have them installed with rake gems:install
    # config.gem "bj"
    # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
    # config.gem "sqlite3-ruby", :lib => "sqlite3"
    # config.gem "aws-s3", :lib => "aws/s3"

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Skip frameworks you're not going to use. To use Rails without a database,
    # you must remove the Active Record framework.
    # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**','*.{rb,yml}')]
    # config.i18n.default_locale = :de
    #    config.gem "mime-types"


    config.action_mailer.default_url_options({:host => "localhost:3000"})
    #    config.gem "openrain-action_mailer_tls", :lib => "smtp_tls.rb", :source => "http://gems.github.com"
    %w(middleware).each do |dir|
        config.load_paths << "#{RAILS_ROOT}/app/#{dir}"
    end

    ENV['RECAPTCHA_PUBLIC_KEY']  = '6LcbaboSAAAAADbBxT9yLOJ7CoLWLsuAfZr-aL-H'
    ENV['RECAPTCHA_PRIVATE_KEY'] = '6LcbaboSAAAAACJMtxxfExG5dm_GcDHuZl9WVjZG'

    config.gem(
        'thinking-sphinx',
        :lib     => 'thinking_sphinx',
        :version => '1.3.16'
    )

    config.gem 'delayed_job'
    config.gem "geokit"
    config.gem 'mime-types', :lib => "mime/types",     :version => '1.16'
    config.gem("authlogic")
    config.gem("searchlogic")
    config.gem "declarative_authorization", :source => "http://gemcutter.org"
    config.gem "formtastic"
    config.gem "validation_reflection"
    config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
    #    http://ym4r.rubyforge.org/
    config.gem "ym4r"
    config.gem "calendar_date_select"
    #    config.active_record.observers= :user_observer

    #for rmagick installation
    #    sudo apt-get install imagemagick
    #sudo apt-get install libmagick9-dev
    #sudo gem install rmagick
end

