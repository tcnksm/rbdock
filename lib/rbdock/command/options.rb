require 'optparse'

module Rbdock
  class Command
    module Options
      
      def self.parse!(argv)
        options = {}

        command_parser     = create_command_parser
        sub_command_parser = create_sub_command_parser(options)
        
        begin
          command_parser.order!(argv)          
          options[:command] = argv.shift          
          sub_command_parser[options[:command]].parse!(argv)
          ruby_version_perser options, argv
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end

        options
      end

      def self.create_command_parser
        OptionParser.new do |opt|
          opt.on_head('-v','--version','Show version') {
            opt.version = Rbdock::VERSION
            STDERR.puts opt.ver
            exit              
          }
          
          opt.on_head('-h','--help','Show help') {
            STDERR.puts opt.help
            exit              
          }         
        end
      end

      def self.create_sub_command_parser options
        parser = Hash.new do |k,v|
          raise ArgumentError, "'#{v}' is not sub command."
        end
        
        parser['create'] = OptionParser.new do |opt|
          options[:image] = "ubuntu" # default value
          opt.on('-i VAL','--image=VAL', 'Image name') { |val|
            options[:image] = val
          }          
        end
        
        parser
      end

      def self.ruby_version_perser options, argv
        if options[:command] == 'create'
          raise ArgumentError, "#{options[:command]} ruby versions not founnd." if argv.empty?
          options[:ruby_versions] = argv
        end
        options
      end
      
    end
  end
end
