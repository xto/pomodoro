require 'requirements'

class InvalidTaskError < RuntimeError
end

class Task
  include DataMapper::Resource
  
  property :id, Serial
  property :description, String
  property :rank, Integer
  property :estimate, Integer
  property :status, Enum[ :new, :in_progress, :done ], :default => :new
  has n, :pomodoros
  
  def initialize attributes
    
    raise InvalidTaskError.new "No description has been provided" if attributes[:description].empty?
    attributes.merge! :status => :new if attributes[:status].empty? 
    super attributes
    1.upto(@estimate) {
      self.pomodoros.new 
    }
  end

  def is_done?
    @status == :done
  end

  def is_new?
    @status == :new
  end

  def is_in_progress?
    @status == :in_progress
  end

  def is_underestimated?
    @pomodoro_list.size > @estimate
  end

  def add_pomodoro
    @pomodoro_list << Pomodoro.new(25,@name)
  end

  def == task
    @description == task.description && @rank == task.rank && @estimate == task.estimate
  end
  
  def start
    @status = :in_progress
    @pomodoro_list.each do |pomodoro| 
      pomodoro.start
    end
  end
  
  def set_as_done
    @status = :done
  end
end
