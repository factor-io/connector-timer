require 'spec_helper'

describe :timer do
  describe :every do
    it 'can run every second' do
      logger = double("logger", trigger:'hi')
      timer = Timer::Every.new(seconds:1)
      timer.add_observer(logger, :trigger)

      t = Thread.new {timer.run}

      expect(logger).to receive(:trigger).with(:trigger,hash_including(time_run: anything())) do
        t.kill
      end
      
      t.join
    end
  end

  describe :crontab do
    it 'can run a crontab' do
      logger = double("logger", trigger:'hi')
      timer = Timer::Cron.new(crontab:'* * * * * *')
      timer.add_observer(logger, :trigger)

      t = Thread.new { timer.run }

      expect(logger).to receive(:trigger).with(:trigger,hash_including(time_run: anything())) do
        t.kill
      end
      
      t.join
    end
  end
end
