module SectionHelpers
  def in_section?(section, item: @item, include_self: false)
    # paths = item.identifier.to_s.split('/')
    # paths.any? { |path| path == section_name }
    in_section = item.identifier.match?(/#{section}/)
    is_section = item.identifier.match?(/\/?#{section}\/?\Z/)
    # puts "#{item.identifier} in #{section}: #{in_section} #{is_section}"
    in_section && (include_self || !is_section)
  end

  def current_section
    paths = item.identifier.to_s.split('/')
    paths[-2] != '' ? paths[-2] : paths[-1]
  end

  def items_for_section(section)
    items = @items.select { |item| in_section?(section, item: item) }
      .reject { |i| !i.attributes[:redirect_to].nil? }
      .reject { |i| i.path.nil? } # Ignore items that don't resolve to a path
      .sort_by { |i| name(i) }
    # .sort_by { |item| item.identifier.to_s }
    # puts items
    items
  end

  def find_item(section)
    return section if section.is_a?(Nanoc::Core::CompilationItemView)

    item = @items.detect { |i| i.identifier.match?(/#{section}\Z/) }
    raise "Cannot find #{section}" if item.nil?

    item
  end

  def link_to_item(identifier)
    item = find_item(identifier)
    "[#{title(item)}](#{item.path})"
  end
end
