require 'requirements'

class Pomodoro
  include DataMapper::Resource
  
  belongs_to :task
  property :id, Serial
  property :length, Integer
  property :status, Enum[:new, :in_progress, :done], :default => :new
  
  def initialize length, task_name
    @length = length
    @task_name = task_name    
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
