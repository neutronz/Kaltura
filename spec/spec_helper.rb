$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'kaltura'
require 'vcr'
require 'pry'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros  
end
