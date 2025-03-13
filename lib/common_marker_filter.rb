require 'commonmarker'

module Nanoc::Filters
  class CommonMarkerFilter < Nanoc::Filter
    identifier :common_marker
    requires 'commonmarker'

    class CustomHtmlRenderer < ::CommonMarker::HtmlRenderer
      STYLE = 'pastie'.freeze

      def header(node)
        block do
          id = node.first.string_content.downcase.gsub(/[^\w]/, '-')
          out('<h', node.header_level, " id=\"#{id}\"", "#{sourcepos(node)}>", :children,
            '</h', node.header_level, '>')
        end
      end

      def link(node)
        raise "Link Error" if node.url.nil?

        out('<a href="', node.url.nil? ? '' : escape_href(node.url), '"')
        if node.title && !node.title.empty?
          out(' title="', escape_html(node.title), '"')
        end
        if node.url && node.url =~ %r{https?:\/\/}i && node.url !~ /cloudmailin/i
          out(' rel="nofollow"')
        end
        out(' target="_blank"') if node.url && node.url =~ %r{https?:\/\/}i
        out('>', :children, '</a>')
      end

      def code_block(node)
        source = node.string_content
        # lang = CGI.escapeHTML(node.fence_info)
        lang = node.fence_info.split(/\s+/)[0]
        lexer = ::Rouge::Lexer.find_fancy(node.fence_info) || ::Rouge::Lexers::PlainText.new
        formatter = ::Rouge::Formatters::HTMLInline.new(STYLE)

        out("<pre#{sourcepos(node)}><code class=\"language-#{lang}\">")
        out(formatter.format(lexer.lex(source)))
        out('</code></pre>')
      end

      def image(node)
        url = node.url.sub(%r{^/content}, '')

        # Create a temporary renderer to get plain text of children
        alt = ''
        node.each do |child|
          if child.type == :text
            alt += child.string_content
          end
        end

        out('<img src="', escape_href(url), '"')
        out(' alt="', escape_html(alt), '"')
        out(' title="', escape_html(node.title), '"') if node.title && !node.title.empty?
        out(" />")
        out('<span class="image-caption">', escape_html(alt), '</span>') if ENV['NANOC_ENV'] == 'development'
      end
    end

    def run(content, _params = {})
      opts = %i[DEFAULT]
      exts = %i[tagfilter autolink table strikethrough tasklist]
      common_links = File.read(File.expand_path('content/_common_links.md'))
      doc = CommonMarker.render_doc(content + common_links, opts, exts)
      CustomHtmlRenderer.new(options: opts, extensions: exts).render(doc)
    end
  end
end
