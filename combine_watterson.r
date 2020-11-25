#################################
##put all thetas in one folder##
#################################
library(data.table)
# Put in your actual path where the text files are saved
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/watterson_calc", full.names = F, recursive = F)

#loop through speies folders
watter <- data.frame(Genus=character(0), Species= character(0), watterin=numeric(0),watterout=numeric(0))

for (f in folders) {
    #continue running code despite errors
  	tryCatch({

  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/watterson_calc/",f,sep=""))
#  print(dir)

  setwd(dir)
  # Create list of text files
  txt_files <- paste(dir,'/',f,"_Wattersons.txt",sep="")
  txt_files_ls<-read.table(txt_files)
  watter <- rbind(watter, txt_files_ls)
  
     }, error=function(e){ print("separatefilesdonotexist")} )
}
setwd("/Users/coleenthompson/Desktop/watterson_calc")
names(watter)[1]<- paste("Genus")
names(watter)[2]<- paste("Species")
names(watter)[3]<- paste("theta.inside")
names(watter)[4]<- paste("theta.outside")

write.table(data.frame(watter),file=paste("watterson.txt"),sep="\t", 
    row.names=F, col.names=T,quote=F,append=FALSE)
