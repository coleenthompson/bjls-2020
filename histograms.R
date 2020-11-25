##############
##histograms##
##############
# do for each gene specifically
library(readr)

#list all species folders
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/test_vertdata", full.names = F, recursive = F)

#loop through speies folders
for (f in folders) {
  tryCatch({
	#change to species f directory
	dir<-(paste("/Users/coleenthompson/Desktop/test_vertdata/",f,sep=""))
	setwd(dir)
	#read in table with nucleotide data	
	sampletable<-paste(f,"_sampletable.txt",sep="")  
	sample_table<-read.table(sampletable)
    	
	#only use cytb data
	sampletable<-sample_table[sample_table$V3== "TRUE_COI.fas",]
	piinside<-sampletable$V4
	piinside<-as.numeric(piinside)
	pioutside<-sampletable$V5
	pioutside<-as.numeric(pioutside)
	
	#get sample size
	samplesize <- paste(f,"_samplesize.txt",sep="") 
	samplesize <- read_csv(samplesize)
	samplesize<- samplesize[samplesize$gene == "COI.fas",]
	n_in<-samplesize$n_inside
	n_out<-samplesize$n_outside
	
		if (n_in > n_out) {
    		#create histogram based on data
  			pdf(paste(f,"COI_histogram",sep=""))
  			hist(piinside, xlab= "pi inside", main= paste(f," COI nucleotide diversity", sep=" "))
  			#add line for  
  			abline(v=pioutside, col="red")
  			dev.off()
		} else {
			#create histogram based on data
  			pdf(paste(f,"COI_histogram",sep=""))
  			hist(pioutside, xlab= "pi outside", main= paste(f," COI nucleotide diversity", sep=" "))
  			#add line for  
  			abline(v=piinside, col="red")
  			dev.off()
 		}
  }, error=function(e){ print("nohist")}  )
}
  


