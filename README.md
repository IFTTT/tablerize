kramdown-yaml-tablerize
=======================

Convert YAML to HTML tables, either standalone or as a Kramdown plugin.

Spec
----

YAML tables follow this format:

    --- table --- # start tag for embedding in Kramdown
    
    class: my-special-table another-class # optional
    
    cols: # column specifications and ordering
    - name: k # is used to identify the column below
      class: http-key # is applied to each cell (td) in the column
    - name: v
      class: http-value
    
    data: # data, by row
      - v: GET # v corresponds to cols[1].name above
        k: Method # k corresponds to cols[0].name above
      - k: Parameters # the order of the columns in data doesn't matter
        v:
          class: http-example-params
          
          cols: # nest tables by nesting another YAML dictionary, in the same format
          - name: k
          - name: v
          
          data:
            - k: '`client_id`' # backticks must be quoted, sorry!
              v: |
                IFTTT's client ID for your service as set in your channel configuration.
                
                wow!
            # <p>...</p> only gets inserted if there are multiple paragraphs
    
    --- /table --- # end tag for embedding in Kramdown


[example.yml](example.yml) is an example that can be converted with `ruby yaml_tablerize.rb example.yml`.

Credit
------

The structure of [rfc1459/kramdown-gist](https://github.com/rfc1459/kramdown-gist) was used as a guideline for making this library, but probably not to the extent to make this a derivative work.
