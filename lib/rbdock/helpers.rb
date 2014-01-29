module Rbdock
  def self.source_root    
    @source_root ||= Pathname.new(File.expand_path('../../../', __FILE__))
  end
end
