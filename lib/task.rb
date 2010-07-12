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
  belongs_to :to_do_list
  
  def initialize attributes
    
    raise InvalidTaskError.new "No description has been provided" if attributes[:description].nil?
    attributes.merge! :status => :new if attributes[:status].nil?
    attributes.merge! :rank => self.to_do_list.count+1 if attributes[:rank].nil?
    
    super attributes
    1.upto(@estimate) {
      self.pomodoros.new :length => 25
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
    self.pomodoros.count > self.estimate
  end

  def add_pomodoro
    pomodoro = self.pomodoros.new :length => 25
    pomodoro.save
    self.save
  end

  def == task
    @description == task.description && @rank == task.rank && @estimate == task.estimate
  end
  
  def start
    @status = :in_progress
    self.save
    self.pomodoros.each do |pomodoro| 
      pomodoro.start
    end
  end
  
  def set_as_done
    self.status = :done
    self.save
    #raise RuntimeError.new unless self.status == :done
  end
end
