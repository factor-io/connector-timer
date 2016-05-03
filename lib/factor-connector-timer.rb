require 'factor/connector'
require 'rufus-scheduler'

module Timer
  class Scheduled < Factor::Connector
    def initialize(options={})
      @scheduler     = Rufus::Scheduler.new
      @options       = options
      @keep_blocking = true
    end

    protected

    def block
      begin
        sleep 0.1
      end while @keep_blocking
      info "Timer stopped"
      @keep_blocking = true
    end

    def stop
      info "Stopping timer"
      @keep_blocking = false
    end
  end

  class Every < Scheduled
    def run
      hours   = @options[:hours]
      minutes = @options[:minutes]
      seconds = @options[:seconds]
      times   = [hours, minutes, seconds]

      fail 'hours, minutes, or seconds, but only one can be used' if times.count { |t| !t.nil? } > 1
      fail 'hours, minutes, or seconds must be defined' if times.all? { |t| t.nil? }

      every = "#{minutes}m" if minutes
      every = "#{seconds}s" if seconds
      every = "#{hours}h"   if hours

      info "Starting timer every #{every}"

      begin
        @scheduler.every every do
          time = Time.now.to_s
          trigger time_run: time
        end
      rescue
        fail "The time specified `#{every}` is invalid"
      end

      block
    end
  end

  class Cron < Scheduled
    def run
      crontab = @options[:crontab]
      
      fail 'Crontab (:crontab) must have 5 or 6 time components' unless crontab.split(' ').count.between?(5,6)

      info "Starting timer using the crontab `#{crontab}`"
      begin
        @scheduler.cron crontab do
          trigger time_run: Time.now.to_s
        end
      rescue => ex
        fail "The crontab entry `#{crontab}` was invalid: #{ex.message}"
      end
      block
    end
  end
end

Factor::Connector.register(Timer::Every)
Factor::Connector.register(Timer::Cron)