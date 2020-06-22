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
    end

    def run(content, _params = {})
      opts = %i[DEFAULT]
      exts = %i[tagfilter autolink table strikethrough tasklist]
      doc = CommonMarker.render_doc(content, opts, exts)
      CustomHtmlRenderer.new(options: opts, extensions: exts).render(doc)
    end
  end
end
