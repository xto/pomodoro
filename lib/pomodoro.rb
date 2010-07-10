require 'requirements'

class Pomodoro
  include DataMapper::Resource
  
  belongs_to :task
  property :id, Serial
  property :length, Integer
  property :status, Enum[:new, :in_progress, :done], :default => :new
  
  def initialize attributes
    raise ArgumentError.new "A Pomodoro must have a duration of at least 1 minute" if attributes[:length].empty? || attributes[:length] < 1
    attributes.merge! :status => :new if attributes[:status].empty?
    super attributes
  end
  

  def start
    @status = :in_progress
    Notify.init("Pomodoro")
    notification = Notify::Notification.new "Pomodoro started", "You now have "+@length.to_s+" minutes to complete \""+@task_name+"\"",nil,nil
    notification.show

    1.upto(@length){|i|
      Kernel.sleep 60
      notification.update "#{i.to_s} minute(s) have passed", "You have #{(@length-i).to_s} minutes left", nil
      notification.show
    }
    
    notification.update "Pomodoro finished", "Take a break", nil
    notification.show
    @status = :finished
    Notify.uninit
  end

end
