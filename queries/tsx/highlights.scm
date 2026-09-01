; extends

(call_expression
  function: (identifier) @_func
  (#eq? @_func "__")
  arguments: (arguments
    (string
      (string_fragment) @string.special.translation))
  (#set! priority 120))

(call_expression
  function: (identifier) @_func
  (#eq? @_func "__")
  arguments: (arguments
    (template_string) @string.special.translation)
  (#set! priority 120))
