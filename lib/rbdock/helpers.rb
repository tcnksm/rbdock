require "pathname"
require "uri"

module Rbdock

  class << self

    def source_root    
      @source_root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def clone_app_to_local url
      raise StandardError, "command git not found." if `which git`.empty?

      if local? url
        if not File.exist?(File.join(source_root, url))
          raise StandardError, "#{url} is not exit"
        end
        
        return url
      end
      
      if not already_cloned?
        return exec_clone url
      end

      if already_cloned? and same_app?(url)
        return update_app url
      end
      
      return replace_app url
    end

    def default_app_path
      '.rbdock_app'
    end
    
    private

    def local? url
      not URI.regexp =~ url
    end
    
    def exec_clone url
      if not system("git clone -q #{url} #{default_app_path}")
        raise StandardError, "clone #{url} is failed. Check url."
      end
      STDERR.puts "Clone #{url} to #{default_app_path}/"
      default_app_path
    end

    def replace_app url
      system("rm -fr #{default_app_path}")
      exec_clone url
      STDERR.puts "Delete old app and clone #{url} to #{default_app_path}/"
      default_app_path
    end
    
    def update_app url
      if not system("cd #{default_app_path}; git pull -q")
        raise StandardError, "clone #{url} is failed. Check url."
      end
      STDERR.puts "Update #{url}"
      default_app_path
    end

    def already_cloned?
      File.exist? default_app_path
    end

    def same_app? url
      url == `git --git-dir=.rbdock_app/.git config --get remote.origin.url`.chomp
    end
        
  end  
end
