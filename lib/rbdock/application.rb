require 'uri'

module Rbdock

  class Application

    def self.prepare url
      new(url).execute
    end

    def initialize url
      @logger = Log4r::Logger.new("rbdock::application")
      @logger.info("Preparing application at #{url}")
      @url    = url
    end

    def execute
      
      if local?
        raise ArgumentError, "Application path #{@url} is not exist" if not File.exist?(@url)
        @logger.debug("Use local application at #{@url}")
        return @url
      end

      if git?
        raise StandardError, "Command git not found." if `which git`.empty?   
        @logger.debug("Use `git` to clone application")
        
        if cloned? and same_application?
          @logger.debug("Update application at #{@url}")
          git_update
        end

        if cloned? and not same_application?
          @logger.debug("Replace application at #{@url}")
          replace
        end

        if not cloned?
          @logger.debug("Clone application at #{@url}")
          git_clone
        end
      end
      
      return clone_path
      
    end

    def local?
      not URI.regexp =~ @url
    end

    def git?
      @url.include?(".git") || @url.include?("github.com") || @url.include?("git@")
    end

    def cloned?
      File.exist? clone_path
    end

    def same_application?
      @url == `git --git-dir=#{clone_path}/.git config --get remote.origin.url`.chomp
    end

    def clone_path
      @clone_path ||= '.rbdock_app'
    end

    def git_clone
      checked_system("git clone -q #{@url} #{clone_path}", "Clone")
      STDERR.puts "Clone #{@url} to #{clone_path}/"
    end

    def git_update
      checked_system("cd #{clone_path}; git pull -q", "Update")
      STDERR.puts "Update #{@url}"
    end

    def replace
      checked_system("rm -fr #{clone_path}", "Replace")
      git_clone
      STDERR.puts "Delete old application and clone #{@url} to #{clone_path}/"
      clone_path
    end

    def checked_system command, action
      if not system(command)
        raise StandardError, "#{action} #{@url} is failed."
      end
    end
    
  end
end
