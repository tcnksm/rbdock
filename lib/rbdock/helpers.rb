require "pathname"

module Rbdock

  class << self

    def source_root    
      @source_root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    end

    def clone_app_to_local url
      raise StandardError, "command git not found." if `which git`.empty?
      
      if not already_cloned?
        exec_clone url
      else
        if same_app? url
          update_app url
        else
          replace_app url
        end        
      end
    end

    def app_path
      '.rbdock_app'
    end    
    
    private

    def exec_clone url
      if not system("git clone -q #{url} #{app_path}")
        raise StandardError, "clone #{url} is failed. Check url."
      end
    end

    def replace_app url
      system("rm -fr #{app_path}")
      exec_clone url
    end
    
    def update_app url
      if not system("cd #{app_path}; git pull -q")
        raise StandardError, "clone #{url} is failed. Check url."
      end
    end

    def already_cloned?
      File.exist? app_path
    end

    def same_app? url
      url == `git --git-dir=.rbdock_app/.git config --get remote.origin.url`.chomp
    end
        
  end  
end
