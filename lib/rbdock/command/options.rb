require 'optparse'

module Rbdock
  class Command
    module Options
      
      def self.parse!(argv)
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v','--version','Show version') {
            opt.version = Rbdock::VERSION
            STDERR.puts opt.ver
            exit              
          }         
        end
        
        command_parser.parse!(argv)
      end
    end
  end
end
