set.seed(1)
library(class)
library(e1071)
library(multtest)
library(knitr)
library(randomForest)
data(golub)

## ```{r setup, include=FALSE}
## knitr::opts_chunk$set(echo=TRUE)
## set.seed(1)
## library(class)
## library(e1071)
## library(multtest)
## library(knitr)
## library(randomForest)
## data(golub)
## ```

golub.shapiro <- apply(golub, 2, function(x) { shapiro.test(x)$p.value})
sum(golub.shapiro > 0.05)

golub.var <- apply(golub, 1, var)
sum(golub.var != 1)

## ```{r Biomarkers, echo=FALSE, fig.cap='Biomarkers'}
golub.fac <- factor(golub.cl, levels=0:1, labels=c("ALL", "AML"))
ALL.median <- apply(golub[, golub.fac=="ALL"], 1, median)
AML.median <- apply(golub[, golub.fac=="AML"], 1, median)
biomarkers <- order(abs(ALL.median - AML.median), decreasing=TRUE)
biomarkers50 <- biomarkers[1:50]
biomarkers50.names <- golub.gnames[biomarkers50, 2]
X <- t(golub[biomarkers50,])
colnames(X) <- golub.gnames[biomarkers50, 3]
boxplot(X, names=NULL)
## ```

## ```{r Training and Test Sets, echo=FALSE}
test_idx <- sample(length(golub.fac), round(length(golub.fac) / 3))
Xt <- X[-test_idx,]
Yt <- golub.fac[-test_idx]
Xv <- X[test_idx,]
Yv <- golub.fac[test_idx]
## ```

## ```{r Random Forest, echo=FALSE, fig.cap="Random Forest"}
rf.fit <- randomForest(Xt, Yt, importance=TRUE)
rf.test.pred <- predict(rf.fit, newdata=Xv)
table(rf.test.pred, Yv)
## ```

## ```{r Variable Importance Plot, echo=FALSE, fig.cap="Variable Importance Plot"}
varImpPlot(rf.fit, n.var=10, type=2)
## ```

## ```{r Support Vector Machine, echo=FALSE, warnings=FALSE, fig.cap="Support Vector Machine"}
svm.fit <- svm(
    Xt,
    Yt,
    data=data.frame(Yt, Xt),
    type="C-classification",
    kernel="linear",
    probability=TRUE
)
svm.test.pred <- predict(
    svm.fit,
    Xv,
    Yv,
    probability=TRUE
)
kable(table(svm.test.pred, Yv))
## ```


## ```{r KNN, include=FALSE, fig.cap="K Nearest Neighbor (k=3)"}
knn3.fit <- knn(Xt, Xv, Yt, k=3)
kable(table(knn3.fit, Yv))
## ```
