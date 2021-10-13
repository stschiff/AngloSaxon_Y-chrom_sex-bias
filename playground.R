library(magrittr)
library(ggplot2)

dat1 <- readxl::read_excel("ForFrequencies_Stephan.xlsx", range = readxl::cell_cols("A:D"))
cne_admix_rates <- readxl::read_excel("SexBias_Table_forDavid.xlsx") %>%
  dplyr::rename(aCNE = `aCNE autosomes`) %>%
  dplyr::select(Individual, aCNE)

datj <- dat1 %>% dplyr::left_join(cne_admix_rates, by=c("ID" = "Individual"))

# get the nums of inds per population
datj %>% dplyr::group_by(Population) %>% dplyr::summarise(n = dplyr::n())

admixed_inds <- datj %>% dplyr::filter(aCNE > 0.02 & aCNE < 0.98)
source1_inds <- datj %>%
  dplyr::filter(Population %in% c("Britain_PreEMA", "England_PreEMA") | aCNE < 0.02)
source2_inds <- datj %>% dplyr::filter(aCNE > 0.98 | Population == "NorthSea_EMA")

source1_haps <- source1_inds %>% dplyr::group_by(Haplogroup) %>% dplyr::summarise(n1 = dplyr::n())
source2_haps <- source2_inds %>% dplyr::group_by(Haplogroup) %>% dplyr::summarise(n2 = dplyr::n())
source_haps <- dplyr::full_join(source1_haps, source2_haps) %>%
  tidyr::replace_na(list(n1 = 0, n2 = 0)) %>%
  dplyr::mutate(n = n1 + n2, x1 = n1 / n, x2 = n2 / n)

admixed_inds_j <- admixed_inds %>% dplyr::left_join(source_haps)

admixed_inds_j %>%
  dplyr::rename(aut_CNE_fraction = aCNE, hap_CNE_fraction = x2) %>%
  ggplot() + geom_point(aes(aut_CNE_fraction, hap_CNE_fraction)) +
  geom_abline(slope = 1) + xlim(0, 1) + ylim(0, 1)
