library(magrittr)

load_data <- function() {
  dat <- readxl::read_excel("MT_Y_6.xlsx", na="..")
  datAdm <- readxl::read_excel("WBI_CNE_Final.xlsx") %>%
    dplyr::select(Ind, CNE, WBI)
  dplyr::left_join(dat, datAdm, by=c("ID"="Ind"))
}
