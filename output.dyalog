:Namespace OutputCmds
⍝ user commands

    ⎕IO←1 ⋄ ⎕ML←1
    ⎕SE.Tatin.LoadDependencies⊂'[MyUCMDs]Output'
    ⎕SE.Output.Text.draw←⎕SE.Output.textdraw
    ⎕SE.Output.⎕EX'textdraw'

    :Section RENDER
    Html←⎕SE.Output.Html
    Plt←⎕SE.Output.Plotly
    Tbl←⎕SE.Output.Tabulator
    Txt←⎕SE.Output.Text
    :EndSection

    :Section UCMD
    ∇ r←List
      r←⎕NS¨2⍴⊂⍬
    ⍝ Name, group, short description and parsing rules
      r.Name←'Plt' 'Tbl'
      r.Group←⊂'Out'
      r[1].Desc←'Plot data'
      r[2].Desc←'Tabulate data'
      r.Parse←⊂''
    ∇

    ∇ r←Run(cmd input);parms;config;window;center;type;expr;out
      parms←(⎕NEW ⎕SE.Parser'-t[∊]0 1 -m[∊]0 1 -type∊plotly tabulator ns text -config= -window=').Parse input
      :If parms.config≡0 ⋄ config←⊢ ⋄ :Else ⋄ config←##.THIS⍎parms.config ⋄ :EndIf
      :If parms.window≡0 ⋄ window←⊢ ⋄ :Else ⋄ window←##.THIS⍎parms.window ⋄ :EndIf
      :If 3≠⎕NC'window' ⋄ :AndIf 1=≢window ⋄ window,←⌊0.5+window×16÷9 ⋄ :EndIf
      :If 0=80|⎕DR parms.t ⋄ parms.t←⍎parms.t ⋄ :EndIf
      center←window∘Txt.draw.center⍣(⊃3≠⎕NC'window')
      type←{parms.t:'text' ⋄ 0≡parms.type:⍵ ⋄ parms.type}
      expr←'^ +| +$'⎕R''⊢'(^\s*-[tm]\s+)*'⎕R''⍤('^\s*-\w+=(\S+|(''[^'']*?'')+)'⎕R'')⍣≡input
	  input←##.THIS⍎expr
      :Select cmd
      :Case 'Plt'
		  :If 0=80|⎕DR input ⋄ out←window Html&1 HTML expr Plt.head input ⋄ →0 ⋄ :EndIf
          :Select type'plotly'
          :Case 'text'
            r←center config{⍺←⊢ ⋄ parms.m:⍺ Txt.multiplot ⍵ ⋄ ⍺ Txt.plot ⍵}input
          :Case 'ns'
            r←config{⍺←⊢ ⋄ parms.m:⍺ Plt.multidata ⍵ ⋄ ⍺ Plt.data ⍵}input
          :Case 'plotly'
            out←config{⍺←⊢ ⋄ parms.m:⍺ Plt.multiplot ⍵ ⋄ ⍺ Plt.plot ⍵}input
			:If 3=⎕NC'window' ⋄ :AndIf (2=≢⍴input)∧0=80|⎕DR∊1↑input
				out←(96×≢⍉input)1024 Html&1 HTML expr Plt.head out
			:Else
	            out←window Html&1 HTML expr Plt.head out
			:EndIf
          :Else
            ⎕SIGNAL 6
          :EndSelect
      :Case 'Tbl'
		  :If 0=80|⎕DR input ⋄ out←window Html&HTML expr Tbl.head input ⋄ →0 ⋄ :EndIf
          :Select type'tabulator'
          :Case 'text'
            r←center config{⍺←⊢ ⋄ parms.m:⍺ Txt.multitable ⍵ ⋄ ⍺ Txt.table ⍵}input
          :Case 'ns'
            r←config{⍺←⊢ ⋄ parms.m:⍺ Tbl.config¨⍵ ⋄ ⍺ Tbl.config ⍵}input
          :Case 'tabulator'
            out←config{⍺←⊢ ⋄ parms.m:⍺ Tbl.multitable ⍵ ⋄ ⍺ Tbl.table ⍵}input
            out←window Html&HTML expr Tbl.head out
          :Else
            ⎕SIGNAL 6
          :EndSelect
      :EndSelect
    ∇ 

    ∇ r←level Help cmd
      :Select cmd
      :Case 'Plt'
          r←⊂List[1].Desc
          r,←⊂''
          r,←⊂']Plt <data> [-type={plotly|text|ns}] [-t] [-m] [-config=<configuration>]'
          :If 0=level ⋄ r,←⊂']Plt -??  ⍝ for details and examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'<data>        data to plot'
          r,←⊂''
          r,←⊂'-type=plotly  plot using plotly and HTMLRenderer or Ride (default)'
          r,←⊂'-type=text    plot using text'
          r,←⊂'-type=ns      return configuration and data namespaces'
          r,←⊂'-t            equivalent to -type=text'
          r,←⊂'-m            multiple plots from <data> array'
          r,←⊂'-config=      configuration namespace of plot size'
          r,←⊂'-window=      window size (height or height and width)'
          r,←⊂''
          r,←⊂'Examples:'
          r,←⊂'    ]Plt y                 ⍝ values as vertical bars'
          r,←⊂'    ]Plt ⊂y                ⍝ histogram'
          r,←⊂'    ]Plt y x               ⍝ data series'
          r,←⊂'    ]Plt labels x          ⍝ horizontal bars'
          r,←⊂'    ]Plt y labels          ⍝ vertical bars'
          :If 1=level ⋄ r,←⊂']Plt -???  ⍝ for more examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'    ]Plt ↓⍉↑y1 x1          ⍝ plot as points'
          r,←⊂'    ]Plt (y2 x2)(y1 x1)    ⍝ multiple data series'
          r,←⊂'    ]Plt -m (y2 x2)(y1 x1) ⍝ multiple plots'
          r,←⊂'    ]Plt labels x2 x1      ⍝ grouped horizontal bars'
          r,←⊂'    ]Plt labels(x2 x1)     ⍝ stacked horizontal bars'
          r,←⊂'    ]Plt y2 y1 labels      ⍝ grouped vertical bars'
          r,←⊂'    ]Plt (y2 y1)labels     ⍝ stacked vertical bars'
          r,←⊂'    ]Plt ⍪z                ⍝ 3D plot'
          r,←⊂'    ]Plt labels⍪⍪z         ⍝ spark-line by column'
          r,←⊂''
          r,←⊂'    ]Plt -t y x            ⍝ data series as text'
          r,←⊂'    ]Plt -t y labels       ⍝ vertical bars as text'
          r,←⊂''
          r,←⊂'    c←(xaxis:(title:''X''))  ⍝ config namespace'
          r,←⊂'    ]Plt -config=c y x     ⍝ data series with config'
          r,←⊂'    ]Plt -win=1024 y x     ⍝ with window size'
          r,←⊂''
          r,←⊂'    ]ld←Plt -type=ns y x   ⍝ get namespaces'
          r,←⊂'    layout data←ld         ⍝ layout and data'
          r,←⊂'    ]Plt -c=layout ∊data   ⍝ plot'
          r,←⊂''
          r,←⊂'See https://plotly.com/javascript/reference/ for more options'
      :Case 'Tbl'
          r←⊂List[2].Desc
          r,←⊂''
          r,←⊂']Tbl <data> [-type={tabulator|text|ns}] [-t] [-m] [-config=<configuration>]'
          :If 0=level ⋄ r,←⊂']Tbl -??  ⍝ for details and examples' ⋄ →0 ⋄ :EndIf
          r,←⊂'<data>           data to tabulate'
          r,←⊂''
          r,←⊂'-type=tabulator  tabulate using tabulator and HTMLRenderer or Ride'
          r,←⊂'-type=text       tabulate using text'
          r,←⊂'-type=ns         return namespace'
          r,←⊂'-t               equivalent to -type=text'
          r,←⊂'-m               multiple tables from <data> array'
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
          r,←⊂'See https://tabulator.info/docs/6.4/columns for more options'
      :EndSelect
    ∇
    :EndSection

    :Section UTILS
      HTML←{
          title head body←⍵ ⋄ ⍺←0
          title←'<title>',('<' '\&'⎕R'\&lt;' '\&amp;'⊢title),'</title>'
          head←'<head><meta charset="utf-8">',title,head,'</head>'
          style←'width:100vw;height:100vh;display:flex;align-items:center;margin:0'
          style{⍵:' style="',⍺,'"' ⋄ ''}←⍺
          body←'<body',style,' oncontextmenu="return false">',body,'</body>'
          '<!DOCTYPE html><html>',head,body,'</html>'
      }
    :EndSection

:EndNamespace
