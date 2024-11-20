module OpenapiHelpers
  SPEC_LOCATION = "https://api.cloudmailin.com/api/v0.1s"
  PATH = './api.yml'

  def render_api_fields(section, *fields)
    fields = fetch_api_section(section).keys if fields.empty?

    fields.map do |field|
      render_api_field(section, field)
    end.join("\n")
  end

  def render_api_field(section, field)
    section = fetch_api_section(section)
    content = section[field]

    "| `#{field}` | #{content['type']} | #{html_escape(content['description']&.gsub("\n", " "))}"
  rescue => e
    "Error finding #{field} in #{section}: #{e}"
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
    return File.read(PATH) if File.exist?(PATH)

    uri = URI(SPEC_LOCATION)
    spec = Net::HTTP.get_response(uri)&.body
    File.write(PATH, spec)
    spec
  end
end
