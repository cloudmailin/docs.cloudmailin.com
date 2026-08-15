module SectionHelpers
  # Plain CSS classes (defined in tailwind/input.css), not Tailwind utility
  # strings — sidebar links are bare <a> tags that Bootstrap also styles
  # (see the cascade-layers note at the top of tailwind/input.css), so a
  # real class beats it on specificity where a utility class would lose.
  SIDEBAR_LINK_CLASS = 'sidebar-link'.freeze
  SIDEBAR_LINK_ACTIVE_CLASS = 'sidebar-link sidebar-link--active'.freeze

  # True when `target` (a path string like '/foo/', or a compiled item)
  # points at the page currently being rendered — used to pill-highlight
  # the active link in layouts/sidebar.haml.
  def current_target?(target)
    target_path = target.respond_to?(:path) ? target.path.to_s : target.to_s
    target_path.split('#').first.to_s.chomp('/') == @item.path.to_s.chomp('/')
  end

  # CSS class for a sidebar link, switching to the pill-highlighted
  # "active" treatment when `target` is the current page. `extra` merges
  # in any additional classes (e.g. 'deprecated').
  def sidebar_link_class(target, extra = nil)
    base = current_target?(target) ? SIDEBAR_LINK_ACTIVE_CLASS : SIDEBAR_LINK_CLASS
    [base, extra].compact.join(' ')
  end

  # The two "Local Development and Testing" pages live under /receiving_email/
  # but belong to their own sidebar section — list them explicitly so the
  # resolver below can claim them before the broader /receiving_email/ prefix.
  LOCAL_DEV_PAGES = %w[
    /receiving_email/localhost_debugger/
    /receiving_email/test_driven_development/
  ].freeze

  # Which single sidebar section the current page belongs to. The sidebar
  # groups don't map 1:1 to URL prefixes — "Receiving Email" also lists
  # /features/* pages, and "Local Development" is a subset of /receiving_email/*
  # — so order matters here: the most specific rules must come first, and each
  # page resolves to exactly ONE section. Used by layouts/sidebar.haml to open
  # that section's <details> by default while the others stay collapsed.
  def active_sidebar_section
    path = @item.path.to_s
    return 'local_dev'         if LOCAL_DEV_PAGES.any? { |p| path.start_with?(p) }
    return 'outbound'          if path.start_with?('/outbound/')
    return 'guides'            if path.start_with?('/guides/')
    return 'http_post_formats' if path.start_with?('/http_post_formats/')
    return 'getting_started'   if path.start_with?('/getting_started/')
    return 'receiving_email'   if path.start_with?('/receiving_email/') || path.start_with?('/features/')

    'getting_started' # home page and anything else → open the first section
  end

  # The home page is the "what's in the docs?" page, so it opens every
  # sidebar section (as the old flat sidebar did); everywhere else only
  # the current section starts open.
  def sidebar_expand_all?
    @item.path.to_s.chomp('/').empty?
  end

  # True when the given sidebar section key should render its <details>
  # `open` — the active section, or all of them on the home page.
  def sidebar_section_open?(key)
    sidebar_expand_all? || active_sidebar_section == key
  end

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

    item = @items.detect { |i| i.identifier.match?(%r{#{section}/?\Z}) }
    raise "Cannot find #{section}" if item.nil?

    item
  end

  def link_to_item(identifier)
    item = find_item(identifier)
    "[#{title(item)}](#{item.path})"
  end

  def url_to_item(identifier)
    item = find_item(identifier)
    item.path
  end
end
