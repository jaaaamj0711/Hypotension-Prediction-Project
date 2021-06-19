## Modeling-----

# 데이터 통합----

all_df<- cbind(sta_df, peak_df, chpt_df)
all_df$event<- as.factor(All_data$event)

colSums(is.na(all_df))
all_df[is.na(all_df)]<-0

# train test split
library(caTools)
split <- sample.split(all_df$event, SplitRatio = 0.7)
train <- subset(all_df,split == TRUE)
test <- subset(all_df, split == FALSE)

table(train$event)
table(test$event)

# rpart -------
library(rpart)
rpart_model <- rpart(event ~ ., data = train, method = "class", minbucket = 20)
# train 데이터 예측
rpart_train_pred <- predict(rpart_model,type = "class")
rpart_conf_train<- confusionMatrix(train$event, rpart_train_pred)
# test 데이터 예측
rpart_test_pred <- predict(rpart_model,newdata = test, type = "class")
rpart_conf_test<- confusionMatrix(test$event, rpart_test_pred)

# randomForest
library(randomForest)
rf_model <- randomForest(event ~ ., data = train, method = "class", classwt = c(1,1))
# train 데이터 예측
rf_train_pred <- predict(rf_model,type = "class")
rf_conf_train<- confusionMatrix(train$event, rf_train_pred)
# test 데이터 예측
rf_test_pred <- predict(rf_model,newdata = test, type = "class")
rf_conf_test<- confusionMatrix(table(test$event, rf_test_pred))

# naiveBayes
naive_model <- naiveBayes(event~., train, laplace = 1)
# train 데이터 예측
naive_train_pred <- predict(naive_model, train)
naive_conf_train<- confusionMatrix(naive_train_pred, train$event)
# test 데이터 예측
naive_test_pred <- predict(naive_model, test)
naive_conf_test<- confusionMatrix(naive_test_pred, test$event)

# plot_confusion_matrix 함수 정의
plot_confusion_matrix <- function(cfm) {
  
  layout(matrix(c(1,1,2)))
  par(mar=c(2,2,2,2))
  plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
  title('CONFUSION MATRIX', cex.main=2)
  
  # create matrix 
  rect(150, 430, 240, 370, col='#3498DB')
  text(195, 435, '0', cex=1.2)
  rect(250, 430, 340, 370, col='#EC7063')
  text(295, 435, '1', cex=1.2)
  text(125, 370, 'Predicted', cex=1.3, srt=90, font=2)
  text(245, 450, 'Actual', cex=1.3, font=2)
  rect(150, 305, 240, 365, col='#EC7063')
  rect(250, 305, 340, 365, col='#3498DB')
  text(140, 400, '0', cex=1.2, srt=90)
  text(140, 335, '1', cex=1.2, srt=90)
  
  res <- as.numeric(cfm$table)
  text(195, 400, res[1], cex=1.6, font=2, col='white')
  text(195, 335, res[2], cex=1.6, font=2, col='white')
  text(295, 400, res[3], cex=1.6, font=2, col='white')
  text(295, 335, res[4], cex=1.6, font=2, col='white')
  
  plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = "DETAILS", xaxt='n', yaxt='n')
  text(10, 85, names(cfm$byClass[1]), cex=1.2, font=2)
  text(10, 70, round(as.numeric(cfm$byClass[1]), 3), cex=1.2)
  text(30, 85, names(cfm$byClass[2]), cex=1.2, font=2)
  text(30, 70, round(as.numeric(cfm$byClass[2]), 3), cex=1.2)
  text(50, 85, names(cfm$overall[1]), cex=1.5, font=2)
  text(50, 70, round(as.numeric(cfm$overall[1]), 3), cex=1.4)
  
  text(70, 85, names(cfm$byClass[6]), cex=1.2, font=2)
  text(70, 70, round(as.numeric(cfm$byClass[6]), 3), cex=1.2)
  text(90, 85, names(cfm$byClass[7]), cex=1.2, font=2)
  text(90, 70, round(as.numeric(cfm$byClass[7]), 3), cex=1.2)
  
  # add information 
  text(30, 35, "PPV", cex=1.5, font=2)
  text(30, 20, round(as.numeric(cfm$byClass[5]), 3), cex=1.4)
  text(50, 35, names(cfm$byClass[11]), cex=1.5, font=2)
  text(50, 20, round(as.numeric(cfm$byClass[11]), 3), cex=1.4)
  text(70, 35, "NPV", cex=1.5, font=2)
  text(70, 20, round(as.numeric(cfm$byClass[4]), 3), cex=1.4)
 
}  

plot_confusion_matrix(naive_conf_train)
plot_confusion_matrix(naive_conf_test)

plot_confusion_matrix(rpart_conf_train)
plot_confusion_matrix(rpart_conf_test)

plot_confusion_matrix(rf_conf_train)
plot_confusion_matrix(rf_conf_test)
