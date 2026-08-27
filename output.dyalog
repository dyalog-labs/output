:Namespace OutputCmds
⍝ user commands

    ⎕IO←1 ⋄ ⎕ML←1
    ⎕SE.Tatin.LoadDependencies⊂'[MyUCMDs]/Output'
    ⎕SE.Output.Text.draw←⎕SE.Output.textdraw
    ⎕SE.Output.⎕EX'textdraw'

    :Section RENDER
    html←⎕SE.Output.Html
    hplotly←⎕SE.Output.Plotly.head
    plotly←⎕SE.Output.Plotly.plot
    plottxt←⎕SE.Output.Text.plot
    tabletxt←⎕SE.Output.Text.table
    htabulator←⎕SE.Output.Tabulator.head
    tabulator←⎕SE.Output.Tabulator.table
    :EndSection

    :Section UCMD
    ∇ r←List
      r←⎕NS¨3⍴⊂⍬
    ⍝ Name, group, short description and parsing rules
      r.Name←'Plt' 'Tbl'
      r.Group←⊂'Out'
      r[1].Desc←'Plot data'
      r[2].Desc←'Tabulate data'
      ⍝r.Parse←'1L -type∊plotly text  -config= ' '1L -type∊tabulator text  -columns= ' ⍝ ENTER NUMBER OF ARGS AND OPTIONALLY -modifiers HERE (for details, see https://docs.dyalog.com/20.0/User%20Commands%20User%20Guide.pdf#page=18 )
      r.Parse←⊂''
    ∇

    ∇ r←{type}Run(cmd input);parms;config;expr;parser
      parms←(⎕NEW ⎕SE.Parser'-t[∊]0 1 -type∊plotly tabulator text -config=').Parse input
      :If parms.config≡0 ⋄ config←⊢ ⋄ :Else ⋄ config←##.THIS⍎parms.config ⋄ :EndIf
      :If 0=⎕NC'type'
          :If 0=80|⎕DR parms.t ⋄ parms.t←⍎parms.t ⋄ :EndIf
          type←'text'⊣⍣parms.t⊢parms.type
      :EndIf
      expr←'^ +| +$'⎕R''⊢'^\s*-t\s+'⎕R''⊢'-\w+=(\S+|(''[^'']*'')+)'⎕R''⊢input
      :Select cmd
      :Case 'Plt'
          :Select type
          :Case 0
            :Trap 11
                'plotly'Run'Plt'input
            :Else
                'text'Run'Plt'input
            :EndTrap
          :Case 'text'
            r←config plottxt ##.THIS⍎expr
          :Case 'plotly'
            html&HTML expr hplotly(config plotly ##.THIS⍎expr)
          :Else
            ⎕SIGNAL 5
          :EndSelect
      :Case 'Tbl'
          :Select type
          :Case 0
            :Trap 11
                'tabulator'Run'Tbl'input
            :Else
                'text'Run'Tbl'input
            :EndTrap
          :Case 'text'
            r←config tabletxt ##.THIS⍎expr
          :Case 'tabulator'
            html&HTML expr htabulator(config tabulator ##.THIS⍎expr)
          :Else
            ⎕SIGNAL 5
          :EndSelect
      :EndSelect
    ∇ 

    ∇ r←level Help cmd
      :Select cmd
      :Case 'Plt'
          r←⊂List[2].Desc
          r,←⊂''
          r,←⊂']Plt <data> [-type={plotly|text}] [-config=<configuration>]'
          :If 0=level ⋄ r,←⊂']Plt -??  ⍝ for details and examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'<data>        data to plot'
          r,←⊂''
          r,←⊂'-type=plotly  plot using plotly and HTMLRenderer or Ride'
          r,←⊂'-type=text    plot using text'
          r,←⊂'-t            equivalent to -type=text'
          r,←⊂''
          r,←⊂'-config=      configuration parameters'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]Plt y                 ⍝ values as vertical bars'
          r,←⊂'    ]Plt y x               ⍝ data series'
          r,←⊂'    ]Plt labels x          ⍝ horizontal bars'
          r,←⊂'    ]Plt y labels          ⍝ vertical bars'
          :If 1=level ⋄ r,←⊂']Plt -???  ⍝ for more examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'    ]Plt (y2 x2)(y1 x1)    ⍝ multiple data series'
          r,←⊂'    ]Plt labels x2 x1      ⍝ grouped horizontal bars'
          r,←⊂'    ]Plt labels(x2 x1)     ⍝ stacked horizontal bars'
          r,←⊂'    ]Plt y2 y1 labels      ⍝ grouped vertical bars'
          r,←⊂'    ]Plt (y2 y1)labels     ⍝ stacked vertical bars'
          r,←⊂''
          r,←⊂'    ]Plt -t y x            ⍝ data series as text'
          r,←⊂'    ]Plt -t y labels       ⍝ vertical bars as text'
          r,←⊂''
          r,←⊂'    c←(xaxis:(title:''X''))  ⍝ config namespace'
          r,←⊂'    ]Plt -config=c y x     ⍝ data series with config'
          r,←⊂''
          r,←⊂'    See https://plotly.com/javascript/reference/ for more options'
      :Case 'Tbl'
          r←⊂List[3].Desc
          r,←⊂''
          r,←⊂']Tbl <data> [-type={tabulator|text}] [-config=<configuration>]'
          :If 0=level ⋄ r,←⊂']Tbl -??  ⍝ for details and examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'<data>           data to tabulate'
          r,←⊂''
          r,←⊂'-type=tabulator  tabulate using tabulator and HTMLRenderer or Ride'
          r,←⊂'-type=text       tabulate using text'
          r,←⊂'-t               equivalent to -type=text'
          r,←⊂''
          r,←⊂'-config=         configuration (or title) for each column'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]Tbl y1 y2 y3               ⍝ table with 3 columns'
          r,←⊂'    ]Tbl (one:y1 ⋄ other:y2)    ⍝ 2 columns with titles'
          :If 1=level ⋄ r,←⊂']Plt -???  ⍝ for more examples' ⋄ →0 ⋄ :EndIf
          r,←⊂''
          r,←⊂'    td←()'
          r,←⊂'    td.name←''Alice'' ''Bob'' ''Jonh'' ''Sarah'''
          r,←⊂'    td.age←24 32 10 29'
          r,←⊂'    td.dob←''14/05/1982'' ''22/05/1982'' ''01/08/1980'' ''31/01/1999'''
          r,←⊂'    columns←(title:''Name'' ⋄ field:''name'')'
          r,←⊂'    columns,←(title:''Age'' ⋄ field:''age'' ⋄ hozAlign:''left'' ⋄ formatter:''progress'')'
          r,←⊂'    columns,←(title:''Date of Birth'' ⋄ field:''dob'' ⋄ sorter:''date'' ⋄ hozAlign:''center'')'
          r,←⊂'    ]tbl -c=columns td     ⍝ tabulator table'
          r,←⊂'    ]tbl -t -c=columns td  ⍝ text table'
          r,←⊂'    ]tbl -t -c=columns.title td.(name age dob)  ⍝ column titles as config'
          r,←⊂''
          r,←⊂'    See https://tabulator.info/docs/6.4/columns for more options'
      :EndSelect
    ∇
    :EndSection

    :Section UTILS
      HTML←{
          title head body←⍵
          title←'<title>',('<' '\&'⎕R'\&lt;' '\&amp;'⊢title),'</title>'
          head←'<head><meta charset="utf-8">',title,head,'</head>'
          '<!DOCTYPE html><html>',head,'<body oncontextmenu="return false">',body,'</body></html>'
      }
    :EndSection

:EndNamespace
