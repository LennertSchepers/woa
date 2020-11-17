# IHO_graph
library(dplyr)
library(ggplot2)
library(viridis)
library(cowplot)
library(mregions)
library(magick) # needed for cowplot::draw_image
theme_set(theme_cowplot())
theme_update(plot.title = element_text(hjust = 0.5))

iho_table <- read.csv('WOA2-invert_marine_benthic_per_IHO.csv')

## load iho sea areas
iho_mr <- mr_shp(key =	'MarineRegions:iho')

# order iho names based on spec_s200m and spec_200.100m

# calculate total number of species in each IHO area
iho_table_order <- iho_table %>%
  rowwise() %>%
  mutate(spec_all = sum(c(spec_s200m,
                          spec_200.1000m,
                          spec_l1000m),
                        na.rm = TRUE)
         )

# change name of Japan Sea in iho_table_order (used for the labels of the graph)
# note that this is only in the iho_table_order, NOT in iho
levels(iho_table_order$IHO.area)[levels(iho_table_order$IHO.area) == 'Japan Sea'] <-
  'Waters between Japan and the Korean peninsula'

# sort dataframe based on total number of species in IHO
iho_table_order <- iho_table_order %>%
  arrange(spec_all) # sort your dataframe

# reorder the name
iho_table_order$IHO.area <- factor(iho_table_order$IHO.area,
                                   unique(iho_table_order$IHO.area))

# remove line Waters between Japan and the Korean peninsula'
iho_table_order <- iho_table_order[!(iho_table_order$IHO.area) == "Waters between Japan and the Korean peninsula",]


# plot data
p1 <- ggplot(data = iho_table_order) +
  geom_segment(aes(x = 0, xend = spec_all, y = IHO.area, yend = IHO.area), color="grey") +
  geom_point(aes(x = spec_all, y = IHO.area, col = 'c1')) +
  geom_point(aes(x = spec_s200m, y = IHO.area, col = 'c2')) +
  geom_point(aes(x = spec_200.1000m, y = IHO.area, col = 'c3')) +
  geom_point(aes(x = spec_l1000m, y = IHO.area, col = 'c4')) +
  labs(#title = 'Number of Marine Invertabrate Benthic species',
       x = 'number of species',
       y = '') +
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
  xlim(c(0, max(iho_table_order$spec_all)))
  # draw_label('IHO areas by MarineRegions.org; species information by WoRMS;
  #            species distributions by OBIS; bathymetry by EMODnet Bathymetry and GEBCO',
  #            x = 13000, y = 2, colour = 'black', size = 12)

legend <- get_legend(p1)



### draw maps
# add attributes to sf dataframe
iho <- merge(x = iho_mr,
             y = iho_table,
             by.x = 'name',
             by.y = 'IHO.area',
             all.x = TRUE)
# No 'Lincoln Sea'? -> only one record found (Ursus maritimus)

#### PLOTTING NUMBER OF SPECIES per IHO ####

#max(c(iho$spec_s200m, iho$spec_200.1000m, iho$spec_l1000m), na.rm = TRUE)
#[1] 11353


  columns <- c('spec_s200m','spec_200.1000m', 'spec_l1000m')
  titles <- c('< 200 m', '200 - 1000 m', '> 1000 m')
ps200 <- ggplot(iho) +
    geom_sf(aes(fill = spec_s200m), size = 0.01) +
    coord_sf(crs='ESRI:54030') +
    scale_fill_viridis_c('# species', option = "plasma", limits = c(0,12000)) +
    ggtitle('< 200 m') +
    theme(panel.grid.major = element_line(colour = 'transparent'))
  # save_plot(paste0('species_depth_', columns[i],'.pdf'),
  #           p,
  #           base_aspect_ratio = 2)

p200_1000 <- ggplot(iho) +
  geom_sf(aes(fill = spec_200.1000m), size = 0.01) +
  coord_sf(crs='ESRI:54030') +
  scale_fill_viridis_c('# species', option = "plasma", limits = c(0,12000)) +
  ggtitle('200 - 1000 m') +
  theme(panel.grid.major = element_line(colour = 'transparent'))
# save_plot(paste0('species_depth_', columns[i],'.pdf'),
#           p,
#           base_aspect_ratio = 2)

pl1000 <- ggplot(iho) +
  geom_sf(aes(fill = spec_l1000m), size = 0.01) +
  coord_sf(crs='ESRI:54030') +
  scale_fill_viridis_c('# species', option = "plasma", limits = c(0,12000)) +
  ggtitle('> 1000 m') +
  theme(panel.grid.major = element_line(colour = 'transparent'))
# save_plot(paste0('species_depth_', columns[i],'.pdf'),
#           p,
#           base_aspect_ratio = 2)



iho_world_graph <- ggdraw() +
  draw_plot(plot = p1 + theme(legend.position = "none"),
            x = 0,
            y = 0,
            width = 1,
            height = 1) +
  draw_plot(ps200,
             x = 0.5,
             y = 0.5,
             width = 0.4,
             height = 0.4) +
  draw_plot(p200_1000,
             x = 0.5,
             y = 0.3,
             width = 0.4,
             height = 0.4) +
  draw_plot(pl1000,
             x = 0.5,
             y = 0.1,
             width = 0.4,
             height = 0.4) +
  draw_grob(legend,
            x = 0.65,
            y = -.05,
            width = 0.4,
            height = 0.4)

save_plot('IHO_world_graph.pdf',
          iho_world_graph,
          base_height = 15,
          base_width = 16.5)



# # export to ppt
# library(officer)
# library(rvg)
#
# editable_graph <- dml(ggobj = iho_world_graph)
#
# read_pptx('template.pptx') %>%
#   add_slide() %>%
#   ph_with(value = editable_graph,
#           location = ph_location_fullsize()) %>%
#   print(target = 'IHO_world_graph.pptx')
