Tablerize
=========

```shell
gem install tablerize
```

Tablerize is a format for writing tables using YAML/JSON-compatible data
structures, and Ruby code to convert it to HTML.


## Usage

You can use it in Ruby...

```ruby
require 'tablerize'
puts Tablerize.load_file(path).to_html
# or
puts Tablerize.load(yaml_string).to_html
# or
puts Tablerize.make_table(object_from_yaml_or_json).to_html
```

...or from the command line

```shell
tablerize path/to/yaml-table.yml [...]
```


## Why?

Markdown is easy on the eyes. It helps you write formatted documents in plain
text in a way that is meaningful even without rendering. One thing that [the
original Markdown specification] doesn't support is tables. But many authors
writing in Markdown want to write tables, so Markdown libraries have come up
with various but similar ways of representing tables in Markdown.

[the original Markdown specification]: http://daringfireball.net/projects/markdown/syntax

Tables exist to help you line things up. But these Markdown tables force you to
either line things up yourself, or deal with the unreadable results. Here's some
a table from the [Markdown Cheatsheet]:

[Markdown Cheatsheet]: https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

```
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
```

This is pretty readable, but unless you know exactly what the table looks like
beforehand, lining everything up takes a lot of time! But that's okay, you don't
_actually_ need to do that, you can just have this mess instead:

```
Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

Why is this less pretty? Because, while tables exist to organize data, the data
looks pretty disorganized here. This goes against the concept of having raw
Markdown be readable!

Depending what Markdown library you're using, the examples above might not even
render. Many flavors of Markdown tables exist, and accept table syntax in
varying degrees of leniency. Not only does this make writing tables even harder
("which Markdown library am I using and does it support table feature X?"), but
it suggests that these these libraries are just making concessions with the
constraints of representing a table in this way. Tables take data, something
that should be computer-readable, and make them human-readable. Unrendered
Markdown tables, sadly, usually are neither.

Oh, and with this traditional syntax, you can pretty much forget about nesting
tables.


## So what's Tablerize?

**Tablerize** attempts to solve these problems. In its purest form, it is a
specification of a _human-readable representation of tables in YAML/JSON-
compatible data_. Since YAML is human-readable, so can Tablerize. This project
also includes a Ruby library and command-line tool to convert this YAML- based
format into HTML tables. It can be run with:

```shell
tablerize path/to/yaml-table.yml [...]
```

A complementary project, [kramdown-tablerize], allows embedding of YAML
tables into [kramdown] Markdown documents.

[kramdown]: http://kramdown.gettalong.org/
[kramdown-tablerize]: https://github.com/IFTTT/kramdown-tablerize


## Format

Here's example: Searching for "statistics" on Google news, I come across [a
Forbes article] with a neat little table I want to type up. Let's try it now
([examples/example-1.yml]):

[a Forbes article]: http://www.forbes.com/sites/gregorymcneal/2014/06/27/nsa-releases-new-statistical-details-about-surveillance/
[examples/example-1.yml]: examples/example-1.yml

```yaml
class: [statistics-table, nsa-surveillance-details]

cols:
- name: authority
- name: num_orders
- name: num_targets

data:
- class: table-header
  authority: Legal Authority
  num_orders: Annual Number of Orders
  num_targets: Estimated Number of Targets Affected
- authority: |
              __FISA Orders__  
              Based on probable cause
              (Title I and III of FISA, Sections 703 and 704 of FISA)
  num_orders: "1,167 orders"
  num_targets: "1,144"
- authority: |
              __Section 702__  
              of FISA
  num_orders: "1 order"
  num_targets: "89,138"
- authority: |
              __FISA Pen Register/Trap and Trace__  
              (Title IV of FISA)
  num_orders: "131 orders"
  num_targets: "319"
```

Here's what it looks like as HTML, using a common Markdown stylesheet ("GitHub"
on Mou/Macdown):

![screenshot](https://cloud.githubusercontent.com/assets/1570168/5449994/b09875c8-84b3-11e4-9a6a-b489a391d221.png)

Here's an example that illustrates some of the more advanced features of
Tablerize ([examples/example-2.yml]):

[examples/example-2.yml]: examples/example-2.yml

```yaml
class: [http-spec-exchange, another-class] # this line is optional

cols: # column specifications and ordering
- name: k # is used to identify the column below
  class: http-key # is applied to each cell (td) in the column
- name: v
  class: http-value

data: # data, by row
- v: GET # v corresponds to cols.1.name above
  k: Method # k corresponds to cols.0.name above
- k: Parameters # the order of the columns in data doesn't matter
  v:
    # nest tables by nesting another YAML dictionary, in the same format
    class: http-spec-params

    cols:
    - name: k
    - name: v

    data:
    - k: '`client_id`' # backticks must be quoted!
      v: |
        A client ID for your service as set in your configuration.
        
        a new line, wow! Let's see regular Markdown tables do that...
    # <p>...</p> gets inserted only if there are multiple paragraphs
    - k: '`type`'
      v: '`code`'
    - k: '`state`'
      v: An anti-forgery token provided by the API.
    - k: redirect_uri
      v: '`https://example.com/api/{{your_service}}/authorize`'
```

With the right CSS, it becomes this:

![screenshot](https://cloud.githubusercontent.com/assets/1570168/3435774/15108594-0099-11e4-8175-d820206c471e.png)


## Tips & Caveats

  - YAML tip: Backticks `` ` `` and some other characters need to be quoted
    because they have special meaing in YAML or are otherwise not allowed to be
    unquoted by YAML. Other suspicious characters include commas `,`, ampersands
    `&`, and asterisks `*` and have been implicated in similar crimes. If
    readability isn't an issue and there's been a syntax error spree in your
    area, you can go ahead and quote every string just be safe.

  - Don't use `class` as a column name, since it is used for classes. Unless you
    really want to. In which case you can. But it still will be used for
    classes.

  - Auto column classes: As a convenience, if a table has a class `my-table` and
    a column is named `column-1`, then all the cells in the column will have the
    class `my-table-column-1`. This only happens for the first table class
    listed. If you don't want this to happen, make the first table class `null`;
    it will be ignored and columns will not have automatically-generated
    classes.


## The Road Ahead

  - Support using representing two-column tables as key and value. YAML doesn't
    support ordered dictionaries, so this will be done by looking at the only
    key- value pair inside each dictionary in a list:

    ```yaml
    data:
    - wake up: done
    - brush teeth: done
    - eat breakfast: not done
    ```

  - Allow HTML attributes to be placed anywhere classes currently can.

  - Allow arbitrary HTML _and_ tables as siblings together inside cells. This
    will probably be implemented by recursively calling [kramdown-yaml-
    tablerize], if installed.

  - Allow empty cells to be created by simply not including keys or making keys
    with no value (represented as `null`/`nil`/`None`). Possibly add a "strict
    mode" setting that causes these to error instead.

  - Support `thead` and `tfoot`. Perhaps add support `tbody`, which will be a
    synonym for `data`.

  -  For simple tables, allow outputting to Markdown, for GitHub and other sites
     that don't allow HTML in Markdown.

  - [textmate/yaml.tmbundle], the YAML syntax highlighter used by TextMate,
    Sublime Text, and GitHub isn't perfect. Fix the plugin and use the
    examples in this README as test cases. _Update: GitHub now highlights the
    YAML in this file almost correctly, but [textmate/yaml.tmbundle] doesn't
    seem to be updated. GitHub's probably using something else to do syntax
    highlighting._

[textmate/yaml.tmbundle]: https://github.com/textmate/yaml.tmbundle

## Credit

**Tablerize** was originally designed and written by [@szhu] at [@IFTTT].

[rfc1459/kramdown-gist]: https://github.com/rfc1459/kramdown-gist
[@szhu]: https://github.com/szhu
[@IFTTT]: https://github.com/IFTTT
