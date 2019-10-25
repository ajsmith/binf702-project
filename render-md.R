library(rmarkdown)
for (fpath in commandArgs(trailingOnly=TRUE)) {
    render(fpath, "all")
}
