# Inline SVG icons — the four small glyphs the layout needs, replacing a
# render-blocking Font Awesome CDN stylesheet (the full library plus a
# webfont, for four icons). 1em sizing + currentColor keep the existing
# font-size/color CSS working unchanged.
module IconHelpers
  ICONS = {
    chevron_right: '<path d="M6 4l4 4-4 4"/>',
    chevron_down: '<path d="M4 6l4 4 4-4"/>',
    external_link: '<path d="M7 3.5H4.5a1 1 0 0 0-1 1v7a1 1 0 0 0 1 1h7a1 1 0 0 0 1-1V9"/><path d="M9.5 3h3.5v3.5"/><path d="M13 3 7.5 8.5"/>',
    bars_staggered: '<path d="M2 4h12"/><path d="M5 8h9"/><path d="M2 12h12"/>'
  }.freeze

  def icon(name, css_class = nil)
    classes = ['docs-icon', css_class].compact.join(' ')
    %(<svg class="#{classes}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" width="1em" height="1em" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">#{ICONS.fetch(name)}</svg>)
  end
end
