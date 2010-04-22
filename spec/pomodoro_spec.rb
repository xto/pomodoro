$:.unshift(File.dirname(__FILE__)+"/../")

require 'lib/pomodoro.rb'

describe "Pomodoro" do

  it "should send a notification every minute" do
    Kernel.stub!(:sleep)

    mock_notify = mock(Notify::Notification)
    Notify::Notification.stub!(:new).and_return(mock_notify)
    mock_notify.should_receive(:show).exactly(6).times
    mock_notify.should_receive(:update).exactly(5).times
    pomodoro = Pomodoro.new 5,"Task name"
    pomodoro.start
  end

end
