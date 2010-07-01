$:.unshift(File.dirname(__FILE__)+"/../")

require 'lib/pomodoro'
require 'spec_helper'

describe "Pomodoro" do

  describe "structure" do
    it "should have a status attribute" do
      Pomodoro.should has_property(:status)
    end
    
    it "should have a length attribute" do
      Pomodoro.should has_property(:length)  
    end
    
    it "should belong to a Task" do
      Pomodoro.should belongs_to(:task)
    end
  end
  
  describe "description" do
    
    before :each do
      Kernel.stub!(:sleep)
      @mock_notify = mock(Notify::Notification)
      Notify::Notification.stub!(:new).and_return(@mock_notify)
    end
  
    it "should send a notification every minute" do
      @mock_notify.should_receive(:show).exactly(7).times
      @mock_notify.should_receive(:update).exactly(6).times
      pomodoro = Pomodoro.new 5,"Task name"
      pomodoro.start
    end
  
    it "should change status from 'new' to 'in progress' when it is started" do
      pomodoro = Pomodoro.new 5,"Task name"
      pomodoro.status.should == :new
      Thread.new {pomodoro.start}
      Kernel.sleep 1
      pomodoro.status.should == :in_progress
    end
  
    it "should change status from 'in progress' to 'finished' once the pomodoro is over" do
      @mock_notify.should_receive(:show).exactly(3).times
      @mock_notify.should_receive(:update).exactly(:twice)
      pomodoro = Pomodoro.new 1,"Task name"
      pomodoro.status.should == :new
      pomodoro.start
      Kernel.sleep 1 
      pomodoro.status.should == :finished
    end
  end
  
end
