## library load------
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyverse)
library(fBasics)
library(pracma)
library(signal)
library(seewave)
library(e1071)
library(caret)
library(changepoint)

## Data Preprocessing------
# 경로 설정
setwd("/Users//seominji//Downloads//Physionet")
d<-getwd()
# 파일명 불러오기
flist<-dir(d,recursive = TRUE)

# 객체 생성
i<-0  
for(file in flist){
    print(file)
    i<-i+1
    print(i)
    a<- file.path(str_c(d,"/",file))
    temp<- read.csv(a)
    temp2<- strsplit(temp$signal[3:length(temp$signal)], ",") 
    IBP<- as.numeric(unlist(lapply(temp2,function(second){ # lapply 사용하여 2번째값 추출
      return(second[2])})))
    assign(f,IBP)
}

SRATE<-250
MINUTES_AHEAD<-1
Data_set<-list() # 샘플 생성후 저장할 공간

for (file in flist){
  
  IBP <-get(file) # 객체 내용 불러오기
  i <- 1
  IBP_data<-data.frame()
  
  while (i < length(IBP) - SRATE*(1+1+MINUTES_AHEAD)*60){
    segx <- IBP[i:(i+SRATE*1*60-1)]
    segy <- IBP[(i+SRATE*(1+MINUTES_AHEAD)*60):(i+SRATE*(1+1+MINUTES_AHEAD)*60-1)]
    segxd <- IBP[i:(i+SRATE*(1+MINUTES_AHEAD)*60-1)]
    if(is.na(mean(segx)) |
       is.na(mean(segy)) |
       max(segx)>200 | min(segx)<20 |
       max(segy)>200 | max(segy)<20 |
       max(segx) - min(segx) < 30 |
       max(segy) - min(segy) < 30|(min(segxd,na.rm=T) <= 50)){
    }
    else{ #나머지의 경우
      # segy <- ma(segy, 2*SRATE)
      event <- ifelse(min(segy,na.rm=T) <= 50, 1, 0)
      print(event)
      IBP_data<- rbind(IBP_data, cbind(t(segx), event))
    }
    
    i <- i+1*60*SRATE
  }
  Data_set[[file]]<- IBP_data
}

# 데이터 통합
All_data<- data.frame()

for(file in flist){
  df<- Data_set[[file]]
  All_data<- rbind(All_data,df)
}

# 데이터 저장
save(all_df, file = "/Users/seominji/Desktop/Unstruct_DA/All_data.RData")
