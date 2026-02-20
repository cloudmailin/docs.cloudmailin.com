module OpenapiHelpers
  SPEC_LOCATION = ENV.fetch("API_SPEC_URL", "https://api.cloudmailin.com/api/v0.1")

  def render_api_fields(section, *fields, include_readonly: true)
    all_fields = fetch_api_section(section)
    fields = all_fields.keys if fields.empty?

    fields.filter_map do |field|
      content = all_fields[field]
      next if content.nil?
      next if !include_readonly && read_only?(content)

      render_api_field_content(field, content)
    end.join("\n")
  end

  def render_api_field(section, field)
    content = fetch_api_section(section)[field]
    render_api_field_content(field, content)
  rescue => e
    "Error finding #{field} in #{section}: #{e}"
  end

  private

  def render_api_field_content(field, content)
    description = html_escape(content['description']&.gsub("\n", " ") || "")
    description = "**Response only.** #{description}" if read_only?(content)
    type = content['type'] || content['oneOf']&.map { |o|
      o['type'] == 'array' ? "array of #{o.dig('items', 'type') || 'items'}" : o['type']
    }&.join(' or ')

    "| `#{field}` | #{type} | #{description}"
  end

  def read_only?(content)
    content['readOnly'] || content['allOf']&.any? { |item| item['readOnly'] }
  end

  def render_api_key(section, field)
    "`#{field}` | #{fetch_api_section(section)&.dig(field).inspect}"
  end

  protected

  def fetch_api_section(section_name)
    yaml = YAML.load(fetch_spec)
    section_array = section_name.split('/')
    section_array.map! { |i| i.match?(/\d+/) ? i.to_i : i }

    hash = yaml.to_h
    hash.dig(*section_array)
  end

  def fetch_spec
    uri = URI(SPEC_LOCATION)
    warn "[OpenAPI] Fetching spec from #{uri}"
    Net::HTTP.get_response(uri)&.body
  end
end
