# Enable logging if it is requested.
require "log4r"

if ENV["RBDOCK_LOG"]
  require "log4r/config"
  Log4r.define_levels(*Log4r::Log4rConfig::LogLevels)

  level = nil
  begin
    level = Log4r.const_get(ENV["RBDOCK_LOG"].upcase)
  rescue NameError
    level = nil
  end

  level = nil if !level.is_a?(Integer)

  if !level
    STDERR.puts "Invalid RBDOCK_LOG level is set: #{ENV["RBDOCK_LOG"]}"
    STDERR.puts "Please use one of the standard log levels: debug, info, warn, or error"
  end

  if level
    logger = Log4r::Logger.new("rbdock")
    logger.outputters = Log4r::Outputter.stderr
    logger.level = level
    logger = nil
  end
  
end

# Always make the version avaiable
require "rbdock/version"

# Display global information
global_logger = Log4r::Logger.new("rbdock::global")
global_logger.info("Rbdock version: #{Rbdock::VERSION}")
global_logger.info("Ruby version: #{RUBY_VERSION}")
global_logger.info("RubyGems version: #{Gem::VERSION}")
ENV.each do |k,v|
  global_logger.info("#{k}=#{v.inspect}") if k =~ /^RBDOCK_/
end

require "rbdock/helpers"

module Rbdock
  autoload :Command, "rbdock/command"
  autoload :Generate, "rbdock/generate"
end
