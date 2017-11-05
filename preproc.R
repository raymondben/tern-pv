x <- fread("ltern.326.3-vltm_vegetation_monitoring_1947-2013_p821t990.csv",data.table=FALSE) %>% as_tibble

x$taxon <- paste(x$genus,x$species)
x$date <- dmy(x$date)

xw <- x %>% filter(status=="L") %>% ## assuming that "L" means "live"
    mutate(present=1) %>% ## observations are presence-only
    dplyr::select(-genus,-species,-broad,-narrow,-status) %>% ## drop these columns
    complete(site,date,tr,point,taxon,fill=list(present=0)) %>% ## add absences for all missing taxa at each site/date/tr/point
    group_by(date,site,tr,taxon) %>% ## collapse to transect within site
    summarize(present=mean(present)) %>% ## average presence by taxon
    ungroup %>%
    ##filter(!grepl("litter",taxon) &
    ##       !grepl("Bare ground",taxon,ignore.case=TRUE) &
    ##       !grepl("Rock:",taxon,ignore.case=TRUE) &
    ##       !grepl("^Unknown",taxon,ignore.case=TRUE)) %>%
    spread(taxon,present,fill=0) ## spread to wide format, species in columns

x_sp <- xw %>% select(-date,-tr,-site)
idx <- rowSums(x_sp)>0
x_sp <- x_sp[idx,]
x_site <- xw[idx,c("date","tr","site")]

## otherwise max 6 species per site

D <- vegdist(x_sp,"bray")
mds <- metaMDS(D)

x_site <- x_site %>% mutate(year=year(date),
                            site=case_when(site=="PV_IN_G"~"IN",
                                           site=="PV_OUT_G"~"OUT"),
                            site_tr=paste0(site,"/T",sprintf("%02d",tr)),
                            site_tr_year=paste0(site,"/T",sprintf("%02d",tr),"/",year),
                            MDS1=mds$points[,1],
                            MDS2=mds$points[,2])

save(x_site,x_sp,D,mds,file="preprocessed.RData")

