console.log("search.js loaded");

const appId = 'QV953NZ3R5';
const apiKey = 'c841f5cd01aee9b4c0dc20e431f49a44';
const indexName = 'cloudmailin_docs_development';

// Initialize Algolia
const searchClient = algoliasearch(appId, apiKey);

// const querySuggestionsPlugin = createQuerySuggestionsPlugin({
//   searchClient,
//   indexName: 'instant_search_demo_query_suggestions',
//   getSearchParams() {
//     return {
//       hitsPerPage: 10,
//     };
//   },
// });

const { autocomplete, getAlgoliaResults } = window['@algolia/autocomplete-js'];
autocomplete({
  container: '#searchbox',
  placeholder: 'Search',
  insights: true,
  // debug: true,
  getSources({ query }) {
    // console.log(query);
    return [
      {
        sourceId: 'items',
        getItems() {
          // console.log("getItems");
          return getAlgoliaResults({
            searchClient,
            queries: [
              {
                indexName: indexName,
                query,
                params: {
                  hitsPerPage: 5,
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
            // console.log(item);
            // console.log(components.Highlight);
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
