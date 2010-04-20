# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TestRails_session',
  :secret      => '958052a5c13386f79a140657bbf1095c8f880e8b3349bf109edadc39445716bb9620caa12d9bd48768f201d7c75c20b3c21fa320d2fb11e1d9f6140aa646e923'
}

ActionController::Dispatcher.middleware.insert_before(ActionController::Session::CookieStore, FlashSessionCookieMiddleware, ActionController::Base.session_options[:key])

#  class ActionController::Session::CookieStore
#    def load_session(env)
#      request = Rack::Request.new(env)
#      session_data = request.cookies[@key] || request.params[@key]
#      data = unmarshal(session_data) || persistent_session_id!({})
#      [data[:session_id], data]
#    end
#  end
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
