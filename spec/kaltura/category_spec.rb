require 'spec_helper'

describe Kaltura::Category do
  use_vcr_cassette

  describe "::list" do
    before do
      Kaltura.configure do |config|
        config.application_token = "1_hyqx5z91"
        config.application_secret = "7cbd774772933e4cd618e29794e71ca2"
        config.service_url = 'http://www.kaltura.com'
      end
    end

    describe "retrieving without paramters." do
      before do
        @category_list = Kaltura::Category.list
      end

      it { expect(@category_list).to respond_to :each }
      it { expect(@category_list.first).to be_an_instance_of Kaltura::Category }
      it { expect(@category_list.size).to eq 1463 }
    end

    describe "filtering and sorting" do
      context "when able to filter." do
        before do
          @options = { :filter => { :parentIdEqual => 25176011, :orderBy => "+name" } }
        end

        it { expect{Kaltura::Category.list(@options)}.not_to raise_error }
        it {
          binding.pry
          results = Kaltura::Category.list(@options)
          expect(results.first.total_count).to eq 285
        }
      end

      context "when searching for a categories sub-categories (channels)" do
        context "when able to filter." do
          before do
            @options = {
              filter: {
                objectType: "KalturaCategoryFilter",
                advancedSearch: {
                  objectType: "KalturaMetadataSearchItem",
                  metadataProfileId: 4383411,
                  items: {
                    item0: {
                      objectType: "KalturaSearchCondition",
                      field: "/*[local-name()='metadata']/*[local-name()='Categories']",
                      value: 30818412
                    }
                  }
                }
              }
            }
          end

          it { expect{Kaltura::Category.list(@options)}.not_to raise_error }

          it "returns the nested categories" do
            results = Kaltura::Category.list(@options)
            expect(results.first.total_count).to eq 1
            expect(results.first.id.to_i).to eq 30830272
            expect(results.first.name).to eq "IR Webcasts"
          end
        end
      end
    end
  end
end
