require 'requirements'

$:.unshift(File.dirname(__FILE__)+"/../")

class ToDoList
  attr_reader :tasks

  def initialize     
    @tasks = Array.new 
  end

  def add_task description,estimate =1
    raise InvalidTaskError.new "No description has been provided" if description.empty?
    task = Task.new description,@tasks.size+1,estimate
    @tasks.push task
  end

  def get_next_task
    @tasks.first
  end

  def execute_task
    task = @tasks.shift
    task.start
    task.set_as_done
  end
    
  def remove_task task_description
    @tasks.each {|task| @tasks.delete task if task.description == task_description}
  end

  def find_task_by_description task_description
    @tasks.each {|task| return task if task.description == task_description}
  end
  
end