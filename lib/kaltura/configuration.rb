require 'singleton'

module Kaltura
  class Configuration
    include Singleton

    @@defaults = {
      :partner_id => 'PARTNER_ID',
      :service_url => 'http://kaltura.com'
    }

    attr_accessor :administrator_secret,  :user_secret, :partner_id, :service_url, :application_token, :application_secret

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end

  def self.config
    Configuration.instance
  end

  def self.configure
    clear_config
    yield config
  end

  def self.clear_config
    %i[administrator_secret user_secret partner_id application_token application_secret].each do |k|
      config.send("#{k}=", nil)
    end
  end
end
