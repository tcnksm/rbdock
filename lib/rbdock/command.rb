module Rbdock

  # @author tcnksm
  class Command
    autoload :Options, "rbdock/command/options"
    
    def self.run argv
      new(argv)
    end


    def initialize argv
      @argv = argv
      p Options.parse!(argv)
    end
    
    def create
      
    end

  end
end
