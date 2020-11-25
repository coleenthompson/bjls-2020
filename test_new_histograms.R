##############
##histograms##
##############
# do for each gene specifically
library(readr)

#list all species folders
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/Thesis Data Final/new_histograms", full.names = F, recursive = F)

#loop through speies folders
for (f in folders) {
  tryCatch({
	#change to species f directory
	dir<-(paste("/Users/coleenthompson/Desktop/Thesis Data Final/new_histograms/","Marmota caligata",sep=""))
	setwd(dir)
	#read in table with nucleotide data	
	sampletable<-paste("sampletable.txt")  
	sample_table<-read.table(sampletable)
    	
	#only use cytb data
	sampletable<-sample_table[sample_table$V1== "TRUE_cytb.fas",]
	piinside<-sampletable$V2
	piinside<-as.numeric(piinside)
	pioutside<-sampletable$V3
	pioutside<-as.numeric(pioutside)
	
	#get sample size
	samplesize <- paste("Marmota caligata","_samplesize.txt",sep="") 
	samplesize <- read_csv(samplesize)
	samplesize<- samplesize[samplesize$gene == "cytb.fas",]
	n_in<-samplesize$n_inside
	n_out<-samplesize$n_outside
	
		if (n_in > n_out) {
    		#create histogram based on data
  			pdf(paste("3Marmota caligata","new_histogram",sep=""))
  			hist(piinside, xlab= expression(paste(pi," ","inside")), main= expression (paste(italic("Marmota caligata"))))
  			#add line for  
  			abline(v=pioutside, col="red")
  			dev.off()
		} else {
			#create histogram based on data
  			pdf(paste("3Marmota caligata","new_histogram",sep=""))
  			hist(pioutside, xlab= expression(paste(pi," ","outside")), main= expression (paste(italic("Marmota caligata"))))
  			#add line for  
  			abline(v=piinside, col="red")
  			dev.off()
 		}
  }, error=function(e){ print("nohist")}  )
}
  


