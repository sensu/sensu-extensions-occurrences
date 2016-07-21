require "rspec"
require "eventmachine"
require "sensu/logger"
require "sensu/settings"
require "securerandom"

module Helpers
  def timer(delay, &callback)
    periodic_timer = EM::PeriodicTimer.new(delay) do
      callback.call
      periodic_timer.cancel
    end
  end

  def async_wrapper(&callback)
    EM.run do
      timer(10) do
        raise "test timed out"
      end
      callback.call
    end
  end

  def async_done
    EM.stop_event_loop
  end

  def logger
    Sensu::Logger.get(:log_level => :fatal)
  end

  def settings
    Sensu::Settings.get
  end

  def epoch
    Time.now.to_i
  end

  def client_template
    {
      :name => "i-424242",
      :address => "127.0.0.1",
      :subscriptions => [
        "test"
      ],
      :timestamp => epoch
    }
  end

  def check_template
    {
      :name => "test",
      :type => "standard",
      :issued => epoch,
      :command => "echo WARNING && exit 1",
      :subscribers => [
        "test"
      ],
      :interval => 1,
      :output => "WARNING",
      :status => 1,
      :executed => epoch,
      :history => [0, 1]
    }
  end

  def event_template
    one_second_ago = epoch - 1
    {
      :id => ::SecureRandom.uuid,
      :client => client_template,
      :check => check_template,
      :last_ok => one_second_ago,
      :last_state_change => one_second_ago,
      :occurrences => 1,
      :action => :create
    }
  end
end
