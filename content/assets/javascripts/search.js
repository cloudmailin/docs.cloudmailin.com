const appId = 'QV953NZ3R5';
const apiKey = 'c841f5cd01aee9b4c0dc20e431f49a44';
const indexName = 'cloudmailin_docs_<%= ENV["NANOC_ENV"] %>';
<% if ENV['NANOC_ENV'] != 'production' %>
console.log(`search.js loaded. Index: ${indexName}`);
<% end %>

// Initialize Algolia
const searchClient = algoliasearch(appId, apiKey);

const { autocomplete, getAlgoliaResults } = window['@algolia/autocomplete-js'];
autocomplete({
  container: '#searchbox',
  placeholder: 'Search',
  insights: true,
  getSources({ query }) {
    return [
      {
        sourceId: 'items',
        getItems() {
          return getAlgoliaResults({
            searchClient,
            queries: [
              {
                indexName: indexName,
                query,
                params: {
                  hitsPerPage: 10,
                },
              },
            ],
          });
        },
        templates: {
          noResults() {
            // console.log("noResults");
            return `No results for "${query}"`;
          },
          item({ item, components, html }) {
            return html`<a href="${item.objectID}" class="search-result">
              <h4>${item.title}</h4>
              <p>${components.Highlight({ hit: item, attribute: 'description' })}</p>
            </a>`;
          }
        },
      },
    ];
  },
});
