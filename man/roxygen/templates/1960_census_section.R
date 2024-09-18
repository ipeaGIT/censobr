#' @section 1960 Census:
#'
#'The 1960 microdata version available in **{censobr}** is a combination of two
#'versions of the Demographic Census sample. The 25% sample data from the 1960
#'Census was never fully processed by IBGE - several states did not have their
#'questionnaires digitized. Currently, this dataset only has data from 16 states
#'of the Federation (and from a contested border region between Minas Gerais and
#'Espirito Santo called Serra dos Aimores). Information is missing for the states
#'of the former Northern Region, Maranhão, Piaui, Guanabara, Santa Catarina, and
#'Espírito Santo. In 1965, IBGE decided to draw a probabilistic sub-sample of
#'approximately 1.27% of the population, including all units of the federation.
#'With this data, IBGE produced several official reports at the time. The data
#'from **{censobr}** is the combination of these two datasets.
#'
#'We processed and ensured the consistency of the 1.27% sample data, which was
#'partially corrupted. We also created a sample weight variable to correct for
#'disproportionalities and to expand te sample to the total population. For the
#'data from the 25% sample, the weights expand to the municipal totals.
#'Meanwhile, for the data from the 1.27% sample, the weights expand to the state
#'totals. Additionally, we constructed a few variables that allow for the
#'approximate incorporation of the complex sample design, enabling the proper
#'calculation of standard errors and confidence intervals.
#'
#'You can read more about the 1960 Census and find a thogorugh documentation of
#'how this dataset was processed on this link \url{https://github.com/antrologos/ConsistenciaCenso1960Br}.

