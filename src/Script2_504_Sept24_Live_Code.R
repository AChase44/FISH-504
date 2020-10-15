#Necessary packages

install.packages("sf")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("ggplot2")
install.packages("maps")
install.packages("rgbif")
install.packages("ggspatial")
install.packages("ggmap")
install.packages("rgdal")
install.packages("xtable")
install.packages("DT")


library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggplot2)
library(maps)
library(rgbif)
library(ggspatial)
library(ggmap)
library(rgdal)

#focusing on displaying spatial data (maps) mostly using ggplot

usa=st_as_sf(map('usa',plot=FALSE,fill=TRUE))

#will download the data without plotting it, and will fill in the map of the usa.

#will often be plotting a lot of maps together on the same plot. don't usually fill in the ggplot with the call, give the data to each infdividual geom.

ggplot() +
  geom_sf(data=usa,fill="lightblue")+
  theme_bw()

#wanna use the same theme in all code? you can use this function:

theme_set(theme_bw())

#using this early in the script will mean you don't have to keep saying "theme_bw()". 
#gbif is a site we can download data from about species locations and other things. packages rgbif makes this easy.

#species<-occ_search(scientificName ="Margaritifera falcata", country="us", limit=1000) didn't work, no data?
species<--occ_search(scientificName ="Oncorhynchus mykiss gairdnerii", country="us", limit=1000)

#we limit to 1000 because otherwise we will be here all day

species_1<-as.data.frame(species$data)

species_1 <-species_1[,c("scientificName","decimalLatitude","decimalLongitude")]
species_1<-species_1[complete.cases(species_1),] #removes any row with an na

#It plots in the order you write it.

ggplot()+
  geom_sf(data=usa,fill="white")+
  geom_polygon(data=states,aes(x=long,y=lat,fill=region,group=group), color="black", fill="white") + #Color =black will give us black boarders. group within this polygon is the state themselves, so we have to day this to prevent errors (?)
  geom_point(data=species_1,aes(x=decimalLongitude, y=decimalLattitude), color="darkred")+
  annotation_scale(width_hint=0.3)+
  annotation_north_arrow(which_north="true",
                         pad_x=unit(.2,"in"),pad_y=unit(.2,"in"),
                         style=north_arrow_fancy_orienteering())+
  annotate(geom="text",x=-127,y=36, label="Pacific \n Ocean",
           fontface="italic",color="darkblue",size=3)+
  labs(x="Longitude",y="Latitude")+
  guides(fill=FALSE) + #for the legend, do not include legend for the color fill of the states.
  coord_sf(xlim=c(-130,-60),ylim=c(25,50))

# Basemaps ----------------------------------------------------------------

base=get_map(location = c(-125,30, -110,50), maptype="terrain-background")

map1=ggmap(base)
map1+
  geom_point(data=species_1,aes(x=decimalLongitude,y=decimalLatitude),color="darkred")+
  labs(x="Longitude",y="Latitude")

range<-readOGR("insertyourfile here?") #uhhh

range_fort<-fortify(range)
shp<-spTransform(range,CRS("+proj=longlat+datum=WGS84"))
shp_fort<-fortify(shp)
map1+
  geom_path(data=shp_fort,aes(long,lat,group=group),colour="black")+
  geom_point(data=species_1,aes(x=decimalLongitude, y=decimalLatitude),color="darkred")+
  lab(x="Longitude",y="Latitude")

base=get_map(location=c(-118,43,-111,49),maptype="terrain-background")
map2=ggmap(base)

