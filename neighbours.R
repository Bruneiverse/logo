library(tidyverse)
library(bruneimap)
library(spdep)

dat <- bruneimap::mkm_sf
dat_sp <- as(dat, "Spatial")
nb <- poly2nb(dat_sp, row.names = dat$mukim, queen = FALSE)
i <- which(attr(nb, "region.id") == "Mukim Kota Batu")
j <- which(attr(nb, "region.id") == "Mukim Bangar")
nb[[i]] <- c(nb[[i]], j)
nb[[j]] <- c(nb[[j]], i)
nb_sf <- nb2lines(nb, coords = sp::coordinates(dat_sp), as_sf = TRUE)
nb_sf <- st_set_crs(nb_sf, st_crs(dat))

ggplot() +
  geom_sf(data = nb_sf, col = "red", linewidth = 2) +
  geom_sf(data = st_centroid(dat), col = "red", pch = 19, size = 4) +
  theme_void()

ggsave("neighbours.png", width = 6, height = 6, dpi = 300)

