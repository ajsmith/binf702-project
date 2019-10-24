#!/bin/bash

work_dir=$(dirname $0)
cd ${work_dir}

R < render.R --args Report
biber Report-knitr.bcf
R < render.R --args Report
