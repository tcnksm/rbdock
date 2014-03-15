require "pathname"
require "uri"

module Rbdock

  class << self

    def source_root    
      @source_root ||= Pathname.new(File.expand_path('../../../', __FILE__))
    end
  end  
end
