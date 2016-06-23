module MethodLogger
  extend ActiveSupport::Concern

  def logger logname = nil
    logfile_name = logger_name logname
    @logger ||= Logger.new("#{Rails.root}/log/#{logfile_name}.log")
  end

  def logger_name logfile_name = nil
    logfile_name ||= "#{Rails.env}"
    logfile_name
  end

  module ClassMethods
    def logger
      @logger ||= Logger.new("#{Rails.root}/log/#{@logfile_name}.log")
    end

    private

    def logger_name logfile_name = nil
      logfile_name ||= "#{Rails.env}"
      @logfile_name = logfile_name
    end

  end

end
