require 'spec_helper'

describe Timer do

  describe :every do
    it 'fails when missing hours, minutes, or seconds' do
      @runtime = Factor::Connector::Runtime.new(Timer)
      @runtime.start_listener([:every], hour:1)
      expect(@runtime).to message info:'Starting timer every 1h'
    end
  end
end
