fluidPage(theme="spacelab.css",
          useShinyjs(),
          tags$head(
                   HTML("<script> function hide(name, address, display){var link = name + \"@\" + address; if(!display) { display = link; } document.write(\"<a href='mailto:\" + link + \"'>\" + display + \"</a>\"); }</script>"),
                   tags$link(href="untangl.css",rel="stylesheet"),
                   tags$style("table {font-size: small}"),
                   tags$style("#headerblock h1,#headerblock h2,#headerblock h3,#headerblock h4 {color:#000;}"), ## styling needed with background image in header block
                   tags$title("TERN data visualisation demo")
               ),
          fluidRow(id="headerblock",style="border-radius:4px;padding:10px;margin-bottom:10px;min-height:160px;color:white;background: #ffffff url(\"pretty_valley_2017_800.jpg\") 0 0/100% auto no-repeat;", ## background image in header block
              column(8,tags$h2("TERN data visualisation demo")),
              column(4,tags$div(style="float:right;padding:10px;",tags$a(href="http://untan.gl",tags$img(style="width:16em;max-width:100%",src="su_title.png"))))##,uiOutput(style="clear:right;","login"))
          ),
    tabsetPanel(
        tabPanel("Community",
                 fluidRow(style="margin:20px;",
                          column(4,selectInput("tr_select","Select transect(s):",multiple=TRUE,selectize=FALSE,size=10,choices=sort(unique(x_site$site_tr)))),
                          column(4,sliderInput("year_slider","Select year range:",min=min(x_site$year),max=max(x_site$year),value=range(x_site$year),sep="")),
                          column(4)),
                 fluidRow(
                     ##column(6,rbokehOutput("mdsplot"))
                     column(6,tags$h4("MDS plot"),tags$p(style="font-size:small;","STRESS:",sprintf("%.02f",mds$stress)),ggiraphOutput("mdsplot")),
                     column(6,tags$h4("Mean composition of selected points"),
                                 ggiraphOutput("composition_plot")))
                 ),
        tabPanel("Notes",
                 tags$div(style="margin:20px;",
                          tags$p(style="margin-top:2em","Metadata:",tags$a(href="http://www.ltern.org.au/knb/metacat/ltern.250/html","see this record.")),
                          tags$p("Preprocessing steps: TBD."),
                          tags$p("Code: see ",tags$a(href="https://github.com/raymondben/tern-pv","https://github.com/raymondben/tern-pv")),
                          tags$hr(),
                          tags$p(style="margin-top:2em;font-size:small;font-style:italic","Version: ",textOutput("app_version",inline=TRUE))
                          )
                 )
       ,id="tabs",selected="Community")
)
