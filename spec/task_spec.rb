$:.unshift(File.dirname(__FILE__)+"/../")

require 'lib/task'

describe 'Task' do
  
  describe "creation" do 
    it "should have a name" do
      task = Task.new "writing first test", 1
      task.name.should == "writing first test"
    end

    it "should raise an error when no name is provided" do
      lambda{Task.new "",1}.should raise_error InvalidTaskError
    end

    it "should assign the last rank (end of the queue) when no rank is provided" do
      task1 = Task.new "test task1",1
      task2 = Task.new "test task2",2
      task1.rank.should == 1
      task2.rank.should == 2
    end

    it "should create a pomodoro by default" do
      Pomodoro.should_receive(:new).once.with(25, "1 pomodoro task")
      task1 = Task.new "1 pomodoro task",1
    end
    
    it "should create a pomodoro by default" do
      Pomodoro.should_receive(:new).exactly(20).times.with(25, "1 pomodoro task")
      task1 = Task.new "1 pomodoro task",1,20
    end

    it "should be flagged as underestimated when the number of pomodoros is greater than the estimate" do
      task1 = Task.new "1 pomodoro task",1
      task1.add_pomodoro
      task1.is_underestimated?.should be_true
    end

  end

end
