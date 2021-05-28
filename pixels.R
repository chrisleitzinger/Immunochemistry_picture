# duck.raster<-stack("MCF7 ICC hoechst.png")
# names(duck.raster)<-c('r','g','b')
# #Look at it
# plotRGB(duck.raster)

library(tidyverse)
library(imager)
library(ggpubr)

hoechst <- load.image("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst.png")

plot(hoechst)
dim(hoechst)
imager::Cc(hoechst)
# spectrum(hoechst) # Give number of channel

# noise <- array(runif(5*5*5*3),c(5,5,5,3)) #5x5 pixels, 5 frames, 3 colours. All noise
# noise <- as.cimg(hoechst)
# noise[,,,1]

head(as.data.frame(hoechst))
df <- as.data.frame(hoechst) # give the measurment for each channel
df_3 <- df %>% filter(cc == 3) %>% 
  filter(value > 0.5)

# r = as.raster(hoechst[,,1:3])
# r[hoechst[,,4] == 0] = "white"
# 
# plot(1:2,type="n")
# rasterImage(r,1,1,2,2)

df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  geom_point(size = 0.3, aes(alpha = value)) + 
  scale_y_reverse() +
  theme_classic()
# png('/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/cells_plot.png', 
#     width = 1025, height = 50, units = 'px', res = 150)
df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  background_image(hoechst)+
  geom_point(size = 0.3, aes(alpha = value)) +
  ylim(-100, 700) +
  scale_y_reverse() +
  theme_void()
# dev.off()

# cells_plot <- load.image("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/cells_plot.png")


# png('/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/test.png', width = 2, height = 2, units = 'in', res = 150)
# par(mai=c(0,0,0,0))
# plot.new()
# rasterImage(hoechst, 0, 0, 1, 1)
# rasterImage(cells_plot,   0, 0, 1, 1)
# dev.off()
# 
# par(new=T, mai=c(0,0,0,0))
# plot(hoechst)
# df_3 %>% 
#   ggplot(aes(x=x, y=y, color = value)) +
#   geom_point(size = 0.3, aes(alpha = value)) +
#   theme_classic()
# 
# plot(a)
# 
# bdf <- plyr::mutate(df,channel=factor(cc,labels=c('R','G','B', "no")))


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



