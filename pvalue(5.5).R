##########################
#### pvalue from hist ####
##########################
#do for each gene individually 
library(readr)
#get list of files in folder
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/final_vertebrate_data", full.names = F, recursive = F)

#loop through species folders
for (f in folders) {
 tryCatch({
	#change to species f directory
	dir<-(paste("/Users/coleenthompson/Desktop/final_vertebrate_data/",f,sep=""))
	setwd(dir)
	#read in table with nucleotide data	
	sampletable<-paste(f,"_sampletable.txt",sep="")  
	sample_table<-read.table(sampletable)
    	
	#only use cytb data
	sampletable<-sample_table[sample_table$V3== "TRUE_ND4.fas",]
	piinside<-sampletable$V4
	piinside<-as.numeric(piinside)
	pioutside<-sampletable$V5
	pioutside<-as.numeric(pioutside)
	
	#get sample size
	samplesize <- paste(f,"_samplesize.txt",sep="") 
	samplesize <- read_csv(samplesize)
	samplesize<- samplesize[samplesize$gene == "ND4.fas",]
	n_in<-samplesize$n_inside
	n_out<-samplesize$n_outside
	
		if (n_in > n_out) {
    		#calc pvalue
  			pvalue<-sum(pioutside>=piinside)/1000
    		#write appended results here
    		write.table(data.frame(f,pvalue),file=paste(f,"ND4_pvalue_outside.txt",sep="_"),sep="\t", 
                row.names=F, col.names=F,quote=F,append=FALSE)
		} else {
			#calc pvalue
  			pvalue<-sum(piinside>=pioutside)/1000
    		#write appended results here
    		write.table(data.frame(f,pvalue),file=paste(f,"ND4_pvalue_inside.txt",sep="_"),sep="\t", 
                row.names=F, col.names=F,quote=F,append=FALSE)
 		}              
  }, error=function(e){ print("separatefilesdonotexist")} )
}



