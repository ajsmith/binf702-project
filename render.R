library(knitr)
docs <- c("Proposal")
for (doc in docs) {
    srcFile <- paste(doc, ".Rnw", sep='')
    knitrFile <- paste(doc, "-knitr.Rnw", sep='')
    texFile <- paste(doc, "-knitr.tex", sep='')
    Sweave2knitr(file.path("src", srcFile))
    knit(file.path("src", knitrFile))
    system(paste("xelatex", texFile))
}
