require File.expand_path('lib/helpers/item_helpers')

module Nanoc::Filters
  class AlgoliaFilter < Nanoc::Filter
    include ::ItemHelpers

    identifier :algolia
    type :text
    requires 'algolia'

    def initialize(hash = {})
      super

      app_id = @config.dig(:algolia, :application_id)
      api_key = @config.dig(:algolia, :api_key)
      index = @config.dig(:algolia, :index)

      raise ArgumentError, 'Missing algolia:application_id' unless app_id
      raise ArgumentError, 'Missing algolia:api_key' unless api_key
      raise ArgumentError, 'Missing algolia:index' unless index

      client = Algolia::Search::Client.create(app_id, api_key)
      @index = client.init_index(index + "_#{ENV['NANOC_ENV']}")
    end

    def extract_text(content)
      # html parsing not needed when processing the markdwon
      # doc = Nokogiri::HTML(content)
      # doc.xpath('//*/text()').to_a.join(" ").gsub("\r"," ").gsub("\n"," ")

      # Process markdown
      # remove code blocks
      content = content.gsub(/```.*?```/m, ' ')
      # remove headings
      content = content.gsub(/#+\s.*?\n/m, ' ')
      # remove blockquotes but keep content
      content = content.gsub(/>/m, ' ')
      # remove table formatting but keep content
      content = content.gsub(/\|-+/, ' ')
      content = content.gsub(/\|/, ' ')
      # Remove images
      content = content.gsub(/!\[.*?\]\(.*?\)/, ' ')
      # remove links but keep content
      content = content.gsub(/\[(.*?)\]\(.*?\)/) { $1 }
      # put newlines in for * and - lists
      content = content.gsub(/\s\*\s/, "\r\n ")

      content
    end

    def destroy_index
      @index.clear_objects
      puts "Index #{@index.name} cleared"
    end

    def run(content, params = {})
      title = item[:title] || item.identifier
      description = item[:description] || preview(item)
      @index.save_object(
        objectID: item.identifier,
        title: title,
        description: description,
        content: extract_text(content),
        deprecated: !!item[:deprecated],
        no_index: !!item[:no_index],
        raw: content
      ).wait

      puts "Indexed #{item.identifier} in Algolia"

      params[:preview] ? extract_text(content) : content
    end
  end
end
