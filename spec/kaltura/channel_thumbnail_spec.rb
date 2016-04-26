require 'spec_helper'

describe Kaltura::ChannelThumbnail do
  use_vcr_cassette

  describe "::list" do
    before do
      Kaltura.configure do |config|
        config.application_token = "1_hyqx5z91"
        config.application_secret = "7cbd774772933e4cd618e29794e71ca2"
        config.service_url = 'http://www.kaltura.com'
      end
    end

    describe "retrieving without parameters." do
      before do
        options = {filter: {:objectIdIn => 30830272}}
        @channel_thumbnail_list = Kaltura::ChannelThumbnail.list(options)
      end

      it { expect(@channel_thumbnail_list).to respond_to :each }
      it { expect(@channel_thumbnail_list.first).to be_an_instance_of Kaltura::ChannelThumbnail }
      it { expect(@channel_thumbnail_list.size).to eq 1463 }
    end

    #describe "filtering and sorting" do
      #context "when able to filter." do
        #before do
          #@options = { :filter => { :parentIdEqual => 25176011, :orderBy => "+name" } }
        #end

        #it { expect{Kaltura::Category.list(@options)}.not_to raise_error }
        #it { expect(Kaltura::Category.list(@options).first.total_count).to eq 285 }
      #end
    #end
  end
end
