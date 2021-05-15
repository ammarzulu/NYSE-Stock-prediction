
df = read.csv("Downloads/Processed_NYSE.csv", header=TRUE)
df= na.omit(df)
df= df[-c(59)]
df=df[-c(1)]

library(caret)
set.seed(1)
DataPartition = createDataPartition(df$Close, p = 0.8, list = FALSE,times = 1)
df=as.data.frame(df)
trainingSet = df[DataPartition,]
testingSet = df[-DataPartition,]

#k-fold=10
ctrlSpec=trainControl(method = "cv",number=10, savePredictions = "all")

set.seed(1)

OLSmodel= train(Close~.,
                data=trainingSet,
                preProcess=c("center","scale"),
                method="lm",
                trControl=ctrlSpec)
print(OLSmodel)
summary(OLSmodel)



#predict outcome using model from training data on test data
OLSPrediction=predict(OLSmodel,newdata = testingSet)

OLSperf=data.frame(RMSE=RMSE(OLSPrediction,testingSet$Close),
                   Rsquared=R2(OLSPrediction,testingSet$Close))

####Specify and train our lasso regression model
#Create a vector of potential lambda value
lambda_vector= 10^seq(0, 10e4, length.out = 100000)

set.seed(1)

#Specify LASSO regression Model
LASSOmodel= train(Close~.,
                  data=trainingSet,
                  preProcess=c("center","scale"),
                  method="glmnet",
                  tuneGrid=expand.grid(alpha=1,lambda=lambda_vector),
                  trControl=ctrlSpec)

#optimal tuning parameter
LASSOmodel$bestTune

coef(LASSOmodel$finalModel, LASSOmodel$bestTune$lambda)
#Model Prediction
LASSOPrediction=predict(LASSOmodel,newdata = testingSet)

LASSOperf=data.frame(RMSE=RMSE(LASSOPrediction,testingSet$Close),
                     Rsquared=R2(LASSOPrediction,testingSet$Close))
set.seed(1)
#Specify ridge regression Model
ridgemodel= train(Close~.,
                  data=trainingSet,
                  preProcess=c("center","scale"),
                  method="glmnet",
                  tuneGrid=expand.grid(alpha=0,lambda=lambda_vector),
                  trControl=ctrlSpec)

#optimal tuning parameter
ridgemodel$bestTune

coef(ridgemodel$finalModel, ridgemodel$bestTune$lambda)
#Model Prediction
ridgePrediction=predict(ridgemodel,newdata = testingSet)

ridgeperf=data.frame(RMSE=RMSE(ridgePrediction,testingSet$Close),
                     Rsquared=R2(ridgePrediction,testingSet$Close))
modelList=list(LASSOmodel,ridgemodel)
Resamp=resamples(modelList)
summary(Resamp)

#We are going to compare all models predictive perfomance based on test data
comp=matrix(c(LASSOperf$RMSE, LASSOperf$Rsquared,
              ridgeperf$RMSE, ridgeperf$Rsquared), ncol = 2, byrow = TRUE)
colnames(comp)=c("RMSE","R-Squared")
rownames(comp)=c("LASSO","Ridge")
comp
