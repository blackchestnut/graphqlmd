# GraphGLmd

This gem will generate markdown by your GraphQL schema

## Usage
```
graphqlmd -u GRAPHQL_ENDPOINT_URL > schema.md
```

### Options
```

Usage: graphqlmd [options]
    -u, --url [URL]                  GraphQL schema url (default: http://localhost:3000/graphql)
    -t, --title [TITLE]              Title (default: GraphQL API)
        --note [NOTE]                Text after title (default: nil)
        --no-deprecated              Do not add deprecated objects, fields, args and etc.
        --no-links                   Do not add links with anchors to docs
        --no-table-of-contents       Do not add table of contents
        --client-mutation-id         Add clientMutationId to docs
        --scalar                     Add scalar objects to docs
        --vuepress                   Use vuepress additional styles
        --ignored-queries a,b,c      List of ignored and skipped Queries
        --ignored-mutations a,b,c    List of ignored and skipped Mutations
        --ignored-objects a,b,c      List of ignored and skipped Objects
    -v, --version                    Show version
    -h, --help                       Show this message
```

## Installation
```sh
gem install graphqlmd
```

## Sponsors

- [Agile Season](https://agileseason.com/?utm_source=graphqlmd)
- [CardWiz](https://cardwiz.com/?utm_source=graphqlmd)
