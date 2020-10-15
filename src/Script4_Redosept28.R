#data wrangling day 1

download.file(url="https://ndownloader.figshare.com/files/2292169",
              destfile="C:/Users/Student Account/Documents/FISH504RProjects/Data_raw/Survey_Complete.CSV")

surveys<-read.csv("C:/Users/Student Account/Documents/FISH504RProjects/Data_raw/Survey_Complete.CSV")

head(surveys)

view(surveys)

str(surveys) #shows info about our dataframe, and what kind of variable they are. Note that a data frame is a series of vectors of various types, integer, factors, etc.

dim(surveys)

names(surveys)

summary(surveys)

surveys[,1] # row, column
surveys[1,1] #points to row 1, column 1

surveys[1:3,7] #rows 1 to 3, column 7

surveys["species_id"] #can also call columns by their names.

sex<-factor(c("male","female","male","female"))
levels(sex)
levels(surveys$sex)
nlevels(surveys$sex)

#tidyverse

library(tidyverse)
big_animals<-surveys %>% 
  filter(weight<5) %>% 
  select(species_id,sex,weight)
view(big_animals)

surveys %>% 
  group_by(sex) %>% 
  summary()


