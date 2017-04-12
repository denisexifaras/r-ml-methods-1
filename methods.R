

library(randomForest) #rf
library(neuralnet) #nn 
library(MASS) 
library(rpart) #decision tree
library(e1071) #svm

data = read.csv("http://s3-eu-west-1.amazonaws.com/decoded-translators/kaggle_loans_mod.csv",head=T)

# the data is already re-scaled
# maxs = apply(data, 2, max) 
# mins = apply(data, 2, min)

# scaled = as.data.frame(scale(data, center = mins, scale = maxs - mins))
scaled = data
index = sample(1:nrow(data),round(0.75*nrow(data)))

train_ = scaled[index,]
test_ = scaled[-index,]
attach(train_)



################################################################
# generalised linear model
################################################################

# a linear model assumes that the response has a normal distribution
# hist(loss) will make a histogram for loss

output.lm = glm(log(loss)~., data=train_,na.action=T) # log of x is log(x) in R
# variable importance
summary(output.lm)

# predictions on new data
predictions = predict(output.lm, test_)


################################################################
# DECISION TREE
################################################################
#
# variables are:
# minsplit minimum number of observations for a split to happen
# cp a split must decrease the overall lack of fit by a factor of 0.001 (cost complexity factor) before being attempted
# method is "class" for classification and "anova" for regression

minsplit = 30
cp = 0.001
method = "anova"

output.decisionTree = rpart(loss~., data=train_,control=rpart.control(minsplit=minsplit, cp=0.001),method=method)

plot(output.decisionTree, uniform=TRUE, main="Classification Tree for Kyphosis")
text(output.decisionTree, use.n=TRUE, all=TRUE, cex=.8)

# variable importance
summary(output.decisionTree)

# predictions on new data
predictions = predict(output.decisionTree, test_)



################################################################
# RANDOM FOREST
################################################################
#
# variables are:
# ntree Number of trees to grow. 
# nodesize Minimum size of terminal nodes. 

ntree = 10
nodesize = 3

output.forest = randomForest(loss ~ ., data = train_, ntree=ntree, nodesize = nodesize)
# variable importance
print(importance(output.forest,type = 2)) 

# predictions on new data
predictions = predict(output.forest, test_)


################################################################
# SVM
################################################################
#
# variables are:
# cross -- if a integer value k>0 is specified, a k-fold cross validation on the training data is
performed to assess the quality of the model: the accuracy rate for classification
and the Mean Squared Error for regression

cross = 1

output.svm = svm(loss ~ . , train_,cross=cross)
 
predictions = predict(output.svm, test_)



################################################################
# NEURAL NETWORK
################################################################
#
# variables are:
# hidden in the form of c(n,m) for n neurons for each of m hidden layers
# rep the number of repetitions for the neural network’s training.

hidden = c(2,1) # start small; you might be dealing with a bigger data set than you think
rep = 1

n = names(train_)
f = as.formula(paste("loss ~", paste(n[!n %in% "loss"], collapse = " + ")))
output.nn = neuralnet(f,data=train_[1:5000,],hidden=hidden,linear.output=T,rep=rep) # first 5k rows

# predictions on new data
predictions = compute(output.nn, test_[,1:30])$net.result



################################################################
# ASSESSMENT
################################################################

plot(test_$loss, predictions, xlab="original",ylab="predicted",bty="n",pch=16, col="orange");abline(0,1,lty=2)
MSE = sum((predictions - test_$loss)^2)/nrow(test_)
print(MSE)
