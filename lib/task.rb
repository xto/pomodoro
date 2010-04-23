require 'pomodoro'

class InvalidTaskError < RuntimeError
end

class Task
  
  attr_reader :name
  attr_reader :rank
  attr_reader :estimate
  @pomodoro_list

  def initialize name, rank, estimate = 1
    raise InvalidTaskError.new "No name has been provided" if name.empty?
    @name = name
    @rank = rank
    @estimate = estimate
    @pomodoro_list = []

    1.upto(@estimate) {
      @pomodoro_list << Pomodoro.new(25, @name)
    }
  end
end
