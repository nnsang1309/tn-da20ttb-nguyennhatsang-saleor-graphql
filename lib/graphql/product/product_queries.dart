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

// ----------- getProductDetailById ---------------
const String getProductById = r'''
  query GetProductById($productId: ID!, $channel: String = "channel-vnd") {
    product(id: $productId, channel: $channel) {
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
      category {
        id
        name
        slug
        parent {
          id
          name
        }
      }
      productType {
        id
        name
      }
      media {
        url
      }
    }
  }
''';
