duck.raster<-stack("MCF7 ICC hoechst.png")
names(duck.raster)<-c('r','g','b')
#Look at it
plotRGB(duck.raster)