####################
# regression dist ##
####################

library(readxl)
distance_data <- read_excel("/Users/coleenthompson/Desktop/distance_table.xlsx")


x=distance_data $Distance
y=distance_data $dif
#get log ofx
x<-as.numeric(x)
x<-log(x)
p<-plot(x, y, main="Maximum Distance inside", ylab = "Difference in pi", xlab = "Maximum Distance inside (km)", col= "black")
#calc r2
rsq <- function (x, y) cor(x, y) ^ 2
x<-as.numeric(x)
r2_body<-rsq(x,y)
#add line and r2
m<-lm(y ~ x)
r2 = format(summary(m)$r.squared, digits = 3)
abline(lm(y ~ x), col= "red")
mylabel = bquote(italic(R)^2 == .(format(r2, digits = 3)))
text(x = 9, y = 0.03, labels = mylabel)

#to get pvalue
summary(m)
