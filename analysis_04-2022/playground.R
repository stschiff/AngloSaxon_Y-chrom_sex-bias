library(magrittr)
source("analysis_04-2022/defs.R")

dat <- load_data()

dat %>% dplyr::group_by(Pop2) %>% dplyr::summarise(n = dplyr::n())
