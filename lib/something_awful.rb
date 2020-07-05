require "something_awful/version"
require "something_awful/client"

module SomethingAwful
  class Error < StandardError; end

  def self.root
    Pathname.new(File.join(File.dirname(__FILE__), ".."))
  end
end
