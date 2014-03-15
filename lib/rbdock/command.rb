module Rbdock

  class Command
    autoload :Options, "rbdock/command/options"
    
    def self.run argv
      new(argv).execute
    end

    def initialize argv
      @logger = Log4r::Logger.new("rbdock::command")
      @argv   = argv
    end

    def execute
      options = Options.parse!(@argv)
      if options[:app]
        options[:app_path] = Rbdock::Application.prepare(options[:app])
      end
      Rbdock::Generate.run(options)
    rescue => e
      abort "Error: #{e.message}"
    end

  end
end
