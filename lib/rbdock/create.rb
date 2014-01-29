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

    def self.ruby_versions
      [
       "1.8.6-p383",      
       "1.8.6-p420", 
       "1.8.7-p249", 
       "1.8.7-p302", 
       "1.8.7-p334", 
       "1.8.7-p352", 
       "1.8.7-p357", 
       "1.8.7-p358", 
       "1.8.7-p370", 
       "1.8.7-p371", 
       "1.8.7-p374", 
       "1.8.7-p375", 
       "1.9.1-p378", 
       "1.9.1-p430", 
       "1.9.2-p0", 
       "1.9.2-p180", 
       "1.9.2-p290", 
       "1.9.2-p318", 
       "1.9.2-p320", 
       "1.9.2-p326", 
       "1.9.3-dev", 
       "1.9.3-p0", 
       "1.9.3-p125", 
       "1.9.3-p194", 
       "1.9.3-p286", 
       "1.9.3-p327", 
       "1.9.3-p362", 
       "1.9.3-p374", 
       "1.9.3-p385", 
       "1.9.3-p392", 
       "1.9.3-p429", 
       "1.9.3-p448", 
       "1.9.3-p484", 
       "1.9.3-preview1", 
       "1.9.3-rc1", 
       "2.0.0-dev", 
       "2.0.0-p0", 
       "2.0.0-p195", 
       "2.0.0-p247", 
       "2.0.0-p353", 
       "2.0.0-preview1", 
       "2.0.0-preview2", 
       "2.0.0-rc1", 
       "2.0.0-rc2", 
       "2.1.0", 
       "2.1.0-dev", 
       "2.1.0-preview1", 
       "2.1.0-preview2", 
       "2.1.0-rc1", 
       "2.2.0-dev"  
      ]
    end
  end
end
