# https://stackoverflow.com/questions/77557377/how-to-convert-int-to-double-when-using-arrow-to-read-in-multiple-csvs-with-open

library(data.table)


df <- fread('./read_guides/readguide_2010_population.csv')


df[, col_class := fcase(decimal_places>0, '= numeric(),',
                        between(length, 1, 2) & is.na(decimal_places), '= integer8(),',
                        between(length, 3, 4) & is.na(decimal_places), '= integer16(),',
                        between(length, 5, 9) & is.na(decimal_places), '= integer32(),',
                        length > 9 & is.na(decimal_places), '= integer64(),',
                        default= '= string(),'
)]


df[,. (var_name, col_class)] |> print()
