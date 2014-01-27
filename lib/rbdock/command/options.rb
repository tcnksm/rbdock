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

          opt.banner   = "Usage: #{opt.program_name} [-h|--help] [-v|--version] <command> [<args>]"
          opt.separator  ''
          opt.separator  "#{opt.program_name} Available Commands:"
          sub_command_help.each do |command|
            opt.separator [opt.summary_indent, command[:name].ljust(40), command[:summary]].join(' ')
          end
          opt.on_head('-h','--help','Show this message') {
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
          opt.banner = 'Usage: create <ruby-versions> [<args>]'          
          opt.on('-i VAL','--image=VAL', 'Set image name') { |val|
            options[:image] = val
          }
          opt.on_tail('-h','--help', 'Show this message') { help_sub_command(opt) }
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

      def self.help_sub_command parser
        STDERR.puts parser.help
        exit
      end

      def self.sub_command_help
        [
         {name: 'create <ruby-versions> -i <image>', summary: 'Generate Dockerfile which installs <ruby-versions>'}
        ]
      end
    end
  end
end
