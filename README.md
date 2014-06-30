YAML Tablerize
==============

Convert YAML to HTML tables.

Usage
-----

```shell
cd yaml-tablerize
make install
```

or (soon)

```shell
gem install yaml-tablerize
```

Then:

```shell
yaml-tablerize path/to/yaml-table.yaml [...]
```

Why?
----

Markdown is nice. It helps you write formatted documents in plain text in a way that is meaningful even without rendering. One thing that [the original Markdown specification](http://daringfireball.net/projects/markdown/syntax) doesn't support is tables. But many authors of Markdown documents want to write tables, so Markdown libraries have come up with various but similar ways of representing tables in Markdown.

Tables exist to help you line things up. But Markdown tables force you to either line things up yourself, or deal with the unreadable results. Here's some table Markdown from the [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet):

```
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
```

This is pretty readable, but unless you know exactly what the table looks like beforehand, lining everything up takes a lot of time! But that's okay, you don't _actually_ need to do that, you can just have this mess instead:

```
Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

Why is this less pretty? Because, while tables exist to organize data, the columns in the above might as well not exist.

Depending what Markdown library you're using, the examples above might not even render. Many flavors of Markdown tables exist, in varying degrees of leniency. Not only does this make writing tables even harder ("which Markdown library am I using and does it support table feature X?"), but it suggests that these other libraries are just making concessions with representing a table in this way. Tables contain data, something that should be computer-readable, and make them human-readable. Markdown tables, sadly, usually are neither.

Oh, and you can pretty much forget about nesting tables.

So what is this?
----------------

**Tablerize** solves these problems. In its purest form, it is a specification of a _human-readable representation of tables in plain text_. This project also includes a Ruby script to convert this YAML-based format into HTML tables. It can be run with:

```shell
yaml-tablerize path/to/yaml-table.yaml [...]
```

A complementary project, [kramdown-yaml-tablerize](https://github.com/IFTTT/kramdown-yaml-tablerize), allows embedding of YAML tables into kramdown Markdown documents.

Format
------

I'm searching for "statistics" on Google news, and I find [a Forbes article](http://www.forbes.com/sites/gregorymcneal/2014/06/27/nsa-releases-new-statistical-details-about-surveillance/) with a neat little table I want to type up. Let's try it now: [test/example-1.yml](test/example-1.yml)

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
              Based on probable cause (Title I and III of FISA, Sections 703 and 704 of FISA)
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

Here's what it looks like as HTML, using a common Markdown stylesheet ("GitHub" on Mou/Macdown):

![screen shot 2014-06-27 at 11 45 56 pm](https://cloud.githubusercontent.com/assets/1570168/3420046/94909652-fe90-11e3-9330-7eafc78ef17a.png)

Here's an example that illustrates most of the features of Tablerize [test/example-2.yml](test/example-2.yml):

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

![screen shot 2014-06-30 at 1 55 35 pm](https://cloud.githubusercontent.com/assets/1570168/3435774/15108594-0099-11e4-8175-d820206c471e.png)

Tips & Caveats
--------------

- Backticks `` ` `` and some other characters need to be quoted because YAML doesn't allow them. Other suspicious characters include commas `,`, ampersands `&`, and asterisks `*` and have been implicated in similar crimes. If readability isn't an issue and there's been a syntax error spree in your area, you can go ahead and quote every string just be safe.

- Don't use `class` as a column name, since it is used for classes. Unless you really want to. In which case you can. But it still will be used for classes.

- As a convenience, if a table has a class `my-table` and a column is named `column-1`, then all the cells in the column will have the class `my-table-column-1`. This only happens for the first class listed

Wish List
---------

- Support using representing two-column tables as key and value. YAML doesn't support ordered dictionaries, so this will be done by looking at the only key-value pair inside each dictionary in a list:

  ```yaml
  data:
  - wake up: done
  - brush teeth: done
  - eat breakfast: not done
  ```

- Allow HTML attributes to be placed anywhere classes currently can.

- Allow arbitrary HTML _and_ tables as siblings together inside cells.

- Allow empty cells to be created by simply not including keys or making keys with no value (represented as `null`/`nil`/`None`). Possibly add a "strict mode" setting that causes these to error instead.

- Support `thead` and `tfoot`. Perhaps add support `tbody`, which will be a synonym for `data`.

- Allow outputting to Markdown, for GitHub and other sites that don't allow HTML in Markdown.

Credit
------

**YAML Tablerize** was designed and written by [@szhu](https://github.com/szhu) at [@IFTTT](https://github.com/IFTTT).
