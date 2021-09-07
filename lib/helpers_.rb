require 'rubygems'
require 'bundler'
Bundler.require(:default)

use_helper Nanoc::Sprockets::Helper
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Rendering
use_helper Nanoc::Helpers::XMLSitemap
use_helper ItemHelpers
use_helper SectionHelpers
use_helper OpenapiHelpers

def image_tag(path, options)
  full_path = image_path(path)
  tag(:image, options.merge!(:src => full_path))
end

def image_path(path)
  path.match?(/^http:\/\//) ? path : "/assets/images/#{path}"
end

def image_url(path)
  path.match?(/^http:\/\//) ? path : "#{@config[:base_url]}/assets/images/#{path}"
end

def tag(name, options={})
  "<#{name} " + options.map{|k, v| "#{k}='#{v}'"}.join(' ') + "/>"
end

def aws_ip_range(region, type = "*")
  @json ||= fetch_json
  query = ".prefixes[] | select((.region==\"#{region}\") and (.service==\"#{type}\")) | .ip_prefix"
  JQ(@json).search(query).join("\n")
end

def fetch_json
  uri = URI('https://ip-ranges.amazonaws.com/ip-ranges.json')
  Net::HTTP.get_response(uri).body
end
