## Overview of the run_analysis.R

The script generate the tidy data set based on the following main steps:

1. Read the data (i.e., features and activity_labels) that are common to both testing and training set
2. Read all data related to Testing and combine them into a table - testx
3. Read all data related to Training and combine them into a table - trainx
4. Merge Testing and Training data into a single table - fulldata
5. Create a subset table based on the columns related to mean / standard deviation by using grep on column names
6. Cross reference to activity_label, and perform the grouping (by subject and activity) to compute the means of each variables
7. Standardise all column names (e.g., removing FULL-STOP, capitalise first letter)
8. Output the tidy data as "tidy.txt", per the requirement.

# The above steps can be cross-referenced to detailed comments within the run_analysis.R