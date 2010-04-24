require 'task'
$:.unshift(File.dirname(__FILE__)+"/../")

class ToDoList
  @tasks
  @filename

  def initialize filename="lists/default_list.yml"
    @filename = filename
    @tasks = Array.new 
    load_all_tasks_from_file if File.exists? filename
  end

  def add_task name,estimate =1
    raise InvalidTaskError.new "No name has been provided" if name.empty?
    task = Task.new name,@tasks.size+1,estimate
    persist_task task
    @tasks.push task
  end

  def get_next_task
    @tasks.shift
  end

  private

  def persist_task task
    File.open(@filename, 'a') {|f| f.write(task.to_yaml) }
  end

  def load_all_tasks_from_file 
    File.open(@filename) do |yaml_file|
      YAML.load_documents( yaml_file ) do |yaml_doc|
        @tasks.push yaml_doc
      end
    end
  end
end
