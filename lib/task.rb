require 'pomodoro'
require 'yaml'

class InvalidTaskError < RuntimeError
end

class Task
  
  attr_reader :name
  attr_reader :rank
  attr_reader :estimate
  @status
  @pomodoro_list
  
  def initialize name, rank, estimate = 1
    raise InvalidTaskError.new "No name has been provided" if name.empty?
    @name = name
    @rank = rank
    @estimate = estimate
    @pomodoro_list = Array.new

    1.upto(@estimate) {
      @pomodoro_list << Pomodoro.new(25, @name)
    }
  end

  def is_done?
    @status == "done"
  end

  def is_unbegun?
    @status == "unbegun"
  end

  def is_in_progress?
    @status == "in progress"
  end

  def is_underestimated?
    @pomodoro_list.size > @estimate
  end

  def add_pomodoro
    @pomodoro_list << Pomodoro.new(25,@name)
  end

  def == task
    @name == task.name && @rank == task.rank && @estimate == task.estimate
  end
end
