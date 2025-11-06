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
    htabulator←⎕Se.Output.Tabulator.head
    tabulator←⎕Se.Output.Tabulator.table
    :EndSection

    :Section UCMD
    ∇ r←List
      r←⎕NS¨3⍴⊂⍬
    ⍝ Name, group, short description and parsing rules
      r.Name←'HtmlR' 'Plt' 'Tbl'
      r.Group←⊂'Out'
      r[1].Desc←'Show HTML'
      r[2].Desc←'Plot data'
      r[3].Desc←'Tabulate data'
      ⍝r.Parse←'1L -type∊plotly text  -config= ' '1L -type∊tabulator text  -columns= ' ⍝ ENTER NUMBER OF ARGS AND OPTIONALLY -modifiers HERE (for details, see https://docs.dyalog.com/20.0/User%20Commands%20User%20Guide.pdf#page=18 )
      r.Parse←⊂''
    ∇ 

    ∇ r←{type}Run(cmd input);parms;config;expr;parser;raw
      :If 'HtmlR'≡cmd
          raw←'^\s*-r(aw?)?\s+|\s+-r(aw?)?\s*$'
          :If ≢raw ⎕S 3⊢input
              input←'^|''|$'⎕R'&'''⊢raw ⎕R''⊢input
          :EndIf
          html ##.THIS⍎input
      :EndIf
      parms←(⎕NEW ⎕SE.Parser'-t[∊]0 1 -type∊plotly text  -config=').Parse input
      :If parms.config≡0 ⋄ config←⊢ ⋄ :Else ⋄ config←##.THIS⍎parms.config ⋄ :EndIf
      :If 0=⎕NC'type'
          :If 0=80|⎕DR parms.t ⋄ parms.t←⍎parms.t ⋄ :EndIf
          type←'text'⊣⍣parms.t⊢parms.type
      :EndIf
      expr←'^ +| +$'⎕R''⊢'^\s*-t\s+'⎕R''⊢'-\w+=(\w+|(''[^'']*'')+)'⎕R''⊢input
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
          :EndSelect
      :EndSelect
    ∇ 

    ∇ r←level Help cmd
      :Select cmd
      :Case 'HtmlR'
          r←⊂List[1].Desc
          r,←⊂''
          r,←⊂']HtmlR [-raw] <data>'
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
          r,←⊂'-config=         configuration for each column'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]Tbl y1 y2 y3               ⍝ table with 3 columns'
          r,←⊂'    ]Tbl n←(one:y1 ⋄ other:y2)  ⍝ 2 columns with titles'
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
