# make global maps with iho sea regions

# load libraries
library(sf)
library(mregions)
library(ggplot2)
library(tidyr)
library(cowplot)

## load iho sea areas
iho_mr <- mr_shp(key =	'MarineRegions:iho')

# load table
iho_table <- read.csv('WOA2-invert_marine_benthic_per_IHO.csv')

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


for (i in 1:3){
  columns <- c('spec_s200m','spec_200.1000m', 'spec_l1000m')
  titles <- c('< 200 m', '200 - 1000 m', '> 1000 m')
  p <- ggplot(iho) +
    geom_sf(aes(fill = get(columns[i])), size = 0.01) +
            coord_sf(crs=54030) +
            scale_fill_viridis_c('# species', option = "plasma", limits = c(0,12000)) +
            ggtitle(titles[i]) +
            theme(panel.grid.major = element_line(colour = 'transparent'))
  save_plot(paste0('species_depth_', columns[i],'.png'),
            p,
            base_aspect_ratio = 2)
}


#### PLOTTING NUMBER OF RECORDS per IHO ###
# max(c(iho$rec_s200m, iho$rec_200.1000m, iho$rec_l1000m), na.rm = TRUE)
#[1] 991541

for (i in 1:3){
  columns <- c('rec_s200m','rec_200.1000m', 'rec_l1000m')
  titles <- c('< 200 m', '200 - 1000 m', '> 1000 m')
  p <- ggplot(iho) +
    geom_sf(aes(fill = get(columns[i])), size = 0.01) +
    coord_sf(crs=54030) +
    scale_fill_viridis_c('# records', option = "viridis", limits = c(0,1E6)) +
    ggtitle(titles[i]) +
    theme(panel.grid.major = element_line(colour = 'transparent'))
  save_plot(paste0('records_depth_', columns[i],'.png'),
            p,
            base_aspect_ratio = 2)
}
