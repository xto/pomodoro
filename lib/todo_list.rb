require 'task'

class ToDoList
  @tasks

  def initialize
    @tasks = Array.new 
  end

  def add_task name
    raise InvalidTaskError.new "No name has been provided" if name.empty?
    @tasks.push Task.new name,@tasks.size+1
  end

  def get_next_task
    @tasks.shift
  end
end
