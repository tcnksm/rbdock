require "erubis"

module Rbdock

  class Create

    def self.run options
      new(options).generate
    end

    def initialize options
      @image = options[:image]
      @ruby_versions = options[:ruby_versions]
    end

    def generate
      if use_rbenv?
        safe_write rbenv_template
      else
        safe_write default_template
      end
    end
    
    def safe_write content
      if File.exist? 'Dockerfile'
        STDERR.print "Overwrite Dockerfile? y/n: "
        if $stdin.gets.chomp == 'y'
          File.open('Dockerfile','w') do |f|
            f.puts content
          end
          STDERR.puts 'Dockerfile is successfully generated'
        else          
          puts content
        end
      else
        File.open('Dockerfile','w') do |f|
          f.puts content
        end
        STDERR.puts 'Dockerfile is successfully generated'
      end
    end

    def use_rbenv?
      @ruby_versions.length > 1 
    end

    def default_template
      template_path = Rbdock.source_root.join("templates/#{@image}_base_packages.erb")
      template = Erubis::Eruby.new(template_path.read, trim: true).result(binding)
      
      template_path = Rbdock.source_root.join("templates/ruby.erb")
      template << Erubis::Eruby.new(template_path.read, trim: true).result(binding)
      
      template_path = Rbdock.source_root.join("templates/bundler.erb")
      template << Erubis::Eruby.new(template_path.read, trim: true).result(binding)      
    end

    def rbenv_template
      template_path = Rbdock.source_root.join("templates/#{@image}_base_packages.erb")
      template = Erubis::Eruby.new(template_path.read, trim: true).result(binding)
      
      template_path = Rbdock.source_root.join("templates/rbenv_ruby.erb")
      template << Erubis::Eruby.new(template_path.read, trim: true).result(binding)
      
      template_path = Rbdock.source_root.join("templates/rbenv_bundler.erb")
      template << Erubis::Eruby.new(template_path.read, trim: true).result(binding)      
    end
  end
end
