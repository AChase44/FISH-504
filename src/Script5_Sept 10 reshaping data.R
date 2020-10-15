
# Day 1 Data Wrangleing ---------------------------------------------------


#data wrangling day 1

download.file(url = "https://ndownloader.figshare.com/files/2292169",
              destfile = "C:/Users/Student Account/Documents/FISH504RProjects/src/504_Sept3_Live_Code/sept3.csv")

surveys <- read.csv("C:/Users/Student Account/Documents/FISH504RProjects/src/504_Sept3_Live_Code/sept3.csv")


#ways to see data

head(surveys)

View(surveys)

str(surveys)

dim(surveys)

names(surveys)

summary(surveys)

#point to a particular section. [row number, column number] [,column][row,][from row x:to row y,column]
# [,-show all but this column] can also call by names of columns/rows

surveys[1,1]

surveys[,1]

surveys[1:3,7]

surveys[,-1]

surveys["species_id"]

sex <- factor(c("male,""female","male","female"))

levels(sex)
levels(surveys$sex)
nlevels(surveys$sex)

#tidyverse for data wrangling
#install tidyverse
#install.packages("tidyverse")
#require function is good for sharing code.
#require(tidyverse)
library(tidyverse)

# %>%  ctrl shift M for pipe %>% 
#this will do some sorting and tables

big_animals<-surveys %>% 
  filter(weight<5) %>% 
  select(species_id,sex,weight)
View(big_animals)

#quickly and easily read what you are doing rather than
#having inline as a chunk
#assignment one is posted. should be code based.explain why wrong answers are wrong.

# 9/10/2020 Load in data and packages -------------------------------------


#9/10/2020

#data wrangle, EDIC/FSH 503
#load packages
library(tidyverse)
#Load in data
surveys <- read.csv("C:/Users/Student Account/Documents/FISH504RProjects/src/504_Sept3_Live_Code/sept3.csv")


# 9/10/2020 tidyverse practice --------------------------------------------

surveys_sml<-surveys %>% 
  filter(weight<5) %>% 
  select(species_id, sex,weight)

#head(surveys_sml)in the live code will show us what we just did. Shows first or last part of data.
#we can calculate new columns with the mutate function. Very cool.
#I need to look up how pipe %>% works.

surveys %>% 
  filter(!is.na(weight)) %>% 
  mutate(weight_kg=weight/1000,
         weight_lb=weight_kg*2.2) %>% 
  head()

#na.rm=TRUE removes na values from calculation.
#let's sort and find the mean weights by sex.

surveys %>% 
  group_by(sex,species_id) %>% 
  summarize(mean_weight = mean(weight, na.rm=TRUE)) %>% 
  tail()

surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(sex,species_id) %>% 
  summarize(mean_weight=mean(weight,na.rm=TRUE),
            min_weight=min(weight)) %>% 
arrange(desc(mean_weight))
#arrange allows sorting data like the filter in excel. desc puts it in descending order.
#count will count the number of entries in a row or column.

surveys %>% 
  count(sex)

#Alternatively, could use the group and sumarise(count) function.

surveys %>% 
  group_by(sex) %>% 
  summarise(count=n()) %>% 
  arrange(desc(count))

#each row must be a single observation to work with tidyverse.
#real world data often needs to be reshaped to fit these requirements.
#CTRL+SHIFT+R to create new section.

# reshaping data ----------------------------------------------------------

surveys_gw<-surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id,genus) %>% 
  summarize(mean_weight=mean(weight))

str(surveys_gw)

surveys_gw_spread<-surveys_gw %>% 
  spread(key=genus, value=mean_weight)
view(surveys_gw_spread)

#opposite of spread is gather. 

surveys_gw_gather<-surveys_gw_spread %>% 
  gather(key="genus", value="mean_weight", -plot_id)
view(surveys_gw_gather)

#-plot_id means don't gather plot_id. 

#now we gonna talk about expoting data. 

# Export ------------------------------------------------------------------

surveys_complete<-surveys %>% 
  filter(!is.na(weight), #remove missing weight
         !is.na(hindfoot_length), #remove missing hindgood length
                is.na(sex)) #remove missing sex

species_counts<-surveys_complete %>% 
  count(species_id) %>% 
  filter(n>=50)

surveys_complete<-surveys_complete %>% 
  filter(species_id %in% species_counts$species_id) #want to replace surveys_complete after filtered to keep only those that have a species id column value that can be found in the species count dataset.

write_csv(surveys_complete, path="C:/Users/Student Account/Documents/FISH504RProjects/outputs/surveys_complete.csv")
