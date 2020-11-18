# woa
This is the code and figures for a part of the chapter on benthic invertebrates of the 2nd World Ocean Assessment Report (WOA II).

This is a collaboration between [MarineRegions](http://www.marineregions.org), [the World Register of Marine Species](http://marinespecies.org) and [OBIS](https://obis.org/):

### Input data
* the geodata (IHO Sea Areas) are provided by [MarineRegions](http://www.marineregions.org)
* species information is provided by [the World Register of Marine Species](http://marinespecies.org)
* species distribution records are provided by [OBIS](https://obis.org/)


Query by OBIS: see https://github.com/iobis/woa

### Output maps
WOA benthic invertebrate diversity maps by IHO area and depth ([script](IHO_world_maps.R)): 

* maps of number of species: species_depth_spec_... .png
* maps of number of records: records_depth_rec_... .png

Different depth categories:

* rec_s200m: < 200 m
* rec_200.1000m: 200 - 1000 m
* rec_l1000m: > 1000 m


A large graph which includes three world maps: IHO_world_graph.png, generated in [IHO_world_graph.r](https://github.com/LennertSchepers/woa/blob/master/IHO_world_graph.R)

The pdf version provides a vector output of the graph and maps.

![](https://github.com/LennertSchepers/woa/blob/master/IHO_world_graph.png)

### Reproducibility

You can re-run the full analysis in an RStudio environment by clicking on the button below.

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/vlizBE/woa/master?urlpath=rstudio)

This will open an online RStudio environment (thank you Binder!). To run the analysis, open the 'index.Rmd' file.
In this file, you can run separate code chunks or click on the 'knit' button to recreate the html file
(this will take a while, and open a pop-up window).
You can also edit the code and run your own analysis.
