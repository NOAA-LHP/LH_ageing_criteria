agebias_plot <- function(title, id, x=reader1, y=reader2){
  filename <- here::here("data", paste0(id, ".csv"))
  dat <- read.csv(filename, stringsAsFactors = FALSE)
  dat$x <- round(dat[[x]])
  dat$y <- round(dat[[y]])
  dat <- dat[complete.cases(y),] #only look at records that have a second age reader
  ab1 <- FSA::ageBias(x~y,data=dat)
  #summary(ab1,what="table",flip.table=TRUE) # this is messy and I dont use it but leaving here for you to check out
  summary(ab1,what="symmetry") #chi squared tests for significance (a significant test means that there are differences between the age readers)
  FSA::plotAB(ab1,show.n=TRUE)
  plot(ab1,show.CI=TRUE,show.range=FALSE,xHist=TRUE,yHist=TRUE)
}
