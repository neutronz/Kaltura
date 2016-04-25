require 'digest/sha1'

module Kaltura
  class Session < DelegateClass(Hashie::Mash)
    extend ClientResource

    @@kaltura_session ||= nil

    def self.start
      _clear_kaltura_session

      fetched_response =  if Kaltura.config.application_token
                            unprivileged_session = fetch('session', 'startWidgetSession', "widgetId" => "_1851201").first["ks"]
                            fetch('appToken', 'startSession', _app_token_request_options(unprivileged_session)).first
                          else
                            fetch('session', 'start', _session_request_options).first
                          end

      _assign_kaltura_session(fetched_response)

      return fetched_response.ks if fetched_response.respond_to?(:ks)
      fetched_response
    end

    def self.kaltura_session
      @@kaltura_session
    end

    protected

    def self._session_request_options
      { partnerId: Kaltura.config.partner_id, secret: (Kaltura.config.administrator_secret || Kaltura.config.user_secret), type: Kaltura.config.administrator_secret ? 2 : 0 }
    end

    def self._app_token_request_options(unprivileged_session)
      { id: Kaltura.config.application_token.to_s, ks: unprivileged_session , tokenHash: token_hash(unprivileged_session.to_s) }
    end

    def self._clear_kaltura_session
      @@kaltura_session = nil
    end

    def self._assign_kaltura_session(response)
      if response.respond_to?(:result) and !response.result.respond_to?(:error)
        @@kaltura_session = response.result
      elsif response.respond_to?(:ks)
        @@kaltura_session = response.ks
      end
    end

    class << self
      private
      def token_hash(session)
        Digest::SHA1.hexdigest(session.to_s + Kaltura.config.application_secret.to_s)
      end
    end
  end
end
