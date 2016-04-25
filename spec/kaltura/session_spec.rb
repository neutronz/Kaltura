require 'spec_helper'

describe Kaltura::Session do
  use_vcr_cassette
  let(:session) { @session ||= Kaltura::Session.start }

  describe "starting a session" do
    context "when providing a valid sercret and partner id" do
      before do
        Kaltura.configure do |config|
          config.partner_id = 1851191
          config.user_secret = 'd1be277fa0e84bde36b82deb1448a4cb'
          config.service_url = 'http://www.kaltura.com'
        end
      end

       it { session.result.should be_an_instance_of String }
       it { Kaltura::Session.kaltura_session.should eq(session.result) }
    end

    context 'when providing a valid application token' do
      before do
        Kaltura.configure do |config|
          config.application_token = "1_hyqx5z91"
          config.application_secret = "7cbd774772933e4cd618e29794e71ca2"
          config.service_url = 'http://www.kaltura.com'
        end
      end

      it { expect(session).to be_an_instance_of String }
      it { expect(Kaltura::Session.kaltura_session).to eq(session) }
    end

    describe "should not begin a session with invalid credentials." do
      let(:session) { nil }

      before do
        Kaltura.configure { |config| config.partner_id = 2 }
      end

      it { expect{Kaltura::Session.start}.to raise_error Kaltura::KalturaError }
    end
  end
end
