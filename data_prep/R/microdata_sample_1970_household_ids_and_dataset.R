rm(list = ls())

# Loading Packages -------------------------------------------------------------

library(data.table)
library(fst)
library(tidyverse)
library(Hmisc)
library(here)

# usefull functions ------------------------------------------------------------

tab = function(x, y){
        CensusData[, .N, by = c(x, y)] %>%
                arrange_at(.vars = vars(all_of(c(x, y)))) %>%
                pivot_wider(names_from = y, values_from = N)
}


# Setup ------------------------------------------------------------------------

options(scipen = 999)
setDTthreads(threads = 4)
census_dir = "D:/Dropbox/Bancos_Dados/Censos/Censo 1970/"

# Opening data -----------------------------------------------------------------

househould_vars = c("v001", "v002", "v003", "v004", "v005",
                    "v006", "v007",
                    "v008", "v009", "v010", "v011", "v012",
                    "v013", "v014", "v015", "v016", "v017",
                    "v018", "v019", "v020", "v021",
                    "v024", "v025", "v041", 
                    
                    "MunicCode1970", "MunicCode2010", 
                    "v054",
                    
                    # Temporarias
                    "idpessoa", 
                    "v026",     # tipo da variável idade idade
                    "v027"     # idade
                    )

CensusData <- fread(paste0(census_dir,"Censo.1970.brasil.pessoas.amostra.25porcento.csv"), 
                    select = unique(c(toupper(househould_vars), 
                                      tolower(househould_vars),
                                      househould_vars)))


CensusData <- CensusData %>% setNames(tolower(names(.)))


# Creating a household ID ------------------------------------------------------

warning("This script requires:\n1) the data to be never resorted before. The order of the lines must be\n   exactly the same as in the original IBGE files.\n2) The data is complete: no registry were excluded. It has 24.793.358 lines.")

CensusData[ , flag := NA_real_]
CensusData[ , ind_collective := v007]
CensusData[is.na(ind_collective), ind_collective := 0]

# (1) In private households, a person who is head of a family starts a new household 
# (except if her family is a secondary family)
CensusData[ind_collective == 0 & v025 == 1 & (v006 %in% c(1,2)), flag := 1]

# (2.1) The first person living collective household starts a new household. We will assume every adjacent persons
# also marked as living in a collective househould inhabit that same house househould. In other words, a collective
# household just ends when a particular household starts.
CensusData[ , diff_collective := c(0,diff(ind_collective))]
CensusData[diff_collective == 1, flag := 1]

# (2.2) Persons living alone start a new household
CensusData[v006 == 0, flag := 1]

# (2.3) Adjusting: stating clearly that heads os secondary families do not start a household
CensusData[v025 == 1 & (v006 %in% c(3,4)), flag := NA]


# (3.1) Preliminary indetification of household ID
n_househoulds <- nrow(CensusData[flag == 1])
CensusData[flag == 1, idhh_preliminary := 1:n_househoulds]

# (3.2) Taking District and locality (rural/urban) into account
CensusData[,  idhh_locality := (idhh_preliminary * 100 + v003)*10 + v004]

# (4) All the other registries will receive the same household id given to the previous line
CensusData[, household_id := zoo::na.locf(idhh_locality)]


# (5.1) Assigning NA to collective households 
CensusData[,  mean_v007 := mean(v007, na.rm = T), by = household_id]
CensusData[mean_v007 %in% 1,  household_id := NA_real_]
CensusData[is.nan(mean_v007),  household_id := NA_real_]

# (5.2) Assigning NA to improvised households 
CensusData[,  mean_v008 := mean(v008, na.rm = T), by = household_id]
CensusData[mean_v008 %in% 2,  household_id := NA_real_]
CensusData[is.nan(mean_v008),  household_id := NA_real_]

# (5.3) Assigning to isolated person in collective households
CensusData[v006 %in% 0,  household_id := NA_real_]

CensusData[, n_pessoas_dom := .N, by = household_id]
CensusData[is.na(household_id), n_pessoas_dom := NA_real_]

CensusData[v006 == 1, .N, by = c("v005", "n_pessoas_dom")] %>%
        arrange(n_pessoas_dom) %>%
        pivot_wider(names_from = "n_pessoas_dom", values_from = N) %>%
        arrange(v005) %>% View()

selected = CensusData[v006 == 1 & n_pessoas_dom > v005]$household_id  %>% unique()
CensusData[household_id %in% selected] %>% View()

# Building the households dataset------------------------------------------------------------------------------

# Auxiliary variables to household income per capita
CensusData[ ,     nonrelative := as.numeric( v025==0|v025>=7) ]
CensusData[ ,        relative := 1 - nonrelative]
CensusData[ , numberRelatives := sum(relative), by = household_id]

CensusData[, age := as.double(NA)]
CensusData[v026 %in% c(1,2), age := 0]
CensusData[v026 %in% c(3,4), age := as.numeric(v027)]

# Recoding the total individual income
CensusData[,             totalIncome := 0]
CensusData[v041 == 9999, totalIncome := 0] 
CensusData[v041 <= 9998, totalIncome := v041]

# Some people will have zero income
CensusData[nonrelative == 1,    totalIncome := 0]
CensusData[age         <= 9,    totalIncome := 0]

# Household income
CensusData[  ,    hhIncome := sum(totalIncome), by = household_id]
CensusData[is.na(household_id),      hhIncome := NA_real_]

# Household income per capita
CensusData[ , hhIncomePerCap := hhIncome/numberRelatives]
CensusData[nonrelative == 1, hhIncome       := NA_real_]
CensusData[nonrelative == 1, hhIncomePerCap := NA_real_]

# Household weights (same as the weight of the chief of the household)
CensusData[, wgthh := 0]
CensusData[v025 == 1, wgthh := v054]
CensusData[, wgthh := max(wgthh), by = household_id]
CensusData[is.na(household_id), wgthh := NA_real_]


# Aggregating persons into household registries 
householdData <- CensusData[!is.na(household_id), 
                            
                            list(v001 = mean(v001, na.rm = T),
                                 v002 = mean(v002, na.rm = T),
                                 v003 = mean(v003, na.rm = T),
                                 v004 = mean(v004, na.rm = T),
                                 
                                 v006 = mean(v006, na.rm = T),
                                 v007 = mean(v007, na.rm = T),
                                 v008 = mean(v008, na.rm = T),
                                 v009 = mean(v009, na.rm = T),
                                 v010 = mean(v010, na.rm = T),
                                 v011 = mean(v011, na.rm = T),
                                 v012 = mean(v012, na.rm = T),
                                 v013 = mean(v013, na.rm = T),
                                 v014 = mean(v014, na.rm = T),
                                 v015 = mean(v015, na.rm = T),
                                 v016 = mean(v016, na.rm = T),
                                 v017 = mean(v017, na.rm = T),
                                 v018 = mean(v018, na.rm = T),
                                 v019 = mean(v019, na.rm = T),
                                 v020 = mean(v020, na.rm = T),
                                 
                                 v021 = first(v021),
                                 
                                 wgthh                    = mean(wgthh, na.rm = T),
                                 numberDwellers           = .N,
                                 numberDwellers_hhIncome  = mean(numberRelatives, na.rm = T),
                                 
                                 hhIncome       = mean(hhIncome, na.rm = T),
                                 hhIncomePerCap = mean(hhIncomePerCap, na.rm = T),
                                 
                                 municcode1970  = first(municcode1970),
                                 municcode2010  = first(municcode1970)),
                            
                            by = household_id]

# ------------------------------------------------------------------------------


wd_1970 = "D:/Dropbox/Bancos_Dados/Censos/censoBR/1970/"

fwrite(x = householdData, 
       file = paste0(wd_1970, "Censo.1970.brasil.domicilios.amostra.25porcento.csv"))

crosswalk_personid_hhid <- CensusData[, .(idpessoa, household_id)]
fwrite(x = crosswalk_personid_hhid, 
       file = paste0(wd_1970, "crosswalk_personid_hhid.csv"))










