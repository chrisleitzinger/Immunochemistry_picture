# duck.raster<-stack("MCF7 ICC hoechst.png")
# names(duck.raster)<-c('r','g','b')
# #Look at it
# plotRGB(duck.raster)


library(imager)

hoechst <- load.image("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst.png")

plot(hoechst)
dim(hoechst)
imager::Cc(hoechst)
spectrum(hoechst)

noise <- array(runif(5*5*5*3),c(5,5,5,3)) #5x5 pixels, 5 frames, 3 colours. All noise
noise <- as.cimg(hoechst)
noise[,,,1]

head(as.data.frame(hoechst))
df <- as.data.frame(hoechst)
# df_3 <- df %>% filter("cc" ==3)
bdf <- plyr::mutate(df,channel=factor(cc,labels=c('R','G','B', "no")))


# Split image
imsplit(hoechst,"x",4) %>% plot
imsplit(hoechst,"c",4) %>% plot
iiply(hoechst,"c",function(v) v/max(v))  %>% plot
imsplit(hoechst,"c") %>% liply(function(v) v/max(v)) %>% imappend("c") %>% plot
imsplit(hoechst,"c") %>% add %>% plot(main="Adding colour channels")

# select a part of an image by channel
a <- imsub(hoechst,cc==3)
plot(a)

# access a specific colour channel
a <- B(hoechst)
plot(a)

hoechst.cp <- hoechst
G(hoechst.cp) <- 0
R(hoechst.cp) <- 0
plot(hoechst.cp)

imrow(B(hoechst),10) %>% plot(main="Blue channel along 10th row",type="l")

# Individual pixels can be accessed using at and color.at:
at(hoechst,x=500,y=500,cc=1:3)

chan <- channels(hoechst)

names(chan) <- c("R","G","B")

plot(chan$B)
rgb(0,0,1) # give blue hex#

cscale <- function(r,g,b) rgb(g,b,r)
plot(hoechst,colourscale=cscale,rescale=FALSE)



