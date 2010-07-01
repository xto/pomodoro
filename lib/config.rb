require 'requirements'

DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, 
  {
    :adapter => 'sqlite3',
    :host => 'localhost',
    :database =>'db/pomodoro.sqlite3',
    :username => '',
    :password => ''
  })
  
