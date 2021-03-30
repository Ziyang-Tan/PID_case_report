library(tidyverse)
library(ggplot2)
library(ggpubr)

setwd('/Users/tan/PID-case-report/') 
filePath = file.path('isolight/data', dir('isolight/data'))
datalist = lapply(filePath, read_csv)
dat <- do.call(rbind, datalist) %>%
  dplyr::select(-c('X1', 'X4')) %>%
  dplyr::filter(Donor %in% c('PID017-1', 'PID017-2', 'PID17-3')) %>%
  dplyr::mutate(timepoint = paste0('Visit', gsub("^.*-", "", Donor))) %>%
  dplyr::select(which(apply(.!=0,2,any))) # remove columns with all zeros

namelist = colnames(dat)[!colnames(dat) %in% c('Donor', 'Stimulation', 'timepoint')]
glist = lapply(namelist, function(x){
  x = paste0("`", x, "`")
  ggplot(dat, aes_string(fill="timepoint", y=x, x="Stimulation")) +
    geom_bar(stat = 'identity', position = 'dodge')
})
ggarrange(plotlist = glist, ncol = 3, nrow = 6, align = "hv")

