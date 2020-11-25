##########################################
##put all wattersons theta in one folder##
##########################################
library(data.table)
# Put in your actual path where the text files are saved
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/water.test", full.names = F, recursive = F)

#loop through speies folders
wattersons <- data.frame(Genus=character(0), Species= character(0), hap=numeric(0), hap=numeric(0))

for (f in folders) {
    #continue running code despite errors
  	tryCatch({

  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/water.test/",f,sep=""))
#  print(dir)

  setwd(dir)
  # Create list of text files
  txt_files <- paste(dir,'/',f,"_Wattersons.txt",sep="")
  txt_files_ls<-read.table(txt_files)
  wattersons<- rbind(wattersons, txt_files_ls)
  
     }, error=function(e){ print("separatefilesdonotexist")} )
}
setwd("/Users/coleenthompson/Desktop/water.test")
names(wattersons)[1]<- paste("Genus")
names(wattersons)[2]<- paste("Species")
names(wattersons)[3]<- paste("watterson.inside")
names(wattersons)[4]<- paste("watterson.outside")

write.table(data.frame(wattersons),file=paste("wattersons_theta.txt"),sep="\t", 
    row.names=F, col.names=T,quote=F,append=FALSE)
