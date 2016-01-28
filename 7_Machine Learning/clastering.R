# обучение без учителя

data(iris); library(ggplot2)
names(iris)

# we will ignore species labels and create new clasters
table(iris$Species)

# Create training and test set
inTrain <- createDataPartition(y=iris$Species, p=0.7, list=F)
training <- iris[inTrain,]
testing <- iris[-inTrain,]
dim(training); dim(testing)

# clasters with k-means
kMeans1 <- kmeans(subset(training, select=-c(Species)), centers=3)
training$clusters <- as.factor(kMeans1$cluster)
qplot(Petal.Width, Petal.Length, colour=clusters, data=training)

# Compare to real labels
table(kMeans1$cluster, training$Species)

# Build predictions
modFit = train(clusters~.,data=subset(training, select=-c(Species)), method="rpart")
table(predict(modFit, training), training$Species)

# Apply on test
testClusterPred <- predict(modFit, testing)
table(testClusterPred, testing$Species)