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
          ruby_version_perser options, argv
          sub_command_parser[options[:command]].parse!(argv)
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

      def self.ruby_version_perser options, argv
        if options[:command] == 'create'
          end_index = argv.index('-i').nil? ? -1 : (argv.index('-i') - 1)
          options[:ruby_versions] = argv[0..end_index]
        end
        options
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
      
    end
  end
end
