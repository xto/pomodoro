require 'requirements'

$:.unshift(File.dirname(__FILE__)+"/../")

class ToDoList
  include DataMapper::Resource
  property :id, Serial
  has n, :tasks

  def add_task attributes
    raise InvalidTaskError.new "No description has been provided" if attributes[:description].empty?
    task = self.tasks.new :description => attributes[:description], :rank => get_tasks_count, :estimate => attributes[:estimate]
    task.save
  end

  def get_next_task
    @tasks.first
  end

  def get_tasks_count
    @tasks.size
  end
  
  def execute_task
    task = get_next_task
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