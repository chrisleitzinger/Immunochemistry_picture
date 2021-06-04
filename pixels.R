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

# 2. Store left side
left_side <- split_img[1]
as.imlist(left_side) %>% imappend("x") %>% plot
left_side <- as.imlist(left_side) %>% imappend("x") 
imager::save.image(left_side, "left_side.jpeg")

###################

# 1. Remove the background / need magick object
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

# 2. Get coordinate
df <- as.data.frame(left_side)
df_3 <- df %>% filter(cc == 3) %>%
  filter(value > 0.15) # filter threshold

# df_3 %>% 
#   ggplot(aes(x=x, y=y, color = value)) +
#   geom_point(size = 0.3, aes(alpha = value)) +
#   scale_y_reverse() + 
#   theme_void() +
#   theme(legend.position = "none") +
#   scale_color_continuous(trans = "reverse")

df_3 %>% 
  ggplot(aes(x=x, y=y, color = value)) +
  geom_point(size = 1, aes(alpha = value)) +
  scale_y_reverse() + 
  theme_void() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "lightblue"))


dev.copy(png,'myplot.png')
dev.off()

# 3. Append
knitr::plot_crop("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot.png")
logo <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot.png")
logo1 <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/right_side.jpeg")
img <- c(logo, logo1)
img <- image_scale(img, "300x300")
image_append(image_scale(img, "x200"))

# knitr::plot_crop("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot1.png")
# logo2 <- image_read("/Users/colinccm/Documents/GitHub/perso repo/Immunochemistry_picture/myplot1.png")
# img <- c(logo2, logo1)
# img <- image_scale(img, "300x300")
# image_append(image_scale(img, "x200"))
