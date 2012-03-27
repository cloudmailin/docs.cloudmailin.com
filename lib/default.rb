def items_by_section
  sections = {}
  @items.each do |item|
    paths = item.identifier.split('/')
    if paths[-2] != ''
      if sections[paths[-2]].is_a?(Array)
        sections[paths[-2]] << item
      else
        sections[paths[-2]] = [item]
      end
    end
  end
  puts sections.inspect
  sections.delete('stylesheets')
  sections
end

def items_for_section(section)
  @items.select{|item| item.identifier =~ /^\/#{section}/}
end