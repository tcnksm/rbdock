module Rbdock

  class Command
    autoload :Options, "rbdock/command/options"
    
    def self.run argv
      new(argv).execute
    end

    def initialize argv
      @argv = argv
    end

    def execute
      options = Options.parse!(@argv)
      if options[:app]
        options[:app_path] = Rbdock.clone_app_to_local(options[:app])
      end
      Rbdock::Generate.run(options)
    rescue => e
      abort "Error: #{e.message}"
    end

  end
end
