
# Data Visualization (Ch 4)

library("ggplot2")
# If it's not installed:
# install.packages("ggplot2")

terns = read.csv("data/2000-2023_ca_least_tern.csv")
head(terns)
str(terns)

# Let's make a scatter plot of bp_min versus total_nests.
# Layer 1: Data
ggplot(terns)

# Layer 2: Geometry
ggplot(terns) +
  geom_point()


# Layer 3: Aesthetics
ggplot(terns) +
  geom_point() +
  aes(x = bp_min, y = total_nests)


# What if the geom was different?
# Line plot doesn't necessarily make sense here
ggplot(terns) +
  geom_line() +
  aes(x = bp_min, y = total_nests)

# What if we want to look at the points
# grouped by event?
ggplot(terns) +
  geom_point() +
  aes(
    x = bp_min, y = total_nests,
    color = event, shape = event
  )

head(terns$event)
table(terns$event)


# What if we also want to see year?
ggplot(terns) +
  geom_point() +
  aes(
    x = bp_min, y = total_nests,
    color = event, shape = event,
    label = year
  ) +
  geom_text()

# What if we only want the text
# to be color-coded?
ggplot(terns) +
  geom_point() +
  aes(
    x = bp_min, y = total_nests,
    shape = event,
    label = year
  )

# Back to simple version of plot
# without the text.
# Setting all points to blue:
ggplot(terns) +
  geom_point(
    color = "blue"
  ) +
  aes(
    x = bp_min, y = total_nests
  )

# Not quite right:
ggplot(terns) +
  geom_point(
  ) +
  aes(
    x = bp_min, y = total_nests,
    color = "blue"
  )

# Scales layer
# You can use to change palette
# Also to add axis labels, title

# Put labels on plots you share
p1 = ggplot(terns) +
  geom_point() +
  aes(
    x = bp_min, y = total_nests
  ) +
  labs(
    x = "Minimum Reported Breeding Pairs",
    y = "Total Nests",
    title = "Breeding Pairs v. Nests for Least Terns"
  )

# To change default colors, shapes, etc:
# Use scale_ functions, such as:
# scale_color_discrete

# How to save a plot
# Defaults to your working directory
ggsave("myplot.png")
?ggsave

# Can save plots in variables
# And use the variable in ggsave:
ggsave("myplot.png", p1)

# Bar plot
# Total number of fledglings each year
# by region.
ggplot(terns) +
  # The geom_bar layer defaults to adding
  # up or counting the data (stat_count)
  geom_bar() +
  aes(
    x = year,
    # Different orientation: y = year,
    # No good: y = fl_min
    weight = fl_min,
    fill = region_3
  )

# Let's improve the colors
# Also filter out the extra regions
regions_keep = c(
  "S.F._BAY", "SOUTHERN", "CENTRAL"
)

library("dplyr")
terns_filtered = filter(
  terns, region_3 %in% regions_keep
)
# Another way to do this step:
terns_filtered = terns[
  terns$region_3 %in% regions_keep,
]

ggplot(terns_filtered) +
  geom_bar() +
  aes(
    x = year,
    weight = fl_min,
    fill = region_3
  ) +
  scale_fill_viridis_d()






# Aggregation & Group (Ch 5)

# Aggregating a column
mean(terns$bp_min, na.rm = TRUE)

median(terns$bp_min, na.rm = TRUE)
# mean, median, sd, IQR, quantile, ...

library("dplyr")

summarize(
  terns,
  mean_bp_min = mean(bp_min, na.rm = TRUE),
  med_bp_min = median(bp_min, na.rm = TRUE)
)


# Aggregating on groups
# For one region_3 group:
southern = filter(terns, region_3 == "SOUTHERN")
table(southern$region_3)
mean(southern$bp_max, na.rm = TRUE)
# We could repeat this for each group...
# But that's tedious.

by_region = group_by(terns, region_3)
by_region
summarize(
  by_region,
  mean_bp_max = mean(bp_max, na.rm = TRUE)
)

# What is a tibble?
# tibble is the dplyr version of a data frame
# In most cases, data frames and tibbles are
# interchangeable.
head(terns)
# tibble function makes a tibble
tibble(terns)
# data.frame function makes a data frame
# data.frame

# What if we want to group on another category?

by_region_event = group_by(terns, region_3, event)
summarize(
  by_region_event,
  mean_bp_max = mean(bp_max, na.rm = TRUE)
)

# What if we just want to count observations
# for each (region, event) pair?
summarize(
  by_region_event,
  count = n()
)

# What if we want to match up the statistics
# to the original observations?
by_year = group_by(terns, year)
result = mutate(
  by_year,
  mean_bp_max = mean(bp_max, na.rm = TRUE)
)

result$mean_bp_max

# What if we want to save the new dataset?
# saveRDS -- saves data to RDS file (R native)
saveRDS(result, "mydata.rds")
# Use readRDS with the path to the file
readRDS("mydata.rds")

# Other formats: CSV, Parquet, HDF5, ...
# write.csv for CSV
# arrow package for Parquet
# hdf5 (?) package for HDF5
# ...


# Make it easier to see the new column:
result2 = mutate(
  by_year,
  mean_bp_max = mean(bp_max, na.rm = TRUE),
  .keep = "used"
)
print(result2, n = 100)


# Data Types (Ch 6)
class(terns)

class(5)
class("hi")
class(TRUE)
class(terns$year)
class(5)
class(6L) # get an integer
6L

3+5i
class(3+5i)

class(c(5, 6, 7))

class("hi")
class(6)
class(c("hi", 6))
c("hi", 6)

# Implicit coercion
c(TRUE, 6, "hi")
c(TRUE, 6, 5+3i)
class(c(TRUE, sqrt))
# Lists can have heterogeneous elements

# Is a row (in a data frame) a list? YES!
row = terns[1, ]
class(row)
typeof(row)  # low-level way to look at the type
# Data frames are lists of columns
# Columns can have different data types
# Columns are vectors

# How to make a list?
my_list = list(5, sin, terns)
# Generally always use [[ to index lists
class(my_list[[1]])
# [ gives back a list rather than its contents
class(my_list[1])
my_list[1]

# Factors

str(terns)
region = factor(terns$region_3)
region

class(region)
levels(region)

# R remembers the levels of a factor even if they aren't
# present
south = region[region == "SOUTHERN"]
south
levels(south)
table(south)

# To make R forget:
droplevels(south)

table(terns$region_3[terns$region_3 == "SOUTHERN"])
table(terns$region_3)

# Special values
# Missing value -- missing when data collected
NA

# Can appear in any type of column or vector
class(c(1, 2, NA))
class(c("hi", NA))

mean(terns$bp_max)
NA + 6
NA == 6
NA == NA
is.na(NA)
is.na(60)

table(is.na(terns$bp_max))

# You can combine is.na with filter
x = filter(terns, !is.na(bp_max))
mean(x$bp_max)

# NaN (e.g., 0/0) -- not mathematically defined
class(0/0)

# Inf (e.g., 5/0) -- mathematically goes to infinity in limit
5/0

# NULL -- not defined in R
dim(terns)
dim(6)

# Writing Functions (Ch 7)

# We want a function to test if something is negative
# What should we call it? is_negative

# How to write a function:
# 1. Write down what you want the function to do.
#    Pay attention to inputs and output.
# 2. Check if already exists
# 3. Write the code for a simple case, don't worry
#    about making it a function. Get it working.

x = -6
x < 0

# 4. Wrap the code in a function definition.
#    - Turn variable assignment into parameters.
#    - Give the function a name.
#    - Make sure the function returns a result.
is_negative = function(x = -6) {
  x < 0
}

# 5. Test the function!

is_negative(-6)
is_negative(10)
is_negative("hi")
is_negative()


# Example: Getting Largest Values (7.4)
# What if we want the 3 largest values in a vector?
# 1. Write it out in words (not in code).
# 2. Check if the function already exists.
# 3. Write the code for a simple case.

values = c(5, 8, -3, 10, 20)
# top 3 should be 20, 10, 8
sorted = sort(values, decreasing = TRUE)
head(sorted, 3)
# ?sort

# 4. Wrap in a function defintion.
get_top3 = function(values) {
  # top 3 should be 20, 10, 8
  sorted = sort(values, decreasing = TRUE)
  head(sorted, 3)
}

# 5. Test the function.
get_top3(values)
get_top3(c(6, 10, -20, 5))
get_top3(c("hi", "hello", "yay", "good"))

# Extend the function to do more:
get_top3 = function(values, n = 3, decr = TRUE) {
  # top 3 should be 20, 10, 8
  sorted = sort(values, decreasing = decr)
  head(sorted, n)
}

get_top3(values)
get_top3(values, 4)

# Control Flow (Ch 8)

# Conditional expressions
# Return a different greeting depending on
# the hour of day (24-hour clock)
hour = 14

if (hour >= 6 && hour <= 11) {
  # This runs if the condition TRUE
  greeting = "Good morning!"
} else {
  # This runs if the condition is FALSE
  greeting = "Good afternoon!"
}
greeting


# Loops
# How to repeat things
# install.packages("tidyverse")
library("purrr")

# Why use a map function?
sqrt(terns$bp_max)  # vectorized

class(terns$bp_max)  # not vectorized
class(terns)
# What if we want the class of every column?
map(terns, class)


map(terns, function(x) {
  # Like writing any other function,
  # you can put whatever you want to compute
  # for each column here.
  class(x)
})

# If you aren't sure what the elements are for
# your data, check with [[:
terns[[1]]

# Nick: naulle@ucdavis.edu
# Pamela: plreynolds@ucdavis.edu
# General: datalab@ucdavis.edu