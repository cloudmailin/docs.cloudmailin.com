require 'algolia'
require 'net/http'
require 'nokogiri'

# Fetches a fixed list of pages from the main website (algolia:
# external_pages in config.yaml) and indexes them alongside the docs
# content, so searches for things that live on www.cloudmailin.com
# (legal policies, pricing) return results in the docs search.
class AlgoliaExternalIndexer
  # Existing docs records reach ~39KB, so the record-size limit on this
  # plan comfortably allows full page text (the longest external page is
  # currently ~11K chars — truncating it would drop the GDPR/DPA text
  # people actually search for).
  MAX_CONTENT_LENGTH = 20_000
  MAX_REDIRECTS = 3

  def initialize(config:)
    @pages = config.dig(:algolia, :external_pages) || []

    index = config.dig(:algolia, :index) || ENV['ALGOLIA_INDEX']
    @skip_index = index.nil? || index.empty?
    return if @skip_index

    app_id = config.dig(:algolia, :application_id) || ENV['ALGOLIA_APPLICATION_ID']
    api_key = config.dig(:algolia, :api_key) || ENV['ALGOLIA_API_KEY']

    raise ArgumentError, 'Missing algolia:application_id' unless app_id
    raise ArgumentError, 'Missing algolia:api_key' unless api_key

    client = Algolia::Search::Client.create(app_id, api_key)
    @index = client.init_index(index + "_#{ENV['NANOC_ENV']}")
  end

  def run
    return if @skip_index

    @pages.each do |url|
      record = fetch(url)
      if record.nil?
        warn "Failed to fetch #{url} - not indexed"
        next
      end

      @index.save_object(
        record.merge(objectID: url, external: true, deprecated: false, no_index: false)
      ).wait
      puts "Indexed #{url} in Algolia"
    end
  end

  private

  def fetch(url, redirects_left = MAX_REDIRECTS)
    response = Net::HTTP.get_response(URI(url))

    case response
    when Net::HTTPRedirection
      return nil if redirects_left.zero?

      fetch(URI.join(url, response['location']).to_s, redirects_left - 1)
    when Net::HTTPSuccess
      extract(response.body)
    end
  rescue StandardError => e
    warn "#{url}: #{e.class}: #{e.message}"
    nil
  end

  def extract(html)
    doc = Nokogiri::HTML(html)
    doc.css('script, style, nav, header, footer, noscript').each(&:remove)

    content = (doc.at_css('main') || doc.at_css('body'))
              .text.gsub(/\s+/, ' ').strip[0, MAX_CONTENT_LENGTH]
    description = doc.at_css('meta[name="description"]')&.[]('content')

    {
      title: doc.at_css('title')&.text.to_s.sub(/\s*[|·—-]\s*CloudMailin.*\z/i, '').strip,
      description: description || content[0, 160],
      content: content
    }
  end
end
