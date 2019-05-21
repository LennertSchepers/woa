# woa
This is the code and figures for a part of the chapter on benthic invertebrates of the 2nd World Ocean Assessment Report (WOA II).

This is a collaboration between [MarineRegions](http://www.marineregions.org), [the World Register of Marine Species](http://marinespecies.org) and [OBIS](https://obis.org/):

* the geodata (IHO Sea Areas) are provided by [MarineRegions](http://www.marineregions.org)
* species information is provided by [the World Register of Marine Species](http://marinespecies.org)
* species distribution records are provided by [OBIS](https://obis.org/)


Query by OBIS: see https://github.com/iobis/woa


WOA benthic invertebrate diversity maps by IHO area and depth ([script](https://github.com/LennertSchepers/woa/blob/master/IHO_world_maps.R)): 

* maps of number of species: species_depth_spec_... .png
* maps of number of records: records_depth_rec_... .png

Different depth categories:

* rec_s200m: < 200 m
* rec_200.1000m: 200 - 1000 m
* rec_l1000m: > 1000 m


A large graph which includes three world maps: IHO_world_graph.png, generated in [IHO_world_graph.r](https://github.com/LennertSchepers/woa/blob/master/IHO_world_graph.R)

![](https://github.com/LennertSchepers/woa/blob/master/IHO_world_graph.png)
This is a work in progress
