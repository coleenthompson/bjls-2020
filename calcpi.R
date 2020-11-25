
#CALL CALC_PI.R
library(ape)

#to read in data table
library(readr)


#list all species folders
folders <- list.dirs(path = "/Users/coleenthompson/Desktop/testsample", full.names = F, recursive = F)

#loop through speies folders
for (f in folders) {
  
  #change to species f directory
  dir<-(paste("/Users/coleenthompson/Desktop/testsample/",f,sep=""))
  setwd(dir)
  
  #continue running code despite errors
  tryCatch({
    
    #delete temp files 
    delete.temp<- Sys.glob("*temp.fas") 
    file.remove(delete.temp)
    
    #get list of genes 
    gene_list_true<-Sys.glob("TRUE*.fas")
    gene_list_false<-Sys.glob("FALSE*.fas")

    #loop through fasta files
    for (g in 1:length(gene_list_true)) {
      print(gene_list_true[g])
#      print(gene_list_false[g])
      fasta_TRUE<-read.FASTA(gene_list_true[g])
      outname <- sub('TRUE', 'FALSE', gene_list_true[g])
#      print (outname)
      if (outname %in% gene_list_false){
        fasta_FALSE<-read.FASTA(outname)
        n_in<-length(fasta_TRUE)
        n_out<-length(fasta_FALSE)
        if (n_in > n_out) {
          n <-1000
          for(i in 1:n) {
            library(pegas)
            fs<-sample(fasta_TRUE,size= n_out, replace=TRUE)
            #calculate pi
            piinside<- nuc.div(fs, variance = FALSE, pairwise.deletion = FALSE)
            pioutside<- nuc.div(fasta_FALSE, variance = FALSE, pairwise.deletion = FALSE)
           #write appended results here
            write.table(data.frame(f,gene_list_true[g],piinside,pioutside),file=paste(f,"sampletable.txt",sep="_"),sep="\t", row.names=F, col.names=F,quote=F,append=TRUE)
            }
          } else {
          n <-1000
          library(pegas)
          for(i in 1:n) {
          fs<-sample(fasta_FALSE,size= n_in, replace=TRUE)
          pioutside<-nuc.div(fs, variance = FALSE, pairwise.deletion = FALSE)
          piinside<-nuc.div(fasta_TRUE, variance = FALSE, pairwise.deletion = FALSE)
          #write appended results here
          write.table(data.frame(f,gene_list_true[g],piinside,pioutside),file=paste(f,"sampletable.txt",sep="_"),sep="\t", row.names=F, col.names=F,quote=F,append=TRUE)
          }
           }
      }
      else{
        print('No gene outside')
      }
    }
  }, error=function(e){ print("separatefilesdonotexist")} )
}