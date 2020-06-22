module ItemHelpers
  def title(item = @item)
    item[:title] || filename
  end

  def name(item = @item)
    item.attributes[:name] || title(item)
  end

  def identifier(item = @item)
    filename(item).downcase.gsub(/[^a-z0-9\_]+/i, '-')
  end

  def description
    item.attributes[:description]
  end

  def filename(item  = @item)
    item.attributes[:filename].split('/').last.tr('_', " ").split('.').first
  end

  def disable_comments?(item = @item)
    item.attributes[:disable_comments]
  end
end
