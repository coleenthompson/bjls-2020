################
# regressions ##
################

library(readxl)
trait_data <- read_excel("Box/CThompson/Grad. School/THESIS_data_final/trait_data.xlsx")
body<-trait_data[trait_data$`Adult Body Mass (g)` != 'n/a',]
home<-trait_data[trait_data$`Home Range Size (km2)` != 'n/a',]
lat<-trait_data[trait_data$`Max Latitude (dd)` != 'n/a',]

####body mass
x=body$`Adult Body Mass (g)`
y=body$dif
#get log ofx
x<-as.numeric(x)
x<-log(x)
p<-plot(x, y, main="Body Mass", ylab = "Difference in pi", xlab = "Adult Body Mass (g)", col= "black")
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

### home range size mius outliers (<3)
x=home$`Home Range Size (km2)`
y=home$dif

#get log ofx
x<-as.numeric(x)
x<-log(x)
plot(x, y, main="Home Range Size", ylab = "Difference in pi", xlab = "log Home Range Size (km2)")

#calc r2
rsq <- function (x, y) cor(x, y) ^ 2
x<-as.numeric(x)
r2_home<-rsq(x,y)
#add line and r2
m<-lm(y ~ x)
r2 = format(summary(m)$r.squared, digits = 3)
abline(lm(y ~ x), col= "red")
mylabel = bquote(italic(R)^2 == .(format(r2, digits = 3)))
text(x = 1, y = 0.03, labels = mylabel)

### max lat 
x=lat$`Max Latitude (dd)`
y=lat$dif
#get log ofx
x<-as.numeric(x)
x<-log(x)
plot(x, y, main="Max Latitude (dd)", ylab = "Difference in pi", xlab = "log Max Latitude (dd)")

#calc r2
rsq <- function (x, y) cor(x, y) ^ 2
x<-as.numeric(x)
r2_lat<-rsq(x,y)

#add line and r2
m<-lm(y ~ x)
r2 = format(summary(m)$r.squared, digits = 3)
abline(lm(y ~ x), col= "red")
mylabel = bquote(italic(R)^2 == .(format(r2, digits = 3)))
text(x = 4, y = 0.03, labels = mylabel)




