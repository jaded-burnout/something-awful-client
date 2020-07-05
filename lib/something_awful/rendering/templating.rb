require "erb"

module Templating
  def render(template_path)
    source = Pathname.new(template_path.to_s).read
    ERB.new(source).result(binding)
  end
end
