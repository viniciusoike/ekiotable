library(ggplot2)
library(showtext)
library(hexSticker)
library(dplyr)

dat_square <- tibble(
  xmin = -0.25,
  xmax = 0.25,
  ymin = -2,
  ymax = 1
)

dat_ekio <- tibble(
  x = 0,
  y = 1.75,
  label = "EKIO"
)

dat_table <- tibble(
  x = 0,
  y = -0.5,
  label = "table"
)

xx <- c(dat_square$xmin, dat_ekio$x, dat_table$x)
min_x <- which.min(xx)

xmin <- xx[min_x]

ggplot() +
  geom_rect(
    data = dat_square,
    aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
    color = "blue",
    lwd = 4,
    fill = NA
  ) +
  geom_text(
    data = dat_ekio,
    aes(x, y, label = label),
    size = 22,
    family = "Lato"
  ) +
  coord_cartesian(
    xlim = c(xmin, NA),
    ylim = c(-3, 3)
  )

?hexSticker
?hexSticker::sticker()
