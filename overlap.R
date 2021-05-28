library(tidyverse)
library(imager)

hoechst <- load.image("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst.png")


# Set up a plot area with no plot
# plot(1:2, type='n', main="", xlab="x", ylab="y")
# 
# # Get the plot information so the image will fill the plot box, and draw it
# lim <- par()
# rasterImage(hoechst, 
#             xleft=1, xright=2, 
#             ybottom=1.3, ytop=1.7)
# grid()
# 
# #Add your plot !
# lines(
#   x=c(1, 1.2, 1.4, 1.6, 1.8, 2.0), 
#   y=c(1, 1.3, 1.7, 1.6, 1.7, 1.0), 
#   type="b", lwd=5, col="black")

df <- as.data.frame(hoechst) # give the pixel location and value for each channel
df_3 <- df %>% filter(cc == 3) %>% # filter blue
  filter(value > 0.5) # remove bg

p <- df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  geom_point(size = 0.3, aes(alpha = value)) +
  theme_classic()
p + annotation_raster(hoechst, ymin = 0,ymax= 500,xmin = 0,xmax = 500) + 
  geom_point()

library(ggplot2)
library(magick)
library(here) # For making the script run without a wd
library(magrittr) # For piping the logo

# Make a simple plot and save it
df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  background_image(hoechst)+
  geom_point(size = 0.3, aes(alpha = value)) +
  theme_classic()

# Call back the plot
# Now call back the plot
background <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/cells_plot.png")
# And bring in a logo
logo_raw <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst.png") 

frames <- lapply(logo_raw, function(frame) {
  image_composite(background, frame)
})


a <- image_join(frames)
plot(a)


