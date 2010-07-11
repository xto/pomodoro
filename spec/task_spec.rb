$:.unshift(File.dirname(__FILE__)+"/../")
require 'spec_helper'
require 'lib/task'

describe 'Task' do
  
  describe "structure" do
    it "should have a description property" do
      Task.should has_property(:description)
    end
    
    it "should have a rank property" do
      Task.should has_property(:rank)
    end
    
    it "should have a estimate property" do
      Task.should has_property(:estimate)
    end
    
    it "should have a status property" do
      Task.should has_property(:status)
    end
    
    it "should have many pomodoros" do
      Task.should has_many(:pomodoros)
    end
    
  end
  
  describe "status" do
    before :each do
      @task = Task.new :description =>"do something", :estimate => 1
      @task.status.should == :new
      
      @mock_notify = mock(Notify::Notification)
      Notify::Notification.stub!(:new).and_return(@mock_notify)
      @mock_notify.stub!(:show)
      @mock_notify.stub!(:update)
    end
    
    it "should return :new on untouched task" do
      @task.is_new?.should be_true
    end
    
    it "should return :in_progress on task that have been started" do
      Kernel.stub!(:sleep)
      @task.start
      @task.is_in_progress?.should be_true
    end
    
    it "should return :in_progress on task that have been started" do
      @task.set_as_done
      @task.is_done?.should be_true
    end
  end
  
  describe "creation" do 
    it "should have a description" do
      task = Task.new "writing first test", 1
      task.description.should == "writing first test"
    end

    it "should raise an error when no description is provided" do
      lambda{Task.new "",1}.should raise_error InvalidTaskError
    end

    it "should assign the last rank (end of the queue) when no rank is provided" do
      task1 = Task.new "test task1",1
      task2 = Task.new "test task2",2
      task1.rank.should == 1
      task2.rank.should == 2
    end

    it "should create a pomodoro by default" do
      Pomodoro.should_receive(:new).once.with(:length => 25)
      task1 = Task.new :description =>"1 pomodoro task", :estimate =>1 ,:rank => 1
    end
    
    it "should create a pomodoro by default" do
      Pomodoro.should_receive(:new).exactly(20).times.with(:length => 25)
      task1 = Task.new :description =>"1 pomodoro task", :estimate =>20 ,:rank => 1
    end

    it "should be flagged as underestimated when the number of pomodoros is greater than the estimate" do
      task1 = Task.new :description =>"1 pomodoro task", :estimate =>1 ,:rank => 1      
      task1.add_pomodoro
      task1.is_underestimated?.should be_true
    end

  end
end
