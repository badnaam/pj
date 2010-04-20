require 'rack/utils'

class FlashSessionCookieMiddleware
    def initialize(app, session_key = '_session_id')
        @app = app
        @session_key = session_key
    end

    def call(env)
        if env['HTTP_USER_AGENT'] =~ /^(Adobe|Shockwave) Flash/
            req = Rack::Request.new(env)
            #      env['HTTP_COOKIE'] = "#{@session_key}=#{req.params[@session_key]}".freeze unless req.params[@session_key].nil?
#            env['HTTPCOOKIE'] = [ @sessionkey, ERB::Util.url_encode(req.params[@sessionkey]) ].join('=').freeze unless req.params[@session_key].nil?
env['HTTP_COOKIE'] = [ @session_key, ::Rack::Utils.escape(req.params[@session_key]) ].join('=').freeze unless req.params[@session_key].nil?
        end

        @app.call(env)
    end
end