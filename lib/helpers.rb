Bundler.require(:default)
$:.unshift File.dirname(__FILE__)

include Nanoc::Sprockets::Helper
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

def aws_ip_range(region, type = "*")
  @json ||= fetch_json
  query = ".prefixes[] | select((.region==\"#{region}\") and (.service==\"#{type}\")) | .ip_prefix"
  JQ(@json).search(query).join("\n")
end

private

def fetch_json
  uri = URI('https://ip-ranges.amazonaws.com/ip-ranges.json')
  Net::HTTP.get_response(uri).body
end
