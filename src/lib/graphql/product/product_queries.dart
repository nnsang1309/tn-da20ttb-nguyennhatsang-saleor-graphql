// QUERY PRODUCT

// ----------- getProductsList ---------------
const String getProductsList = r'''
query getProductsList {
  products(first: 20, channel: "channel-vnd") {
    edges {
      node {
        id
        name
        description
        pricing {
          priceRange {
            start {
              gross {
                amount
                currency
              }
            }
          }
        }
        thumbnail {
          url
        }
        category {
          id
          name
          parent {
            id
            name
            slug
          }
        }
        productType {
          id
          name
          slug
        }
        # variants dung để tạo checkout
        variants{
            id
            name
        }
      }
    }
  }
}
''';