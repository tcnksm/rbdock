require 'optparse'

module Rbdock
  class Command
    module Options
      
      def self.parse!(argv)
        options = {}

        set_default_value options
        command_parser = create_command_parser options
        
        begin
          command_parser.parse!(argv)          
          ruby_version_perser options, argv
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end
        
        options
      end

      def self.set_default_value options
        options[:image] = "ubuntu"
      end

      def self.create_command_parser options
        OptionParser.new do |opt|
          show_version opt
          show_help opt

          opt.on('-i name','--image=name', 'Set image name(ubuntu|centos)') { |v|
            options[:image] = v
          }
          opt.on('--rbenv', desc='Use rbenv') {
            options[:use_rbenv] = true
          }
          opt.on('--rvm',   desc='Use rvm') {
            options[:use_rvm] = true
          }
          opt.on('-a path','--app=path', 'Add Rails/Sinatra app') { |path|
            options[:app] = path
          }         
          opt.on('-l','--list', 'List all available ruby versions') {
            list_ruby_versions
          }          
        end
      end

      def self.show_version opt        
        opt.on_tail('-v','--version','Show version') {
          opt.version = Rbdock::VERSION
          STDERR.puts opt.ver
          exit              
        }        
      end

      def self.show_help opt
        opt.banner   = "Usage: #{opt.program_name} <ruby-versions> [<args>]"
        opt.on_tail('-h','--help','Show this message') {
          STDERR.puts opt.help
          exit              
        }
      end

      def self.ruby_version_perser options, argv
        raise ArgumentError, "#{options[:command]} ruby versions not found." if argv.empty?
        check_version_avaiable argv
        options[:ruby_versions] = argv
        options
      end

      def self.check_version_avaiable argv
        argv.each do |v|
          if not Rbdock::Generate.ruby_versions.include? v
            raise ArgumentError, "Definition not found: #{v} \n\nYou can list all available ruby versions with `rbdock --list'."            
          end
        end
      end

      def self.list_ruby_versions
        STDERR.print "Available versions:\n   "
        STDERR.print Rbdock::Generate.ruby_versions.join("\n   ")
        STDERR.puts
        exit
      end
      
    end
  end
end

