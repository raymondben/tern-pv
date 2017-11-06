function(input,output,session) {

    app_version <- "0.0.1"
    output$app_version <- renderText(app_version)

    ggraf <- function(z,selection_type="none") renderggiraph(ggiraph(code=print(z),selection_type=selection_type))
    
    things <- reactiveValues(x_site_filtered=tibble(),idx=NULL)

    observe({
        things$idx <- x_site$site_tr %in% input$tr_select & (x_site$year>=input$year_slider[1] & x_site$year<=input$year_slider[2])
        things$x_site_filtered <- x_site[things$idx,]
    })
    observe({
        p <- ggplot(x_site,aes(MDS1,MDS2,group=site_tr,shape=site))+
            geom_point_interactive(aes(color=site,tooltip=site_tr_year),alpha=0.5,size=4)##,hover=c("date","site_tr"))
        if (sum(things$idx)>1)
            p <- p+geom_path_interactive(data=things$x_site_filtered,color="black",alpha=0.75,arrow=arrow(angle=20,type="open"))
        if (sum(things$idx)>0)
            p <- p+geom_point_interactive(data=things$x_site_filtered,aes(tooltip=site_tr_year),color="black",alpha=0.75,size=4)
        p <- p+theme_bw()
        
        output$mdsplot <- ggraf(p)
    })
    ##output$mdsplot <- renderPlot({
    ##    p <- ggplot(x_site,aes(MDS1,MDS2,group=site_tr,shape=site))+
    ##        geom_point(color="#808080",alpha=0.5,size=4)##,hover=c("date","site_tr"))
    ##    if (nrow(things$x_site_filtered)>0)
    ##        p <- p+geom_path(data=things$x_site_filtered,color="black",alpha=0.75)+
    ##            geom_point(data=things$x_site_filtered,alpha=0.75,size=4)
    ##    ##ly_text(pc1,pc2,text=paste("Coach",coach_id),font_size="9pt",font="Helvetica")
    ##    ##if (!is.null(input$rank_table_rows_selected))
    ##    ##    p <- p %>% ly_points(pc1,pc2,data=pdat[input$rank_table_rows_selected,],color="red")
    ##    p <- p+theme_bw()
    ##    p
    ##})
    observe({
        if (sum(things$idx)>0) {
            lx <- x_sp[things$idx,] %>% 
                gather("taxon","count") %>%
                mutate(count=count/sum(things$idx))
            p <- ggplot(lx,aes(taxon,count,fill=taxon))+
                geom_bar_interactive(stat="identity",aes(tooltip=taxon))+
                theme_bw()+guides(fill="none")+
                theme(axis.text.x = element_text(angle = 90, hjust = 1))
            output$composition_plot <- ggraf(p)
                ##geom_point_interactive(aes(tooltip=tooltip),size=4)+theme_bw()+geom_path(data=tmp,aes(Aggressiveness,se),color="dodgerblue",size=1)+labs(x="Serve aggressiveness",y="Serve error rate")+theme(text = element_text(size=20))+scale_colour_discrete(guide=FALSE))
        }
    })
}

