#################################
##put all pvalues in one folder##
#################################
library(data.table)
# Put in your actual path where the text files are saved
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/final_vertebrate_data", full.names = F, recursive = F)

#loop through speies folders
mypval <- data.frame(Genus=character(0),Species=character(0),p=numeric(0))

for (f in folders) {
    tryCatch({ 
  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/final_vertebrate_data/",f,sep=""))
#  print(dir)

  setwd(dir)
  # Create list of text files
  txt_files <- paste(dir,'/',f,"_ND4_pvalue_inside.txt",sep="")
  txt_files_ls<-read.table(txt_files)
  mypval <- rbind(mypval, txt_files_ls)
   }, error=function(e){ print("no pvalue inside")} )
}
setwd("/Users/coleenthompson/Desktop/final_vertebrate_data")
names(mypval)[1]<- paste("Genus")
names(mypval)[2]<- paste("Species")
names(mypval)[3]<- paste("p-value")

write.table(data.frame(mypval),file=paste("ND4_pvalues_inside.txt"),sep="\t", 
    row.names=F, col.names=T,quote=F,append=TRUE)
############################################################################
library(data.table)
# Put in your actual path where the text files are saved
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/final_vertebrate_data", full.names = F, recursive = F)

#loop through speies folders
mypval2 <- data.frame(Genus=character(0),Species=character(0),p=numeric(0))

for (f in folders) {
    tryCatch({ 
  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/final_vertebrate_data/",f,sep=""))
#  print(dir)

  setwd(dir)
  # Create list of text files
  txt_files <- paste(dir,'/',f,"_ND4_pvalue_outside.txt",sep="")
  print(txt_files)
  txt_files_ls<-read.table(txt_files)
  mypval2 <- rbind(mypval2, txt_files_ls)
    }, error=function(e){ print("no pvalue outside")} )
}
setwd("/Users/coleenthompson/Desktop/final_vertebrate_data")
names(mypval2)[1]<- paste("Genus")
names(mypval2)[2]<- paste("Species")
names(mypval2)[3]<- paste("p-value")

write.table(data.frame(mypval2),file=paste("ND4_pvalues_outside.txt"),sep="\t", 
    row.names=F, col.names=T,quote=F,append=TRUE)