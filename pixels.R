# Library
library(tidyverse)
library(imager)
library(ggpubr)
library(magick)

hoechst <- load.image("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst.png")

plot(hoechst)
dim(hoechst)
imager::Cc(hoechst)

# 1. Split image
imsplit(hoechst,"x", -700) %>% plot
split_img <- imsplit(hoechst,"x", -700)

# 2. Store right side
plot(split_img[2])
right_side <- split_img[2]
right_side <- as.imlist(right_side) %>% imappend("x") 
plot(right_side)
imager::save.image(right_side, "right_side.jpeg")

# 3. Store left side
left_side <- split_img[1]
as.imlist(left_side) %>% imappend("x") %>% plot
left_side <- as.imlist(left_side) %>% imappend("x") 
imager::save.image(left_side, "left_side.jpeg")

###################

# 4. Try to remove the background but didn't work as well
# hoechst1 <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/left_side.jpeg")
# plot(hoechst1)
# 
# hoechst1 <- image_fill(hoechst1, "white", point = "+50+50", fuzz = 20)
# # hoechst1 <- image_transparent(hoechst1, "black", fuzz = 20)
# plot(hoechst1)
# 
# magick2cimg(hoechst1) %>% plot
# df <- magick2cimg(hoechst1,alpha="flatten")
# df1 <- as.data.frame(df)
# # image_write(hoechst1, "/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/MCF7 ICC hoechst transparent.png")
# 
# df_3 <- df1 %>% filter(cc == 2) %>% # Using channel 2 because removing bg made cells too low on channel 3
#   filter(value < 0.5) # filter threshold
# 
# df_3 %>% 
#   ggplot(aes(x=x, y=y, color = value)) +
#   geom_point(size = 0.3, aes(alpha = value)) +
#   scale_y_reverse() + 
#   theme_void() +
#   theme(legend.position = "none")
# dev.copy(png,'myplot1.png')
# dev.off()

###################

# 2. Get coordinates
df <- as.data.frame(left_side)
df_3 <- df %>% filter(cc == 3) %>% # select channel
  filter(value > 0.15) # filter threshold

df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  scale_color_gradient(low="navyblue", high="blue")+
  geom_point(size = 1, aes(alpha = value)) +
  scale_y_reverse() + 
  theme_void() +
  theme(legend.position = "none")

dev.copy(png,'myplot.png')
dev.off()

gradient <- expand.grid(x=300:max(df_3$x), y=-min(df_3$y):max(df_3$y)) # dataframe for all combinations
ggplot() +
  geom_tile(data=gradient, aes(x, y, fill=x)) + 
  geom_point(data=df_3, aes(x=x, y=y, color = value, alpha = value),size = 0.3) +
  scale_fill_gradientn(colors = c("white", "white", "grey", "black")) +
  scale_y_reverse() + 
  theme_void() +
  theme(legend.position = "none")
dev.copy(png,'myplot.png')
dev.off()

# 3. Append
knitr::plot_crop("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot.png")
logo <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot.png")
logo1 <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/right_side.jpeg")
img <- c(logo, logo1)
img <- image_scale(img, "300x300")
image_append(image_scale(img, "x100"))
full_image <- image_append(image_scale(img, "x200"))

image_write(full_image, "full_image.png")
