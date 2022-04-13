library(magrittr)

load_data <- function() {
  dat <- readxl::read_excel("data/MT_Y_6.xlsx", na="..")
  datAdm <- readxl::read_excel("data/WBI_CNE_Final.xlsx") %>%
    dplyr::select(Ind, CNE, WBI)
  dplyr::left_join(dat, datAdm, by=c("ID"="Ind"))
}
