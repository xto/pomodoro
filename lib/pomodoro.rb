require 'RNotify'

class Pomodoro
  attr_reader :task;
  attr_reader :length
  def initialize length, task_name
    @length = length
    @task_name = task_name
  end
  

  def start
    Notify.init("Pomodoro")
    notification = Notify::Notification.new "Pomodoro started", "You now have "+@length.to_s+" minutes to complete \""+@task_name+"\""
    notification.show

    1.upto(@length){|i|
      Kernel.sleep 60
      notification.update "#{i.to_s} minute(s) have passed", "You have #{(@length-i).to_s} minutes left"
      notification.show
    }
    
    Notify.uninit
  end

end
