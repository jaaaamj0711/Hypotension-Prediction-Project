## EDA
# 타겟 데이터 확인
table(All_data$event)
ggplot(data = All_data, aes(x = event)) + geom_bar()

# 저혈압과 정상 데이터 살펴보기
data_T<- subset(All_data,event==0)
data_T<- subset(data_T, select = -event)
data_F<- subset(All_data,event==1)
data_F<- subset(data_F, select = -event)

p_n <- par(mfcol=c(2,2))

plot(as.matrix(data_T)[10,],type="l")
plot(as.matrix(data_T)[15,],type="l")
plot(as.matrix(data_T)[20,],type="l")
plot(as.matrix(data_T)[25,],type="l")

plot(as.matrix(data_F)[10,],type="l")
plot(as.matrix(data_F)[15,],type="l")
plot(as.matrix(data_F)[20,],type="l")
plot(as.matrix(data_F)[25,],type="l")

## Statistical Features ------

# skewness 함수 정의
skewness <- function(x){
  (sum((x-mean(x))^3)/length(x))/((sum((x-mean(x))^2)/length(x)))^(3/2)
}

# rss 함수 정의
rss<-function(x) rms(x)*(length(x))*0.5

# range 함수 정의
range_ <- function(x){
  (diff(range(x)))
}

# Statistical Feature 리스트
sta_list<- c("mean", "min", "max" ,"sd" ,"skewness", "rms", "rss", "IQR", "kurtosis", "range_")

# event 제거
All_data2<-subset(All_data, select = -event)
for(sta in sta_list){
  All_data2[,str_c("v_", sta)]<- as.numeric(apply(All_data2, 1, sta))
}

sta_df<- All_data2[15001:15010]
All_data2<- All_data2[1:15000]


## Peak Features ------

# 피크기준값 설정을 위한 그래프
plot(as.numeric(All_data2[10,]), type="l")
plot(as.numeric(All_data2[100,]), type="l")
plot(as.numeric(All_data2[1000,]), type="l")
plot(as.numeric(All_data2[3000,]), type="l")

x <- findpeaks(as.numeric(All_data2[10,]),minpeakheight = 120)
plot(as.numeric(All_data2[10,]), type= "l")
points (x[, 2], x[, 1], pch = 20, col = "maroon")

x <- findpeaks(as.numeric(All_data2[100,]),minpeakheight = 120)
plot(as.numeric(All_data2[100,]), type= "l")
points (x[, 2], x[, 1], pch = 20, col = "maroon")

x <- findpeaks(as.numeric(All_data2[1000,]),minpeakheight = 120)
plot(as.numeric(All_data2[1000,]), type= "l")
points (x[, 2], x[, 1], pch = 20, col = "maroon")

peak_df<-data.frame()

for(i in 1:nrow(All_data2)){
  p<-findpeaks(as.numeric(All_data2[i,]), minpeakheight = 120)
  peak_df<- rbind(peak_df, data.frame(
    peak_n=ifelse(!is.null(p),dim(p)[1],0),  
    peak_interval=ifelse(!is.null(p),ifelse(dim(p)[1]>2,mean(diff(p[,2])),0),0),
    peak_interval_std=ifelse(!is.null(p),ifelse(dim(p)[1]>2,std(diff(p[,2])),0),0),
    peak_mean=ifelse(!is.null(p),mean(p[,1]),0),
    peak_max=ifelse(!is.null(p),max(p[,1]),0),
    peak_min=ifelse(!is.null(p),min(p[,1]),0),
    peak_std=ifelse(!is.null(p),std(p[,1]),0),
    peak_be_mean=ifelse(!is.null(p),mean(as.numeric(All_data2[i,][x[,2]-1])),0),
    peak_be_max=ifelse(!is.null(p),max(as.numeric(All_data2[i,][x[,2]-1])),0),
    peak_be_min=ifelse(!is.null(p),min(as.numeric(All_data2[i,][x[,2]-1])),0),
    peak_be_std=ifelse(!is.null(p),std(as.numeric(All_data2[i,][x[,2]-1])),0),
    peak_af_mean=ifelse(!is.null(p),mean(as.numeric(All_data2[i,][x[,2]+1])),0),
    peak_af_max=ifelse(!is.null(p),max(as.numeric(All_data2[i,][x[,2]+1])),0),
    peak_af_min=ifelse(!is.null(p),min(as.numeric(All_data2[i,][x[,2]+1])),0),
    peak_af_std=ifelse(!is.null(p),std(as.numeric(All_data2[i,][x[,2]+1])),0)))}
  

### ChangePoint Features ------

chpt_df <- data.frame()
for(i in 1:nrow(All_data2)){
   
  cp_mean<- cpt.mean(as.numeric(All_data2[i,]))
  cp_mean<- cpts(cp_mean)
  cp_var<- cpt.var(as.numeric(All_data2[i,]))
  cp_var<- cpts(cp_var)
  cp_m_var<- cpt.meanvar(as.numeric(All_data2[i,]))
  cp_m_var<- cpts(cp_m_var)
  
  chpt_df <- 
    rbind(chpt_df, data.frame(cp1 = length(cp_mean), cp2 = length(cp_var), cp3 = length(cp_m_var)))
}
