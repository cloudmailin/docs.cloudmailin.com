subNames = { 'ruby': 'Rails', 'php': 'PHP', 'javascript': 'Node.js', 'c#': '.NET' }

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

groupCodeBlocks = (codeBlocks, pattern)->
  groups = []
  for item in codeBlocks
    if $(item).prev(pattern).length > 0
      groups[groups.length - 1].push($(item))
    else
      groups.push([$(item)])
  groups

showLanguageForGroup = (languageName, group)->
  included = languageName in group.map (item)-> item.children('code').attr('class')
  languageSelector = group[0].prev('.language_list')

  if included
    for item in group
      if item.children('code').attr('class') == languageName
        item.show()
      else
        item.hide()

    languageSelector.find("a[data-language-class]").removeClass('selected')
    languageSelector.find("a[data-language-class='#{languageName}']").addClass('selected')

drawLanguageSelector = (languages, group, groups)->
  firstItem = group[0]
  languageContainer = $("<div class='language_list'><ul class='languages'></ul></div>")
  for language in languages
    languageName = (language.replace('language-', '').split(' ').map (word) -> word[0].toUpperCase() + word[1..-1]).join(' ')
    languageName = subNames[languageName.toLowerCase()] || languageName
    languageClass = language
    languageSelector = $("<li><a href='javascript:void(0)' data-language-class='#{languageClass}'>#{languageName}</a></li>")
    languageSelector.find('a').click (e)->
      language = $(e.target).data('language-class')
      for showGroup in groups
        showLanguageForGroup(language, showGroup)

    languageContainer.find('ul').append(languageSelector)
  firstItem.before(languageContainer)
  languageContainer

jQuery ($)->
  pattern = 'pre:has(code[class])'
  groups = groupCodeBlocks($(pattern), pattern)

  for group in groups
    languages = (group.map (codeBlock) -> $(codeBlock).children('code').attr('class')).unique()
    languageContainer = drawLanguageSelector(languages, group, groups)
    showLanguageForGroup(languages[0], group)