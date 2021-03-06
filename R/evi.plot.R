###evi.plot###################################################################################################
## Plots the EVI
evi.plot <- function(he,graph=c("base","ggplot2")) {
  options(scipen=10)
  base.graphics <- ifelse(isTRUE(pmatch(graph,c("base","ggplot2"))==2),FALSE,TRUE) 
  
  if(base.graphics){
    
    plot(he$k,he$evi,t="l",xlab="Willingness to pay",ylab="EVPI",
         main="Expected Value of Information")
    if(length(he$kstar)==1) {
      points(rep(he$kstar,3),c(-10000,he$evi[he$k==he$kstar]/2,he$evi[he$k==he$kstar]),t="l",lty=2,col="dark grey")
      points(c(-10000,he$kstar/2,he$kstar),rep(he$evi[he$k==he$kstar],3),t="l",lty=2,col="dark grey")
    }
    if(length(he$kstar)>1) {
      for (i in 1:length(he$kstar)) {
        points(rep(he$kstar[i],3),c(-10000,he$evi[he$k==he$kstar[i]]/2,he$evi[he$k==he$kstar[i]]),
               t="l",lty=2,col="dark grey")
        points(c(-10000,he$kstar[i]/2,he$kstar[i]),rep(he$evi[he$k==he$kstar[i]],3),t="l",lty=2,col="dark grey")
      }
    }
  } # base.graphics
  else{
    if(!isTRUE(requireNamespace("ggplot2",quietly=TRUE)&requireNamespace("grid",quietly=TRUE))){
      message("falling back to base graphics\n")
      evi.plot(he,graph="base"); return(invisible(NULL))
    }
    
    ### no visible binding note
    k <- NA_real_
    
    data.psa <- with(he,data.frame("k"=c(k),"evi"=c(evi)))
    
    evi <- ggplot2::ggplot(data.psa, ggplot2::aes(k,evi)) + ggplot2::geom_line() + ggplot2::theme_bw() +
      ggplot2::labs(title="Expected Value of Information",x="Willingness to pay",y="EVPI")
    
    if(length(he$kstar)!=0) {
      kstars=length(he$kstar)
      evi.at.kstar <- numeric(kstars)
      for(i in 1:kstars) {
        evi.at.kstar[i] <- with(he,evi[which.min(abs(k-kstar[i]))])
      }
      
      for(i in 1:kstars) {
        evi <- evi +
          ggplot2::annotate("segment",x=he$kstar[i],xend=he$kstar[i],y=evi.at.kstar[i],yend=-Inf,linetype=2,colour="grey50") +
          ggplot2::annotate("segment",x=he$kstar[i],xend=-Inf,y=evi.at.kstar[i],yend=evi.at.kstar[i],linetype=2,colour="grey50")
      }
    }
    
    evi <- evi +
      ggplot2::theme(text=ggplot2::element_text(size=11),legend.key.size=grid::unit(.66,"lines"),
                     legend.spacing=grid::unit(-1.25,"line"),panel.grid=ggplot2::element_blank(),
                     legend.key=ggplot2::element_blank(),
                     plot.title = ggplot2::element_text(lineheight=1.05, face="bold",size=14.3,hjust=0.5))
    return(evi)
  }
}
