require 'spec_helper'

describe Timer do
  before :each do
    @runtime = Factor::Connector::Runtime.new(Timer)
  end

  describe :every do
    it 'can run every second' do
      @runtime.start_listener([:every], seconds:1)
      expect(@runtime).to message info:'Starting timer every 1s'
      expect(@runtime).to trigger
      @runtime.stop_listener
    end

    it 'fails with bad time' do
      @runtime.start_listener([:every], foo:'notime')

      expect(@runtime).to fail 
    end
  end

  describe :crontab do
    it 'can run a crontab' do
      crontab = '* * * * * *'
      @runtime.start_listener([:cron], crontab:crontab)
      expect(@runtime).to message info:"Starting timer using the crontab `#{crontab}`"
      expect(@runtime).to trigger
      @runtime.stop_listener
    end

    it 'fails with bad time' do
      @runtime.start_listener([:cron], crontab:'notime')

      expect(@runtime).to fail 
    end
  end
end
