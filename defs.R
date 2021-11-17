# We read in data from multiple sources, see data/README.txt for details

rm_suffix <- function(name) {
  ifelse(endsWith(name, ".SG"), substring(name, 1, nchar(name) - 3), name)
}

load_joint_table <- function() {
  datY <- readxl::read_excel("data/ForFrequencies_Stephan.xlsx", range = 
                               readxl::cell_cols("A:D")) %>%
    dplyr::transmute(
      Individual = rm_suffix(ID),
      Population = Population,
      HaplogroupY = ifelse(stringr::str_starts(Haplogroup, "I2"), "I2", Haplogroup),
    ) %>%
    dplyr::mutate(Population = ifelse(Population == "Scandianvia_EMA", "Scandinavia_EMA", Population))
  
  datMT <- readr::read_tsv("data/mtDNA.txt", show_col_types = FALSE) %>%
    dplyr::transmute(
      Individual = rm_suffix(ID),
      Population = Population,
      HaplogroupMT = Reduced
    ) %>%
    dplyr::mutate(Population = ifelse(Population == "Britan_PreEMA", "Britain_PreEMA", Population))
  
  cne_admix_rates_modernRefs <- readxl::read_excel("data/CNE_WBI.xlsx") %>%
    dplyr::select(Ind, CNE) %>%
    dplyr::transmute(
      Individual = rm_suffix(Ind),
      modernCNE = CNE
    )
  cne_admix_rates_ancientRefs <- readxl::read_excel("data/SexBias_Table_forDavid.xlsx") %>%
    dplyr::rename(ancientCNE = `aCNE autosomes`) %>%
    dplyr::select(Individual, ancientCNE) %>%
    dplyr::mutate(Individual = rm_suffix(Individual)
  )
  
  dplyr::full_join(datY, datMT, by=c("Individual", "Population")) %>%
    dplyr::left_join(cne_admix_rates_modernRefs, by="Individual") %>%
    dplyr::left_join(cne_admix_rates_ancientRefs, by="Individual")
}
  

