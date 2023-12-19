const subNames = { 'ruby': 'Rails', 'php': 'PHP', 'javascript': 'Node.js',
  'c#': '.NET', 'xml': 'XML', 'jsonc': 'JSON', 'json': 'JSON', 'raw': 'Multipart' };

function groupedCodeBlocks() {
  let blocks = [];

  let codeList = document.querySelectorAll('pre code[class^=language-]:not([class="language-"])');
  let preList = Array.from(codeList).map(code => code.parentElement);
  // console.log(preList);

  let currentGroup = [];
  for (let i = 0; i < preList.length; i++) {
    let pre = preList[i];
    let nextPre = preList[i + 1];
    let nextElement = pre.nextElementSibling;

    currentGroup.push(pre);

    // if the next element is the next pre then add to the current group. else start a new one
    if (nextElement !== nextPre) {
      // console.log('next element is not next pre');
      blocks.push(currentGroup);
      currentGroup = [];
    }
  }

  // console.log(blocks);
  return blocks;
}

function addLanguageList(block) {
  // create a new ul containing a list of the lanaguages
  let ul = document.createElement('ul');
  let languages = []
  ul.className = 'languages';

  // for each block, create a new li and add it to the ul
  block.forEach(pre => {
    let li = addLanguageSelector(pre, block);
    if (languages.includes(pre.dataset.language)) {
      return;
    }
    languages.push(pre.dataset.language);

    ul.appendChild(li);
  });

  let div = document.createElement('div');
  div.className = 'language_list';
  div.appendChild(ul);

  // insert the ul before the first pre
  block[0].parentElement.insertBefore(div, block[0]);
}

// Add an li, that when clicked will show the selected language in this block
function addLanguageSelector(pre, block) {
  let li = document.createElement('li');

  let code = pre.querySelector('code');
  let language = code.className.replace('language-', '');

  pre.dataset.language = language;

  let subName = subNames[language] || language;
  let a = document.createElement('a');

  a.href = '#';
  a.innerHTML = subName;
  a.addEventListener('click', (e) => {
    e.preventDefault();

    // hide all the pre elements in this block
    block.forEach(pre => {
      if (pre.dataset.language === language) {
        pre.style.display = 'block';
      } else {
        pre.style.display = 'none';
      }
    });
  });

  li.appendChild(a);

  return li;
}

// On page load, find all pre elements that have a code item inside them
document.addEventListener('DOMContentLoaded', () => {
  let blocks = groupedCodeBlocks();
  blocks.forEach(block => {
    addLanguageList(block);

    let currentLanguage = block[0].dataset.language;
    block.forEach(pre => {
      if (pre.dataset.language === currentLanguage) {
        pre.style.display = 'block';
      } else {
        pre.style.display = 'none';
      }
    });
  });
});
