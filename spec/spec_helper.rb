$:.unshift(File.dirname(__FILE__)+"/../lib/")

require 'requirements'
require 'dm-spec'

DataMapper.setup(:default, 
  {
    :adapter => 'sqlite3',
    :host => 'localhost',
    :database =>'db/test_pomodoro.sqlite3',
    :username => '',
    :password => ''
  })

Spec::Runner.configure do |config|
  config.include(DataMapperMatchers)
  config.before(:each) do
    DataMapper.auto_migrate!
  end
end

def mock_datamapper_model model, stubs
  mock(model, stubs.merge(:readonly? => false, :saved? => false))
end
