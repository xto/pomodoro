$:.unshift(File.dirname(__FILE__)+"/../")
require 'lib/todo_list'
require 'spec_helper'

describe 'ToDoList' do
  describe "with fake file" do
    before :each do
      Kernel.stub!(:sleep)
    end

    it "should not accept no description when adding a task" do
      todo_list = ToDoList.new
      lambda{todo_list.add_task ""}.should raise_error InvalidTaskError, "No description has been provided"
    end

    it "should keep track of all task it has created" do
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.find_task_by_description('task1').description.should == "task1"
      todo_list.find_task_by_description('task2').description.should == "task2"
    end

    it "should create a new task with a rank that is the last" do
      mock_notify = mock(Notify::Notification)
      Notify::Notification.stub!(:new).and_return(@mock_notify) 
      @mock_notify.should_receive(:update).exactly(26).times
      @mock_notify.should_receive(:show).exactly(27).times
      
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.get_next_task.rank.should == 1
      todo_list.execute_task
      todo_list.get_next_task.rank.should == 2
    end

  
    it "should remove unwanted tasks" do
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.remove_task "task1"
      
      todo_list.tasks.size.should == 1
      todo_list.get_next_task.description.should == "task2"
    end
    
    describe "search method" do
      it "find_task_by_description should return the task when found" do
        mock_task1 = mock(Task, {:description => 'task1'})
        mock_task2 = mock(Task, {:description => 'task2'})
        
        Task.stub!(:new).and_return(mock_task1)
        todo_list = ToDoList.new
        todo_list.add_task "task1"
        Task.stub!(:new).and_return(mock_task2)
        todo_list.add_task "task2"
        
        todo_list.find_task_by_description("task1").should == mock_task1
      end
    end
  end
end
