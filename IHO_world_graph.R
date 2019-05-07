# IHO_graph
library(dplyr)
library(ggplot2)
library(viridis)
library(cowplot)
library(magick) # needed for cowplot::draw_image

iho_table <- read.csv('WOA2-invert_marine_benthic_per_IHO.csv')

# order iho names based on spec_s200m and spec_200.100m

# calculate total number of species in each IHO area
iho_table_order <- iho_table %>%
  rowwise() %>%
  mutate(spec_all = sum(c(spec_s200m,
                          spec_200.1000m,
                          spec_l1000m),
                        na.rm = TRUE)
         )
# sort dataframe based on total number of species in IHO
iho_table_order <- iho_table_order %>%
  arrange(spec_all) # sort your dataframe

# reorder the name
iho_table_order$IHO.area <- factor(iho_table_order$IHO.area,
                                   unique(iho_table_order$IHO.area))

# plot data
p1 <- ggplot(data = iho_table_order) +
  geom_segment(aes(x = 0, xend = spec_all, y = IHO.area, yend = IHO.area), color="grey") +
  geom_point(aes(x = spec_all, y = IHO.area, col = 'c1')) +
  geom_point(aes(x = spec_s200m, y = IHO.area, col = 'c2')) +
  geom_point(aes(x = spec_200.1000m, y = IHO.area, col = 'c3')) +
  geom_point(aes(x = spec_l1000m, y = IHO.area, col = 'c4')) +
  labs(#title = 'Number of Marine Invertabrate Benthic species',
       x = 'number of species',
       y = 'IHO Sea Area') +
  scale_color_manual('Depth Category',
                     values = c("c1" = viridis(4)[1],
                                "c2" = viridis(4)[2],
                                "c3" = viridis(4)[3],
                                "c4" = viridis(4)[4]),
                      labels = c("c1" = 'All',
                                 "c2" = '< 200 m',
                                 "c3" = '200 - 1000 m',
                                 "c4" = '> 1000 m')
  ) +
  xlim(c(0, max(iho_table_order$spec_all))) +
  draw_label('IHO areas by MarineRegions.org; species information by WoRMS;
             species distributions by OBIS; bathymetry by EMODnet Bathymetry and GEBCO',
             x = 13000, y = 2, colour = 'black', size = 12)

legend <- get_legend(p1)

iho_world_graph <- ggdraw() +
  draw_plot(plot = p1 + theme(legend.position = "none"),
            x = 0,
            y = 0,
            width = 1,
            height = 1) +
  draw_image("species_depth_spec_s200m.png",
             x = 0.5,
             y = 0.5,
             width = 0.4,
             height = 0.4) +
  draw_image("species_depth_spec_200.1000m.png",
             x = 0.5,
             y = 0.3,
             width = 0.4,
             height = 0.4) +
  draw_image("species_depth_spec_l1000m.png",
             x = 0.5,
             y = 0.1,
             width = 0.4,
             height = 0.4) +
  draw_grob(legend,
            x = 0.65,
            y = -.05,
            width = 0.4,
            height = 0.4)

save_plot('IHO_world_graph.png',
          iho_world_graph,
          base_height = 15)
