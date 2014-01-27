module Rbdock

  # @author tcnksm
  class Command
    autoload :Options, "rbdock/command/options"
    
    def self.run argv
      new(argv).execute
    end

    def initialize argv
      @argv = argv
    end

    def execute
      options     = Options.parse!(@argv)
      sub_command = options.delete(:command)

      case sub_command
      when 'create'
        p options[:ruby_versions]
        p options[:image]
      end
    rescue => e
      abort "Error: #{e.message}"
    end

  end
end
