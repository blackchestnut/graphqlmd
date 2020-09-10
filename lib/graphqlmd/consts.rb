module Graphqlmd
  SCHEMA_QUERY = <<~QUERY
    fragment FullType on __Type {
      kind
      name
      description
      fields(includeDeprecated: true) {
        name
        description
        args {
          ...InputValue
        }
        type {
          ...TypeRef
        }
        isDeprecated
        deprecationReason
      }
      inputFields {
        ...InputValue
        description
        defaultValue
      }
      interfaces {
        ...TypeRef
      }
      enumValues(includeDeprecated: true) {
        name
        description
        isDeprecated
        deprecationReason
      }
      possibleTypes {
        ...TypeRef
      }
    }
    fragment InputValue on __InputValue {
      name
      type {
        ...TypeRef
      }
      defaultValue
    }
    fragment TypeRef on __Type {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                  ofType {
                    kind
                    name
                  }
                }
              }
            }
          }
        }
      }
    }

    {
      schema:__schema {
        queries:queryType {
          ...FullType
        }
        mutations:mutationType {
          ...FullType
        }
        types {
          ...FullType
        }
      }
    }
  QUERY

  LIST = 'LIST'
  SCALAR = 'SCALAR'
  NON_NULL = 'NON_NULL'
  CLIENT_MUTATION_ID = 'clientMutationId'
  IGNORED_OBJECT_NAMES = %w[
    Query
    Mutation
    SCALAR
    __DirectiveLocation
    __TypeKind
    __InputValue
    __EnumValue
    __Directive
    __Field
    __Type
    __Schema
  ]
end
