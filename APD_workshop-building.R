###Building code for APD Practical workshop.

#Reading and manipulating data.

#Vectors

x = 5
y = 6

#Can also be multiple things.

x = 1:10
y = 11:20

plot(x, y)

#Key function, concatinate c()

#Basic structure c(thing, thing, thing, thing)

x = c(5,10,15,20,25,30)
y = c(12,14,16,18,20,22)

plot(x, y)

#We can also make charcater and logical vectors.

z = c("This", "is", "not", "a", "character", "vector")
t = c(TRUE, TRUE, FALSE, TRUE, TRUE, TRUE)

#These can interact and we can subset the one by the other by using [].

z[t == TRUE]

#This also works for numeric objects and we can pull a single value with x[position]

x[2]

#Tools for generating/manipulating vectors: sequence

#Basic structure is seq(first, last, by)

x = c(seq(0, 50, 5))
y = c(seq(10, 60, 5))

plot(x, y)

#This gives us sequences from 0-50 and 10-60 (respectively) by 5.

#These are easily reversed - rev(object)

r = rev(x)

plot(r, y)

#One of R's advantages is that you apply transformations evenly and explicitly.

x = x*10
y = y*10

plot(x, y)

#You can also derive statistics from vectors.

mean(x)
mean(y)
median(c(x, y))
mean(c(x,y))
max(x)
min(x)

#You can tranform a vector by the result of its own statistic.

x = x * mean(x)
y = y * mean(y)

plot(x, y)

#R executes the commands in the order that it reads them. Thus, you can use functions within other functions.

#Here, R will start the plot function, then use the log function "log(x)" on x create a plot against y.

plot(log(x), y)

#Vectors are useful, but a matrix is even more useful.

#Like vectors, we can conjure a matrix by explicitly defining it. We use 1:100 as the data and R fills a matrix with integers from 1-100. 

x = matrix(1:100, nrow = 10, ncol = 10)

#You can read portions of this data using []. The difference between a matrix and a vector is now you have a two-dimensional address [row, column]

x[4, 5]

#You can pull ranges of numbers as well

x[4:5, 5]

#You can pull entire rows by leaving the y (column) position empty

x[4, ]

#You can pull entire columns by leaving the x (row) position empty

x[ ,5]

#Quickly generating a random dataset.

#Here, we insert the sample() function into the matrix() function to make a 10 x 10 matrix of randomly selected values between 1:100.

RDM1234 = matrix( sample(1:100, 100, replace=TRUE), nrow = 10, ncol = 10)

#This could be a bit more realistic, let's give some probability distributions to it.

#This requires a bit of planning. We want more of some elements (1-5) and less of other elements (6-10). First fifty draws are going up per row of 10, second fifty are going down...

RDM1234[ ,1:5] = sample(1:100, 50, replace = TRUE, prob = c(rep(0.1, 50), seq(0.51, 1, 0.01)))

RDM1234[ ,6:10] = sample(1:100, 50, replace = TRUE, prob = c(seq(0.51, 1, 0.01), rep(0.1, 50)))

#We can see the impact we're having by looking at the  means of every column. Here, we use handy functions that work well with matrices.

#apply() lets us use a function on each column of a dataset. Form is apply(dataset, column (2) or row (1), function name)

apply(RDM1234, 2, mean)

#This gives us a matrix with different overall volumes of our imaginary taxa, but we don't see any change with depth.

#rnorm() lets us do this, giving us random normal distribution with a moving average.

rnorm(50, c(seq(25,50,0.5)), sd=5)

#Still looks like we're building the dataset by individual columns. So, we need to define ranges for these values as well as sds.

#This means we need a table with 50 rows and three columns.

FAKE_ECO = matrix(nrow = 7, ncol = 3)

#Three hyper abundant types with high counts, two are increasing, one decreasing.

FAKE_ECO[1,]=c(30,90,5)
FAKE_ECO[2,]=c(50,90,8)
FAKE_ECO[3,]=c(90,20,12)

#Three less abundant types, all decreasing.

FAKE_ECO[4,]=c(30,20,5)
FAKE_ECO[5,]=c(25,10,2)
FAKE_ECO[6,]=c(10,5,0.2)

#One type deviating around average

FAKE_ECO[7,]=c(25,26,3)

#Make fake matrix

FKE1234 = matrix(nrow = 50, ncol = 7)

#Fill fake matrix with rnorm data employing moving averages.

for(i in 1:ncol(FKE1234)){
  FKE1234[, i] = rnorm(nrow(FKE1234), c(seq(FAKE_ECO[i,1], FAKE_ECO[i,2], length.out = nrow(FKE1234))), FAKE_ECO[i,3])
}

#Since we are pretending that these are fake pollen counts, they need to be whole numbers.

FKE1234 = ceiling(FKE1234) #Rounding all values up to the nearest integer.

#Add some pretend depths

d = seq(-100,-2, 2) #Depths need to asend for plots to work.

#Make up pretend taxa

taxa = c("Alchornea", "Macaranga", "Syzygium", "Blighia", "Terminalia", "Tetrorchidium", "Nymphaea")

#Doctor up the matrix with depths and fake names.

row.names(FKE1234) = d
colnames(FKE1234) = taxa

#This basically works. We've made up a fake dataset!

barplot(t(FKE1234), horiz = TRUE)

#We can use apply to get sums for each column and create percentages.

FKEsum = apply(FKE1234, 1, sum)

#It is worth thinking about how R does this. FKEsum gives us a vector of sums for each column. 

### When we tell R to divide the FKE1234 matrix by the FKEsum vector, it starts at the first row, first column and divides it by the first row sum.
### Then, R moves to the second row  on the first column, dividing by the second row sum.
### This goes on until R gets to the bottom of the column, then it repeats this procedure for each column - cycling through the row sums each time.

#THIS IS IMPORTANT BECAUSE R PREFERS DATA ORGANIZED WITH VARIABLES BY COLUMNS - APD/NEOTOMA DATA IS SAMPLES BY COLUMNS!

FKEpct = (FKE1234/FKEsum)*100

barplot(t(FKEpct), horiz = TRUE)

#For base R, when we call plotting functions we can use any of the options in the plot() function generally. 
#Here, we add a title to the plot and change the orientation of the y axis labels.

barplot(t(FKEpct), horiz = TRUE, main = "Fake Core Barplot by %", las=1)

#There are a few ways to get to know more about a given function.
#R Studio nicely brings up the functions options when you begin to enter the text. Type in "barplot" and add the first parentheses "("
#You should see the functions options at this point. For barplot, this suggestion is not very informative.

#The help() function is better. You can also use the "Help" tab in the lower-right window to get more informative results.

help("barplot")

#Functions are really just pre-packaged commands and the options within them allow us to set the conditions of the variables employed within the function.

#Because coding languages require us to act in a systematic fashion, we can use this to make ourselves more efficient. 
#We can make a simple function to calculate the percent of a table of typical pollen data.
#We imagine our possible conditions - tables oriented with taxa as columns or rows.
###We can accomodate multiple possible conditiosn with if() fucntions - we define a condition, then a set of actions within {}. Then we set the other condition.
#Notice that we set the values for necessary variables (flip_axis in this case) when defining the function. These variables then don't have to be defined later.

calculate_percent = function(x, flip_axis = FALSE){
  
  if(flip_axis == TRUE){
    
    x = as.matrix(t(x))
    row_sums = apply(x, 1, sum)
    percent = (x/row_sums)*100
    
  } else {
    
    row_sums = apply(x, 1, sum)
    percent = (x/row_sums)*100
    
  }
  percent
}

#Then we call the function and use the default settings since our table is taxa as columns.

calculate_percent(FKE1234)

#When using functions, it is important to remember that the results need to be saved as an object in order for us to make use of them.

#We can make this dataset a bit more useful by making it a data frame object. 

FKEpct = as.data.frame(calculate_percent(FKE1234))

#R recognizes two kinds of matrix-style objects, which are basically tables.
#Remembering that R recognizes character, logical, and numeric data - a matrix can only contain one data type.
#A data frame can contain multiple data types. It also gives us new tools for navigating the data.

FKEpct$Alchornea #Calls the Alchornea percents.
FKEpct[,"Alchornea"] #This is how we call this data in the matrix.

#If you type "FKEpct$", R Studio brings up all of the columns in your dataset. This can be navigated with the up and down arrows on your keyboard.

#This way, one can easily extract and plot key insights without much work.

plot(FKEpct$Alchornea, row.names(FKEpct))

points(FKEpct$Syzygium, row.names(FKEpct)) #Notice that we can add data to plots!

#We can fancy up the plots easily by changing plot options.

plot(FKEpct$Alchornea, row.names(FKEpct),
     type="o", 
     pch = 1,
     col = "red",
     main = "Fake Data, Alchornea vs. Syzygium",
     xlab = "Depth cm",
     ylab = "Percent of Pollen Sum")

points(FKEpct$Syzygium, row.names(FKEpct),
     type="o", 
     pch = 2,
     col = "blue")

#We can customize the plot quite a bit, if we know the right variables to modify.

plot(FKEpct$Alchornea, row.names(FKEpct),
     xlim = c(0,50),
     type="o", 
     pch = 1,
     col = "red",
     main = "Fake Data, Alchornea vs. Syzygium",
     xlab = "Depth cm",
     ylab = "Percent of Pollen Sum")

points(FKEpct$Syzygium, row.names(FKEpct),
      type="o", 
      pch = 2,
      col = "blue")

points(FKEpct$Macaranga, row.names(FKEpct),
      type="o", 
      pch = 3,
      col = "orange")

#We can look for relationships with some basic statistics. Co-variance is extremely simple. 

cov(FKEpct$Alchornea, FKEpct$Macaranga)

cov(FKEpct$Alchornea, FKEpct$Syzygium)

cov(FKEpct$Alchornea, FKEpct$Nymphaea)

### NEED TO THINK ABOUT WHERE WE ARE GOING HERE...

#Other big topics that would be useful
  #Reading and saving data.
  #Subsetting data.
  #Summarizing by ecological data.
