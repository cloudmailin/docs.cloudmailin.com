module ItemHelpers
  def title(item = @item)
    item[:title] || filename(item)
  end

  def name(item = @item)
    item.attributes[:name] || title(item)
  end

  def identifier(item = @item)
    filename(item).downcase.gsub(/[^a-z0-9\_]+/i, '-')
  end

  def description(item = @item)
    item.attributes[:description]
  end

  def social_image(item = @item)
    path = item.attributes[:image] || 'default'
    return if path.nil?

    "social/#{path}.png"
  end

  def redirect_to(item = @item)
    link = item.attributes[:redirect_to]
    return if link.nil?

    candidate = find_item(link)
    raise ArgumentError, "Cannot find item #{link.inspect}" unless candidate

    url = ""
    url += @config[:base_url] unless ENV['NANOC_ENV'] == 'development'
    url += candidate.identifier
  end

  def full_url(item = @item)
    "#{@config[:base_url]}#{@item.identifier}"
  end

  def filename(item = @item)
    item.attributes[:filename].split('/').last.tr('_', " ").split('.').first
  end

  def disable_comments?(item = @item)
    item.attributes[:disable_comments]
  end
end
