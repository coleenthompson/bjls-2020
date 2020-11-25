##################
#GET GENBANK IDS #
##################
library(seqinr)

#setwd("/Users/coleenthompson/Documents/Thesis Data Final/species")
folders <- list.dirs(path = "/Users/coleenthompson/Documents/Thesis Data Final/species", full.names = F, recursive = F)

#loop through species folders
for (f in folders) {
  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Documents/Thesis Data Final/species/",f,sep=""))
  setwd(dir)

  #continue runningn code despite errors
  tryCatch({
  #read in true and false files
  true_fasta<-read.fasta("TRUE_cytb.fas")
  false_fasta<-read.fasta("FALSE_cytb.fas")
  #get sequence names
  true_id<-getName(true_fasta)
  false_id<-getName(false_fasta)
  file1<-merge(data.frame(true_id, row.names=NULL), data.frame(false_id, row.names=NULL), by = 0, all = TRUE)[-1]
  #write table
  write.table(file1, file =paste(f,"GENBANK_IDS.txt",sep="_"),sep="\t", row.names=F,quote=F,append=FALSE)
  
  }, error=function(e){ print("dif number of ind or no cytb")} )
}
