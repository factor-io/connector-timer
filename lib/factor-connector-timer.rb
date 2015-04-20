require 'factor/connector/definition'
require 'rufus-scheduler'

class Timer < Factor::Connector::Definition
  id :timer

  def initialize
    @scheduler = Rufus::Scheduler.new
  end

  listener :every do
    start do |params|
      hours   = params[:hours]
      minutes = params[:minutes]
      seconds = params[:seconds]
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
          info "Trigger time at #{time}"
          trigger time_run: time
        end
      rescue
        fail "The time specified `#{every}` is invalid"
      end

    end

    stop do
      @scheduler.stop
    end
  end

  listener :cron do
    start do |params|
      crontab = params.varify(:crontab,required:true,is_a:String)
      
      fail 'Crontab (:crontab) must have 5 or 6 time components' unless crontab.split(' ').count.between?(5,6)

      info "Starting timer using the crontab `#{crontab}`"
      begin
        @scheduler.cron crontab do
          trigger time_run: Time.now.to_s
        end
      rescue => ex
        fail "The crontab entry `#{crontab}` was invalid: #{ex.message}"
      end
    end

    stop do
      @scheduler.stop
    end
  end
end