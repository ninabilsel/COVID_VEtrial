#COVID-19 VEtrial Practice Data Descriptive Analyses
#Author: Yijie Huang

#load libraries
library(tidyverse)
library(Hmisc)
library(gridExtra)

#brief view
dat <- read_csv("COVID_VEtrial_practicedata.csv")
summary(dat)

#turn age into categorical
dat$Agecat <- ifelse(dat$Age<=64,"18-64","65-80")

# split data and save plot titles
dat_grouped <- dat %>% group_by(Trt,MinorityInd,HighRiskInd,Agecat,Bserostatus)
dat_split<-group_split(dat_grouped)
dat_split_keys <- group_keys(dat_grouped)
dat_split_ID <- group_indices(dat_grouped)
dat_new <- cbind(dat,dat_split_ID)
titles <- colnames(dat_split_keys)

dat1 <- dat_split[[1]]

#give IPS proportion as weight
IPS_weight <- function(TwophasesampInd,EventInd){
  weight <- length(which(TwophasesampInd==1))/length(TwophasesampInd)
  IPS <- ifelse(EventInd==1,1,weight)
  IPS
}
dat_split_new <- NA
for(i in 1:length(dat_split)){
  dat_temp <- dat_split[[i]]
  dat_temp$IPS <- IPS_weight(dat_temp$TwophasesampInd,dat_temp$EventInd)
  dat_temp$WeightedBbind <- dat_temp$Bbind*dat_temp$IPS
  dat_temp$WeightedDay57bind <- dat_temp$Day57bind*dat_temp$IPS
  dat_split_new[[i]] <- dat_temp[,]
}
dat_11 <- dat_split_new[[1]]

# draw ecdf plots
par(mfrow=c(1,1))
# Bbind
for(i in 1:32){
  title_temp <- NA
  for(j in 1:5){
    title_temp <- paste(title_temp,titles[j],"=",dat_split_keys[i,j]," ",sep="")
  }
  dat_temp <- dat_split_new[[i]]
  jpeg(paste("Bbind_ecdf/Bbind_",i,".jpg",sep=""))
  Ecdf(dat_temp$WeightedBbind,main=title_temp,xlab="IPS weighted baseline binding")
  dev.off()
}

# day57Bind
for(i in 1:32){
  title_temp <- NA
  for(j in 1:5){
    title_temp <- paste(title_temp,titles[j],"=",dat_split_keys[i,j]," ",sep="")
  }
  dat_temp <- dat_split_new[[i]]
  jpeg(paste("Day57bind_ecdf/Day57bind_",i,".jpg",sep=""))
  Ecdf(dat_temp$WeightedDay57bind,main=title_temp,xlab="IPS weighted day57 binding")
  dev.off()
}

#draw violin plots
#Bbind
for(i in 1:32){
  title_temp <- NA
  for(j in 1:5){
    title_temp <- paste(title_temp,titles[j],"=",dat_split_keys[i,j]," ",sep="")
  }
  dat_temp <- dat_split_new[[i]]
  ggplot(data=dat_temp,aes(x=1,y=Bbind)) +
    geom_violin() + 
    geom_point() +
    labs(title=title_temp,x="Violin Plot",y="baseline binding")
  ggsave(paste("Bbind_violin/Bbind_violin_",i,".jpg",sep=""))
}

#Day57bind
for(i in 1:32){
  title_temp <- NA
  for(j in 1:5){
    title_temp <- paste(title_temp,titles[j],"=",dat_split_keys[i,j]," ",sep="")
  }
  dat_temp <- dat_split_new[[i]]
  ggplot(data=dat_temp,aes(x=1,y=Day57bind)) +
    geom_violin() + 
    geom_point() +
    labs(title=title_temp,x="Violin Plot",y="Day57 binding")
  ggsave(paste("Day57bind_violin/Day57bind_violin_",i,".jpg",sep=""))
}
