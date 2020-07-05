require "something_awful/version"

module SomethingAwful
  class Error < StandardError; end

  def self.root
    Pathname.new(File.join(File.dirname(__FILE__), ".."))
  end
end
