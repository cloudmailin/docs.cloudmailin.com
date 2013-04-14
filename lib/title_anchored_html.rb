require 'redcarpet'

class TitleAnchoredHTML < Redcarpet::Render::HTML
  def header(title, level)
    "<h#{level} id=\"#{anchor_from_title(title)}\">#{title}</h#{level}>"
  end

protected
  def anchor_from_title(title)
    title.downcase.gsub(/[^\w]/, '-')
  end
end