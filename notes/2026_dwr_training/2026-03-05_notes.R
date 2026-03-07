# This is my R script
# This is the notes for R Basics

round(7.856, 2)

getwd()
list.files()

setwd("2026_r_basics/")
setwd("..")

getwd()
setwd("2026_r_basics/")
setwd("~")
# Open up this folder to use/work with.
setwd("/home/nick/2026_r_basics/")

# If you're having trouble on Windows:
# Find the file in your file browser
# Right-click and select "Copy as path"
# Paste the path in RStudio
# Change the \ to /
# Put quotes "" around the path
# Remove the file name from the path
# Put setwd( ) around the path
# Run the command (Ctrl-Enter)

read.csv("data/2000-2023_ca_least_tern.csv")

# Check what directory R is looking at.
# What folder are we looking through?
getwd()  # hi

# What's in the current folder (working directory)?
list.files()
list.files("data")

terns = read.csv("data/2000-2023_ca_least_tern.csv")
terns

# You can use the rm function to delete a variable.
# But there's no undo!
# Potentially better to reassign the variable
# or just ignore it.

head(terns)
tail(terns)

head(terns, 3)

# Structural summary
str(terns)

# Statistical summary
summary(terns)

# Dimensions
dim(terns)
nrow(terns)
ncol(terns)

# What type of data?
class(terns)
class(6)

# Names of columns
names(terns)
colnames(terns)

# Selecting columns
terns$site_name
head(terns$site_name)
class(terns$site_name)

# Summarizing columns
# For non-numeric data, frequency counts are often
# useful.
site_table = table(terns$site_name)

sort(site_table)

# For numeric data, we can create statistical summaries
mean(terns$bp_min)
summary(terns$bp_min)
mean(terns$bp_min, na.rm = TRUE)

sd(terns$bp_min)
sd(terns$bp_min, na.rm = TRUE)
sd(terns$bp_min, na.rm = FALSE)
?sd

# What if the data isn't numeric?
mean(terns$site_name)


# Indexing (Ch. 3)

terns$site_name
class(terns$site_name)
class(terns$year)

# When trying to figure something out
# use a small "toy" example
x = c(5, 6, 8)
x
class(x)

c(7, x)

c("hi", 10, "hello")

1:10
-10:0

x

# Indexing vectors
x[2]
x[1]

# Indexes start from 1, not 0
x[0]

x[c(1, 3)]

x[1:2]
x[c(1, 2)]

# This doesn't work:
# x[1, 2]

x[c(3, 2)]
x[c(3, 3, 3, 1)]

# This doesn't work (x is not a function):
# x(5)

mean(x[1:2])

x[-1]
x

length(x)
x[2:length(x)]

# Setting elements
x
x[2] = 10
x

x[1:2] = 12
x

y = x
y

x
y


# Quirks
# R uses copy-on-write
y[3] = -6
y
x

# Vectorization
x
sqrt(4)
sqrt(x) # vectorized
x
sin(x)

sum(x) # not vectorized
mean(x)

# Recycling
x + x
x - c(1, 2, 3)

x - c(1, 2)

c(1, 2, 3, 4) - c(1, 0)


# Indexing on columns
terns$year[1]
terns$year[1:5]
terns$site_name[1:5]
1:5

# Indexing in 2 dimensions
terns[1, 3]
head(terns, 3)

# [rows, columns]
# blank means everything
terns[1, ]
terns[, 2]
class(terns[, 2])

terns[, 2:3]
class(terns[, 2:3])

terns[,] # entire data set

ncol(terns)
terns[, c(2, 3, 5)]

# Ctrl+l to clear the prompt
# Ctrl+c to cancel a command
# Ctrl+Enter to run a command

# Selecting columns
# Select a single column (you get a vector):
terns$year
terns[, 1]
terns[, "year"]
terns[["year"]]

# Select multiple columns (you get a data frame):
library("dplyr")
# Most functions in dplyr don't use quotes
# around column names
select(terns, year)
terns["year"] # for a data frame, defaults to columns

select(terns, year, bp_min)
terns[c("year", "bp_min")]

names(terns)

# Comparisons
5 < 6
"a" < "z"
"z" < "A"
"A" < "a"

6 > 7
7.5 >= 1.2
7.5 <= 1.2

6 == 7
6 == 6
x = 7
x == 5

# Filtering Rows
str(terns)

# library("dplyr")
year2000 = filter(terns, year == 2000)
year2000

dim(terns)
dim(year2000)
year2000$year

# Rows for years after 2019
filter(terns, year > 2019)

terns$site_name
chula_vista = filter(terns, site_name == "CHULA VISTA WILDLIFE RESERVE")
nrow(chula_vista)
dim(chula_vista)

# Mean just for the Chula Vista site:
mean(chula_vista$bp_min)

# To get multiple sites/values, use %in%:
sites = c("CHULA VISTA WILDLIFE RESERVE", "TIJUANA ESTUARY NERR")
filter(terns, site_name %in% sites)

# Another way:
filter(terns, site_name == "CHULA VISTA WILDLIFE RESERVE")
terns[terns$site_name == "CHULA VISTA WILDLIFE RESERVE", ]

terns$site_name == "CHULA VISTA WILDLIFE RESERVE"

# So to get every other row:
# Indexing, recycling
terns[c(TRUE, FALSE), ]
# row 1: TRUE
# row 2: FALSE
# recycle!
# row 3: TRUE
# row 4: FALSE
# recycle!
# ...

nrow(terns)

# Functions are like verbs, use ()
# Variables/data are like nouns, use []

# The [ is a function:
# "["(terns, 1, )  # terns[1, ]
# But you probably shouldn't write it like this.

# Combining conditions
# What if we want Chula Vista, year 2000?
filter(
  terns,
  site_name == "CHULA VISTA WILDLIFE RESERVE" &
  year == 2000
)
# & means both conditions must be true ("AND")
# | means one or the other or both must be true ("OR")

# xor function if you want one or the other, not both

filter(
  terns,
  site_name == "CHULA VISTA WILDLIFE RESERVE" |
    year == 2000
)

# ! negates a condition ("NOT")
filter(terns, !(year == 2000))
filter(terns, year != 2000) # same thing

# All rows that are not from year 2000 or year 2003
filter(terns, !(year == 2000 | year == 2003))

# With [ instead:
terns[
  !(terns$year == 2000 | terns$year == 2003),
]

x = filter(terns, year == 2000 & year == 2003)
nrow(x)

# Using %in% to check for several values
c(1, 2, 3) %in% c(1, 5)
years_of_interest = c(2000, 2003, 2005)
terns$year %in% years_of_interest
terns[terns$year %in% years_of_interest, ]
filter(terns, year %in% years_of_interest)

terns$yay %in% years_of_interest
terns$yay

# Next week:
# Data visualization, groups, data types, writing functions

library("ggplot2")
ggplot(terns) +
  aes(x = bp_min, y = fl_min) +
  geom_point()
