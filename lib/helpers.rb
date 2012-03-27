include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::XMLSitemap

def image_tag(path, options)
  full_path = path =~ /^http:\/\// ? path : "/assets/images/#{path}"
  tag(:image, options.merge!(:src => full_path))
end

def tag(name, options={})
  return "<#{name} " + options.map{|k, v| "#{k}='#{v}'"}.join(' ') + "/>"
end