
#####################################################
####### Plot points (map) and get fasta files #######
#####################################################

##lOOP TO ASSIGN SEQUENCES TO IN OR OUT OF PARKS
library(phylotools)
library(rworldmap)
library(raster)
library(biomod2)
library(rgdal)
library(ggplot2)
library(rgeos)
library(ggmap)
library(RColorBrewer)
library(geosphere)

#list all species folders
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/test_vertdata", full.names = F, recursive = F)

##newmap <- getMap(resolution= "low")
data.shape<-readOGR("/Users/coleenthompson/Desktop/merged.shape/merged.shp")

#loop through species folders
for (f in folders) {
  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/test_vertdata/",f,sep=""))
  setwd(dir)
  
  #continue runningn code despite errors
  tryCatch({

  #read in gps file
  gps<-paste(f,".txt",sep="")
  gps_points<-read.table(gps, header=F, sep="\t")
  gps_points<-na.omit(gps_points)
  gps_points<-unique(gps_points)
  colnames(gps_points)<-c("species","decimallatitude","decimallongitude","ID")
###################################### plot species maps   
  #get coordinates for map boundaries
  low_lon<-min(gps_points$decimallongitude)-10
  high_lon<-max(gps_points$decimallongitude)+10
  low_lat<-min(gps_points$decimallatitude)-10
  high_lat<-max(gps_points$decimallatitude)+10
  
  #convert to spatialpoints class
  coordinates(gps_points) <- ~decimallongitude + decimallatitude
  
  #formatting gps coordinates sp they can be read in shape file
  proj4string(gps_points) <- proj4string(data.shape)
  
  #assigning points inside and outside parks
  inside.park <- !is.na(over(gps_points, as(data.shape, "SpatialPolygons")))
  
  #pdf(paste(f,"_map.pdf"))
  png(paste(f,"_map4.png"),width = 1000, height = 1000)
  newmap <- getMap(resolution= "low")
  plot(newmap, xlim = c(low_lon, high_lon), ylim = c(low_lat, high_lat), xlab="decimallongitude", ylab="decimallatitude", asp=1)
  plot(data.shape, border="red", add=TRUE)
  points(gps_points[inside.park, ], pch=20, col="green",cex=0.9)
  points(gps_points[!inside.park, ], pch=20, col="blue",cex=0.9)
  dev.off()
######################################### get points inside and outside   
  #MAKE SURE DATA ORDER STAYS THE SAME, OR FIGURE OUT HOW IT WORKED BEFORE WITH THE IDS
  #inside/outsidepark as data frame
  insidepark<- as.data.frame(inside.park)
  #create dataframe with geo points
  gps_points<- as.data.frame(gps_points)
  #combine dataframes
  id_df <-cbind(insidepark,gps_points)
  #only species id and T/F
  id_TF<-id_df[c(5,1)]
  write.table(file=paste(f,"_ID_TRUEFALSE.txt",sep=""),id_df,sep="\t", row.names=F,quote=F) 
############################### calc. max distance
  #read in true/false file with localities
  data <- paste(f,"_ID_TRUEFALSE.txt",sep="")
  tf_gps<-read.table(data, header=T, sep="\t")
  #separate GPS files into T/F
  true_gps<- tf_gps[tf_gps$inside.park=="TRUE",]
  false_gps<- tf_gps[tf_gps$inside.park=="FALSE",]
  #calculate distance between individuals 
  inside_dist<-distm(true_gps[,c('decimallongitude',"decimallatitude")], fun=distHaversine)
  outside_dist<-distm(false_gps[,c('decimallongitude',"decimallatitude")], fun=distHaversine)
  #add distances to table
  true_gps$distance<- apply(inside_dist,1,max)
  #false_gps$distance<- apply(outside_dist,1,max)
  false_gps$distance<- apply(outside_dist,1, min)
  #calculate maximum distance between points INSIDE the areas 
  max_dist<-max(true_gps$distance)
  #new table with only outside species less than the max distance between points
  within_maxdist <-false_gps[false_gps$distance <  max_dist,]
  #write table with max distance to be saved in species folder 
  write.table(data.frame(f,max_dist),file=paste(f,"max_distance.txt",sep="_"),sep="\t", row.names=F,quote=F,append=FALSE)
  #write table with max outside distances 
  write.table(data.frame(f,false_gps),file=paste(f,"outside_distance.txt",sep="_"),sep="\t", row.names=F,quote=F,append=FALSE)
  #table with only outside species less than the max distance between points
  write.table(data.frame(within_maxdist),file=paste(f,"outside_within_distance.txt",sep="_"),sep="\t", row.names=F,quote=F,append=FALSE)
############################## pull only outside files within inside max distance 
  outside_withindist <- paste(f,"_outside_within_distance.txt",sep="")
  owd <-read.table(outside_withindist, header=T, sep="\t")
  id_F<- owd[c(5,1)]
  id_T<-id_TF[id_TF$inside.park=="TRUE",]
  id_TF<-rbind(id_T,id_F)
############################### read in fasta files   
  #get list of aligned fasta files in this species folder
  fasta_files<-Sys.glob("*.fas")
 
  #loop through fasta files
  for (s in fasta_files){
    fasta<-read.fasta(s)
    
    #relabel to get rid of gene name
    IDnames <-  fasta$seq.name
    IDnamesnew <- substr(IDnames, 1,8)
    ref<-cbind(IDnames,IDnamesnew)
    #to rename fasta
    newname<-paste("renamed_",s,sep="")
    rename.fasta(infile = s, ref, outfile = newname)
    newfasta<-read.fasta(newname)
    
    #to align with t/f
    #saves as TRUE.fasta and FALSE.fasta
    split_dat(newfasta,id_TF)
    #rename files with gene name
    file.rename("FALSE.fasta", paste("FALSE_",s,sep=""))
    file.rename("TRUE.fasta", paste("TRUE_",s,sep=""))
  
  }
  }, error=function(e){ print("nogpsfiles")} )
}