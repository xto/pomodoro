$:.unshift(File.dirname(__FILE__)+"/../")
require 'lib/todo_list'

describe 'ToDoList' do
  describe "with fake file" do
    before :each do
      Kernel.stub!(:sleep)
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
      todo_list.find_task_by_name('task1').name.should == "task1"
      todo_list.find_task_by_name('task2').name.should == "task2"
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

    it "should create an entry in a yaml file when a task is added" do
      File.should_receive(:open).with("lists/test_list.yml", 'a')
      todo_list = ToDoList.new "lists/test_list.yml"
      todo_list.add_task "task1"
      
      
    end
  
    it "should remove unwanted tasks" do
      todo_list = ToDoList.new
      todo_list.add_task "task1"
      todo_list.add_task "task2"
      todo_list.remove_task "task1"
      
      todo_list.tasks.size.should == 1
      todo_list.get_next_task.name.should == "task2"
    end
    
    describe "search method" do
      it "find_task_by_name should return the task when found" do
        mock_task1 = mock(Task, {:name => 'task1'})
        mock_task2 = mock(Task, {:name => 'task2'})
        
        Task.stub!(:new).and_return(mock_task1)
        todo_list = ToDoList.new
        todo_list.add_task "task1"
        Task.stub!(:new).and_return(mock_task2)
        todo_list.add_task "task2"
        
        todo_list.find_task_by_name("task1").should == mock_task1
      end
    end
  end

  describe "file interactions" do
    it "should populate the task list with the content of the YAML file" do
      task = Task.new "task1",1
      filename = "lists/test_list.yml"
      File.open(filename, 'a') {|f| f.write(task.to_yaml) }
      
      todo_list = ToDoList.new "lists/test_list.yml"
      todo_list.get_next_task.should == task
    end
  end
end
