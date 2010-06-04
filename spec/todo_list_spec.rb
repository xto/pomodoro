$:.unshift(File.dirname(__FILE__)+"/../")
require 'lib/todo_list'

describe 'ToDoList' do
  describe "with fake file" do
    before :each do
      File.stub!(:open)
    end

    it "should not accept no name when adding a task" do
      todo_list = ToDoList.new
      lambda{todo_list.add_task ""}.should raise_error InvalidTaskError, "No name has been provided"
    end

    it "should keep track of all task it has created" do
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.get_next_task.name.should == "task1"
      todo_list.get_next_task.name.should == "task2"
    end

    it "should create a new task with a rank that is the last" do
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.get_next_task.rank.should == 1
      todo_list.execute_task
      todo_list.get_next_task.rank.should == 2
    end

    it "should create an entry in a yaml file when a task is added" do
      File.should_receive(:open).with("lists/test_list.yml", 'a')

      todo_list = ToDoList.new "lists/test_list.yml"
      todo_list.add_task "task1"
    end
  end

  describe "file interactions" do
    it "should populate the task list with the content of the YAML file" do
      task = Task.new "task1",1
      File.open("lists/test_list.yml", 'a') {|f| f.write(task.to_yaml) }

      todo_list = ToDoList.new "lists/test_list.yml"
      todo_list.get_next_task.should == task
    end
  end
end
