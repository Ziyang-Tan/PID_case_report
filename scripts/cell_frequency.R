library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(ggpubr)

setwd('/Users/tan/PID-case-report/') 
dat <- read_csv('cell frequency.csv') %>%
  dplyr::select(c('level1', 'level2', 'PID017.1', 'PID017.2', 'PID017.3', 
                  'PID019.1', 'PID020.1')) %>%
  #rename(Visit1 = PID017.1, Visit2 = PID017.2, Visit3 = PID017.3) %>%
  #gather(Visit1, Visit2, Visit3, key='timepoint', value='percentage')
  gather(PID017.1, PID017.2, PID017.3, PID019.1, PID020.1, key='timepoint', value='percentage')

ggplot(dat, aes(fill=level1, x=timepoint, y=percentage)) + 
  geom_bar(position="fill", stat="identity") +
  labs(title = 'overall cell composition of all three patients')

sublist = c('B', 'CD4T', 'CD8T', 'Monocytes', 'NK', 'gdT')
glist = lapply(sublist, function(x){
  subdat <- dat %>%
    dplyr::filter(level1==x)
  ggplot(subdat, aes(fill=level2, x=timepoint, y=percentage)) + 
    geom_bar(position="fill", stat="identity") +
    labs(title = paste0(x, ' cell composition of all three patients')) +
    theme(axis.text.x = element_text(angle = -45, vjust = 0.5))
})
ggarrange(plotlist = glist, ncol = 2, nrow = 3, align = "hv")

