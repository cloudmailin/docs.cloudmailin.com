module OpenapiHelpers
  SPEC_LOCATION = ENV.fetch("API_SPEC_URL", "https://api.cloudmailin.com/api/v0.1")

  def render_api_fields(section, *fields, include_readonly: true, except: [])
    all_fields = resolve_properties(section)
    fields = all_fields.keys if fields.empty?

    fields.filter_map do |field|
      content = all_fields[field]
      next if content.nil?
      next if except.include?(field)
      next if !include_readonly && read_only?(content)

      render_api_field_content(field, content)
    end.join("\n")
  end

  def render_api_field(section, field)
    content = resolve_properties(section)[field]
    render_api_field_content(field, content)
  rescue => e
    "Error finding #{field} in #{section}: #{e}"
  end

  private

  def render_api_field_content(field, content)
    description = (content['description'] || "").gsub("\n", " ")
    description = "**Response only.** #{description}" if read_only?(content)
    type = content['type'] || content['oneOf']&.map { |o|
      o['type'] == 'array' ? "array of #{o.dig('items', 'type') || 'items'}" : o['type']
    }&.join(' or ')

    "| `#{field}` | #{type} | #{description}"
  end

  def read_only?(content)
    content['readOnly'] || content['allOf']&.any? { |item| item['readOnly'] }
  end

  def render_api_example(section, except: [])
    yaml = YAML.load(fetch_spec)
    schema = fetch_section(section)
    props = collect_properties(schema)
    example = {}

    props.each do |k, v|
      next if v['readOnly']
      next if except.include?(k)

      if v['oneOf']
        ex = v['oneOf'].first['example']
        example[k] = ex if ex
      elsif v['items'] && v['items']['$ref']
        ref_schema = resolve_ref(yaml, v['items']['$ref'])
        item_example = build_example(ref_schema)
        example[k] = [item_example] unless item_example.empty?
      elsif !v['example'].nil?
        example[k] = v['example']
      end
    end

    JSON.pretty_generate(example)
  end

  def resolve_ref(yaml, ref)
    path = ref.delete_prefix('#/').split('/')
    yaml.dig(*path) || {}
  end

  def build_example(schema)
    props = schema['properties'] || {}
    example = {}
    props.each do |k, v|
      example[k] = v['example'] unless v['example'].nil?
    end
    example
  end

  def render_api_key(section, field)
    "`#{field}` | #{resolve_properties(section)&.dig(field).inspect}"
  end

  protected

  # Resolves a schema section to a flat hash of properties.
  # Handles $ref, allOf, and direct properties.
  def resolve_properties(section)
    schema = fetch_section(section)
    return schema if schema.nil?

    # If we're already looking at a properties hash (no type/allOf/$ref)
    return schema unless schema.is_a?(Hash) && (schema['allOf'] || schema['$ref'] || schema['properties'])

    collect_properties(schema)
  end

  def collect_properties(schema)
    return {} unless schema.is_a?(Hash)

    if schema['$ref']
      ref_path = schema['$ref'].delete_prefix('#/').split('/')
      resolved = fetch_section(ref_path.join('/'))
      return collect_properties(resolved)
    end

    props = {}
    if schema['allOf']
      schema['allOf'].each { |entry| props.merge!(collect_properties(entry)) }
    end
    props.merge!(schema['properties']) if schema['properties']
    props
  end

  def fetch_section(section_name)
    yaml = YAML.load(fetch_spec)
    section_array = section_name.split('/')
    section_array.map! { |i| i.match?(/\d+/) ? i.to_i : i }

    yaml.to_h.dig(*section_array)
  end

  def fetch_spec
    uri = URI(SPEC_LOCATION)
    warn "[OpenAPI] Fetching spec from #{uri}"
    Net::HTTP.get_response(uri)&.body
  end
end
