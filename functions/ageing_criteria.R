
# library(FSAdata) # test data for functions
library(FSA)  ## between reader precision FSA package
library(dplyr) # for mutate
library(mgcv) # for GAM() to look at bias
library(BlandAltmanLeh) # used for B-A plot of bias and imprecision
library(lubridate)
library(magrittr)
#library(migg)

###update - in read data
data<-read.csv("data/Age_PRZO_temp.csv")
str(data)

reader<- data %>% dplyr::select(PRZO_Kristen_age, PRZO_age_redone_1)
reader <- reader[complete.cases(reader$PRZO_age_redone_1),] 
reader <- reader[complete.cases(reader$PRZO_Kristen_age),] #only look at records that have a second age reader
reader$PRZO_Kristen_age<-round(reader$PRZO_Kristen_age)
reader$PRZO_age_redone_1<-round(reader$PRZO_age_redone_1)
ap.pz<-agePrecision(~PRZO_age_redone_1+PRZO_Kristen_age, data=reader)
summary(ap.pz, what="precision") #out put of IAPE and CV
summary(ap.pz, what="difference", digits = 1) #table of differences on age estimates

ab1 <- ageBias(PRZO_age_redone_1~PRZO_Kristen_age,data=reader)
summary(ab1,what="table",flip.table=TRUE)
summary(ab1,what="symmetry") #chi squared tests for significance (a significant test means that there are differences between the age readers)
plotAB(ab1,show.n=TRUE)
plot(ab1,show.CI=TRUE,show.range=FALSE,xHist=TRUE,yHist=TRUE)


#plot otolith weight vs age - this is not always a linear releationship and there can be data errors such as including weights of broken otoliths etc
#png(file = "przo_age_otowt", width=2000,height=1200,res=250)
plot(data$Otolith_Weight,data$PRZO_age_redone_1, bty="l", ylim=c(0,50),ylab="Estimated Age", xlab="Otolith Weight (g)")
abline(lm(data$PRZO_age_redone_1~data$Otolith_Weight), lwd=2) ##not a good fit, looks like inflection around age 4/5
#dev.off()

reader1_lm<-lm(data$PRZO_age_redone_1~data$Otolith_Weight)
summary(reader1_lm)

