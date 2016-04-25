require 'spec_helper'

describe Kaltura::Configuration do
  context "as a DSL" do
    describe "should properly set and read config values" do
      before do
        Kaltura.configure do |config|
          config.partner_id = 15
          config.administrator_secret = 'asdf'
          config.user_secret = 'abc123'
          config.application_token = "qwerty"
          config.service_url = 'http://waffles.com'
        end
      end

      it { Kaltura.config.partner_id.should == 15 }
      it { Kaltura.config.administrator_secret.should == 'asdf' }
      it { Kaltura.config.user_secret.should == 'abc123' }
      it { Kaltura.config.application_token.should == 'qwerty' }
      it { Kaltura.config.service_url.should == 'http://waffles.com' }
    end
  end
end
