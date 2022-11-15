((string_literal) @_literal
  (#match? @_literal "^\"\"\"")) @markdown


((prefixed_string_literal) @_literal
 (#match? @_literal "html")) @html
