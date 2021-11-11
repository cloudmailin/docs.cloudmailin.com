/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS104: Avoid inline assignments
 * DS202: Simplify dynamic range loops
 * DS204: Change includes calls to have a more natural evaluation order
 * DS205: Consider reworking code to avoid use of IIFEs
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const subNames = { 'ruby': 'Rails', 'php': 'PHP', 'javascript': 'Node.js', 'c#': '.NET', 'xml': 'XML' };

Array.prototype.unique = function() {
  let key;
  let asc, end;
  const output = {};
  for (key = 0, end = this.length, asc = 0 <= end; asc ? key < end : key > end; asc ? key++ : key--) { output[this[key]] = this[key]; }
  return (() => {
    const result = [];
    for (key in output) {
      const value = output[key];
      result.push(value);
    }
    return result;
  })();
};

const groupCodeBlocks = function(codeBlocks, pattern){
  const groups = [];
  for (let item of Array.from(codeBlocks)) {
    if ($(item).prev(pattern).length > 0) {
      groups[groups.length - 1].push($(item));
    } else {
      groups.push([$(item)]);
    }
  }
  return groups;
};

const showLanguageForGroup = function(languageName, group){
  let needle;
  const included = (needle = languageName, Array.from(group.map(item => item.children('code').attr('class'))).includes(needle));
  const languageSelector = group[0].prev('.language_list');

  if (included) {
    for (let item of Array.from(group)) {
      if (item.children('code').attr('class') === languageName) {
        item.show();
      } else {
        item.hide();
      }
    }

    languageSelector.find("a[data-language-class]").removeClass('selected');
    return languageSelector.find(`a[data-language-class='${languageName}']`).addClass('selected');
  }
};

const drawLanguageSelector = function(languages, group, groups){
  const firstItem = group[0];
  const languageContainer = $("<div class='language_list'><ul class='languages'></ul></div>");
  for (var language of Array.from(languages)) {
    let languageName = (language.replace('language-', '').split(' ').map(word => word[0].toUpperCase() + word.slice(1))).join(' ');
    languageName = subNames[languageName.toLowerCase()] || languageName;
    const languageClass = language;
    const languageSelector = $(`<li><a href='javascript:void(0)' data-language-class='${languageClass}'>${languageName}</a></li>`);
    languageSelector.find('a').click(function(e){
      language = $(e.target).data('language-class');
      return Array.from(groups).map((showGroup) =>
        showLanguageForGroup(language, showGroup));
    });

    languageContainer.find('ul').append(languageSelector);
  }
  firstItem.before(languageContainer);
  return languageContainer;
};

jQuery(function($){
  const pattern = 'pre:has(code[class])';
  const groups = groupCodeBlocks($(pattern), pattern);

  return (() => {
    const result = [];
    for (let group of Array.from(groups)) {
      const languages = (group.map(codeBlock => $(codeBlock).children('code').attr('class'))).unique();
      const languageContainer = drawLanguageSelector(languages, group, groups);
      result.push(showLanguageForGroup(languages[0], group));
    }
    return result;
  })();
});
