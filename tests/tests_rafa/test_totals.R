library(censobr)
library(dplyr)



# 2010 -------------------------------------------------------------------------
dfp <- read_population(year = 2010)
dfh <- read_households(year = 2010)

total_2010_p <- dfp |>
  summarise(total = sum(V0010)) |>
  collect()

190755799

total_2010_h <- dfh |>
  summarise(total = sum(V0010)) |>
  collect()

total_2010_h
58051449

# 2000 -------------------------------------------------------------------------
dfp <- read_population(year = 2000)
dfh <- read_households(year = 2000)

total_2000_p <- dfp |>
  summarise(total = sum(PES_PESSOA, na.rm=T)) |>
  collect()

169872856

total_2000_h <- dfh |>
  summarise(total = sum(PESO_DOMIC, na.rm=T)) |>
  collect()

45507516





# 1991 -------------------------------------------------------------------------
dfp <- read_population(year = 1991)
dfh <- read_households(year = 1991)

total_1991_p <- dfp |>
  summarise(total = sum(V7301)) |>
  collect()

5.79e15

total_1991_h <- dfh |>
  summarise(total = sum(V7300)) |>
  collect()

35435725



# 1980 -------------------------------------------------------------------------
dfp <- read_population(year = 1980)
dfh <- read_households(year = 1980)

total_1980_p <- dfp |>
                summarise(total = sum(V604)) |>
                collect()
119011052

total_1980_h <- dfh |>
                summarise(total = sum(V603)) |>
                collect()
25210639


# 1970 -------------------------------------------------------------------------

dfp <- read_population(year = 1970)
dfh <- read_households(year = 1970)

total_1970_p <- dfp |>
                summarise(total = sum(V054)) |>
                collect()

94461969


total_1970_h <- dfh |>
                summarise(total = sum(V054)) |>
                collect()
17887536
