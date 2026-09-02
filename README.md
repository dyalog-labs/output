# Output

Plots and tables for Dyalog APL.

Generate interactive Javascript plots with [plotly](https://plotly.com/javascript/) and tables with [tabulator](https://tabulator.info/),
or generate simple text versions using [textdraw](https://github.com/dyalog-labs/textdraw).

Install with [Tatin](https://tatin.dev/):

    ]Tatin.InstallPackage [tatin-test]dyalog_labs-output [MyUCMDs]
    ]UReset

## `]Plt`

The `Plt` command shows data as a plot. Plots will be generated using the javascript library [plotly](https://plotly.com/javascript/) and displayed by the [HTMLRenderer](https://docs.dyalog.com/20.0/object-reference/objects/htmlrenderer/) or [RIDE](https://dyalog.github.io/ride/4.5/). Alternatively, simple text plots can be created using [textdraw](https://github.com/dyalog-labs/textdraw). By default, plotly will be used if available, but this can be changed using the options `-type` or `-t`.

A number of plot types can be directly generated from arrays. Further control is possible using namespaces for configuration. Namespaces will be passed to the rendering library as JSON (see [`⎕JSON`](https://docs.dyalog.com/20.0/language-reference-guide/system-functions/json/)), so [any option supported by plotly](https://plotly.com/javascript/reference/) is valid when plotly is used, while a subset is supported by textdraw (in addition to `x`, `y` and `name`, `width`, `height`, the graph `type`s `scatter` and `bar`, and the `stack` option for `barmode` and `group`).

    ]OUT.Plt

    Plot data

    ]Plt <data> [-type={plotly|text}] [-m] [-config=<configuration>]
    <data>        data to plot

    -type=plotly  plot using plotly and HTMLRenderer or Ride
    -type=text    plot using text
    -t            equivalent to -type=text

    -m            multiplot from <data> array

    -config=      configuration parameters
    -window=      window size

    Examples:
        ]Plt y                 ⍝ values as vertical bars
        ]Plt y x               ⍝ data series
        ]Plt labels x          ⍝ horizontal bars
        ]Plt y labels          ⍝ vertical bars
        ]Plt ↓⍉↑y1 x1          ⍝ plot as points
        ]Plt (y2 x2)(y1 x1)    ⍝ multiple data series
        ]Plt labels x2 x1      ⍝ grouped horizontal bars
        ]Plt labels(x2 x1)     ⍝ stacked horizontal bars
        ]Plt y2 y1 labels      ⍝ grouped vertical bars
        ]Plt (y2 y1)labels     ⍝ stacked vertical bars

        ]Plt -t y x            ⍝ data series as text
        ]Plt -t y labels       ⍝ vertical bars as text

        c←(xaxis:(title:'X'))  ⍝ config namespace
        ]Plt -config=c y x     ⍝ data series with config
        ]Plt -win=1024 y x     ⍝ with window size

    See https://plotly.com/javascript/reference/ for more options

## `]Tbl`

The `Tbl` command shows data as a table. Tables will be generated using the javascript library [Tabulator](https://tabulator.info/) and displayed by the [HTMLRenderer](https://docs.dyalog.com/20.0/object-reference/objects/htmlrenderer/) or [RIDE](https://dyalog.github.io/ride/4.5/). Alternatively, simple text tables can be created using [textdraw](https://github.com/dyalog-labs/textdraw). By default, tabulator will be used if available, but this can be changed using the options `-type` or `-t`.

Simple tables can be directly generated from arrays. Further control is possible using namespaces for configuration. Namespaces will be passed to the rendering library as JSON (see [`⎕JSON`](https://docs.dyalog.com/20.0/language-reference-guide/system-functions/json/)), so [any option supported by tabulator](https://tabulator.info/docs/6.4/columns) is valid when tabulator is used, while a subset is supported by textdraw (in addition to `field` and `title`, the `formatter` option can be set to `progress`).

    ]OUT.Tbl

    Tabulate data

    ]Tbl <data> [-type={tabulator|text}] [-config=<configuration>]
    <data>           data to tabulate

    -type=tabulator  tabulate using tabulator and HTMLRenderer or Ride
    -type=text       tabulate using text
    -t               equivalent to -type=text

    -config=         configuration for each column

    Examples:
        ]Tbl y1 y2 y3               ⍝ table with 3 columns
        ]Tbl (one:y1 ⋄ other:y2)    ⍝ 2 columns with titles

        td←()
        td.name←'Alice' 'Bob' 'Jonh' 'Sarah'
        td.age←24 32 10 29
        td.dob←'14/05/1982' '22/05/1982' '01/08/1980' '31/01/1999'
        columns←(title:'Name' ⋄ field:'name')
        columns,←(title:'Age' ⋄ field:'age' ⋄ hozAlign:'left' ⋄ formatter:'progress')
        columns,←(title:'Date of Birth' ⋄ field:'dob' ⋄ sorter:'date' ⋄ hozAlign:'center')
        ]tbl -c=columns td     ⍝ tabulator table
        ]tbl -t -c=columns td  ⍝ text table

    See https://tabulator.info/docs/6.4/columns for more options

## `⎕SE.Output`

This functionality is also available as a namespace installed under `⎕SE`.

#### `⎕SE.Output.Html`

This function is similar to the `]HTML` command. It will display the given HTML using the [HTMLRenderer](https://docs.dyalog.com/20.0/object-reference/objects/htmlrenderer/) or [RIDE](https://dyalog.github.io/ride/4.5/). However, in addition to a body and an optional title, it can also take additional HTML headers calling it as `title Html head body`.

#### `⎕SE.Output.Plotly`

Plotly interface namespace.

- `plot` returns a `<div>` element with a plot of the given data, following the same conventions of the `]Plt` command. The optional left argument specifies size or a config namespace with additional options

- `multi` similar to `plot` but each element of its right argument is interpreted as a different subplot

- `head` HTML header to download plotly script from CDN

- `configure` configuration namespace from either width or height and width

#### `⎕SE.Output.Tabulator`

Tabulator interface namespace.

- `table` returns a `<div>` element with a table of the given data, following the same conventions of the `]Tbl` command. The optional left argument specifies additional options.

- `head` HTML header to download tabulator script and css from CDN

- `sort` takes grading function (`⍋` or `⍒`) left operand and returns sorted data namespace, optionally by the given field(s)

- `flip` returns a vector of namespaces given a namespace with vector elements, or a namespace of vector elements given a vector of namespaces

#### `⎕SE.Output.Text`

Textdraw interface namespace.

- `plot` returns text plot, analogous to `Plotly.plot`. In addition to `x`, `y` and `name` fields, the given namespaces can contain fields `width`, `height`, the graph `type`s `scatter` and `bar`, and the `stack` option for `barmode` and `group`

- `table` returns text table, analogous to `Tabulator.table`. In addition to `field` and `title` fields, the given namespaces can contain a `formatter` field set to `progress`

- `draw` gives access to the [textdraw namespace](https://github.com/dyalog-labs/textdraw/blob/main/textdraw.apln)
