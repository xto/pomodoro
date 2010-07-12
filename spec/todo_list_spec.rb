$:.unshift(File.dirname(__FILE__)+"/../")
require 'lib/todo_list'
require 'spec_helper'

describe 'ToDoList' do
  
  describe "structure" do
    it "should have many tasks" do
      ToDoList.should has_many(:tasks)
    end
  end
  
  before :each do
    Kernel.stub!(:sleep)
    @todo_list = ToDoList.new
    @todo_list.save
  end

  it "should not accept no description when adding a task" do
    lambda{@todo_list.add_task ""}.should raise_error InvalidTaskError, "No description has been provided"
  end

  it "should keep track of all task it has created" do
    @todo_list.add_task :description => "task1"
    @todo_list.add_task :description => "task2"
    @todo_list.find_task_by_description('task1').description.should == "task1"
    @todo_list.find_task_by_description('task2').description.should == "task2"
  end

  it "should create a new task with a rank that is the last" do
    @todo_list.add_task :description => "task1"
    @todo_list.add_task :description => "task2"
    @todo_list.tasks.count.should == 2
    task1 = @todo_list.get_next_task
    task1.rank.should == 1
    task1.set_as_done
    
    task2 = @todo_list.get_next_task
    task2.rank.should == 2
  end

  
  it "should remove unwanted tasks" do
    @todo_list.add_task :description => "task1"
    @todo_list.add_task :description => "task2"
    @todo_list.remove_task "task1"
    
    @todo_list.tasks.size.should == 1
    @todo_list.get_next_task.description.should == "task2"
  end
  
end
