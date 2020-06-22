module SectionHelpers
  def in_section?(section_name, item = @item)
    paths = item.identifier.to_s.split('/')
    paths.any? { |path| path == section_name }
  end

  def current_section
    paths = item.identifier.to_s.split('/')
    paths[-2] != '' ? paths[-2] : paths[-1]
  end

  def items_for_section(section)
    @items.select { |item| item.identifier =~ %r{^/#{section}} }
      .sort_by { |item| item.identifier.to_s }
  end
end
