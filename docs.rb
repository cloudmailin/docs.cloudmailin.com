require 'sinatra'
require 'haml'
require 'sass'
require 'compass'
require 'fancy-buttons'
require 'rdiscount'

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end
  
  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end

H1_FORMAT = /<h1>(.*)<\/h1>/i

get '/:id' do
  if get_path(params[:id])
    doc = RDiscount.new(File.read(get_path(params[:id])), :autolink)
    html = doc.to_html
  
    h1_match = html.match(H1_FORMAT)
    
    @title = h1_match[1] if h1_match
    @body = html.gsub(H1_FORMAT, '')
    
    @docs = Hash[*Dir[File.join(File.dirname(__FILE__), "docs/*.txt")].sort.map do |d|
      match = d.match(/([^\/]*).txt/)
      if match
        [match[1][0].upcase + match[1][1..-1].gsub('_', ' '), match[1]]
      else
        []
      end
    end.flatten]
    
    puts @docs.inspect
    
    haml :doc
  else
    pass
  end
end

get '/stylesheets/docs.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :docs
end

def get_path(file_name)
  File.join(File.dirname(__FILE__), "docs/#{file_name.gsub(/d+_/, '')}.txt")
end