#APD Practical Workshop Series - Exercise 1

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

#Goal is to read tables of typical palynological data and generate some insights.

FAKE1234 = read.csv("cores/FAKE1234.csv", header = TRUE, row.names = "depth")

FAKEsum = apply(FAKE1234, 1, sum)

FAKEpct = (FAKE1234/FAKEsum)*100

barplot(t (FAKEpct[100:1, ]),
        xlim = c(0, 150),
        xlab = "% of All Pollen",
        horiz = TRUE,
        main = "Fake Core Barplot by %", 
        las = 1,
        axes = FALSE,
        legend.text = colnames(FAKEpct))

axis(1, seq(0, 100, 10))

#Use ecological details to subset pollen results.

FAKE_taxa = read.csv("cores/FAKE_taxa.csv", header = TRUE, row.names = "X")

FAKE_taxa

#We can use details about the pollen types to subset data. First, let's calculate percents based on a subset of tree-shrub (TRSH) pollen.
#We will use the same rules to calculate a sum for all the other types independently.

AP_sum = apply(FAKE1234[ ,FAKE_taxa$FAKE_plty == "TRSH"], 1, sum)

N_sum = apply(FAKE1234[ , FAKE_taxa$FAKE_plty != "TRSH"], 1, sum)

FAKE_APpct = (FAKE1234[ , FAKE_taxa$FAKE_plty == "TRSH"]/AP_sum)*100

FAKE_Npct = (FAKE1234[ , FAKE_taxa$FAKE_plty != "TRSH"]/N_sum)*100

#If you feel brave, you can also make functions that cut out repetitive work. If you find yourself doing something multiple times, experiment with a function!

make_pct = function(x, sample_cols = FALSE){
  if(sample_cols == TRUE){
    x_sum = apply(x, 2, sum)
    pct = (t(x)/x_sum)*100
  } else {
    x_sum = apply(x, 1, sum)
    pct = (x/x_sum)*100
  }
  pct
}

#Now we can use the make_pct function we just defined to handle some of the repetition.

FAKE_APpct = make_pct(FAKE1234[ ,FAKE_taxa$FAKE_plty == "TRSH"])

FAKE_Npct = make_pct(FAKE1234[ , FAKE_taxa$FAKE_plty != "TRSH"])

#Let's have a look at these. Always check pct calculations.

apply(FAKE_APpct, 1, sum)

apply(FAKE_Npct, 1, sum)

#Now we can plot these adjusted results. We're going to get fancy and add two plots to one window. We start with the previous code.

barplot(t (FAKE_Npct),
        xlim = c(0, 220), #Making space for two separate % calculations (100 + 100) and leaving space between.
        xlab = "% of Group",
        ylim = c(0, 150),
        horiz = TRUE,
        main = "Fake Core Barplot by Growth Form", 
        las = 1,
        axes = FALSE,
        legend.text = colnames(FAKE_Npct),
        args.legend = list(x = 100, y = 160, cex = 0.75))

barplot(t (FAKE_APpct),
        offset = 110,
        add = TRUE,
        horiz = TRUE,
        axes = FALSE,
        axisnames = FALSE,
        legend.text = colnames(FAKE_APpct),
        args.legend = list(x = 210, y = 160, cex = 0.75))

axis(1, seq(0, 100, 10))
axis(1, seq(110, 210, 10), labels = seq(0, 100, 10))

#All of this grayscale stuff is boring. Let's make up some colors.

#R's other strengths is its graphic capabilities. There's lots of great color options.

#You can call the palette and assign new colors.

palette(terrain.colors(100))

#Now we make objects containing the colors we want to use, based on our total of 100 colors across this spectrum.

#If you want to know what it looks like, it never hurts to plot it!

plot(1:100, 1:100, col = 1:100)

#Great, now we know higher numbers are closer to white. We can choose some sensible approximations for our herbaceous monocots and our terrestrial pollen.

AP_colors = c(50, 40, 30, 20, 10, 1)
N_colors = c(80, 70, 60)

#We can copy the same plotting text again and just add colors.

barplot(t (FAKE_Npct),
        xlim = c(0, 220), #Making space for two separate % calculations (100 + 100) and leaving space between.
        xlab = "% of Group",
        ylim = c(0, 150),
        horiz = TRUE,
        col = N_colors,
        main = "Fake Core Barplot by Growth Form", 
        las = 1,
        axes = FALSE,
        legend.text = colnames(FAKE_Npct),
        args.legend = list(x = 100, y = 153, cex = 0.75))

barplot(t (FAKE_APpct),
        offset = 110,
        add = TRUE,
        col = AP_colors,
        horiz = TRUE,
        axes = FALSE,
        axisnames = FALSE,
        legend.text = colnames(FAKE_APpct),
        args.legend = list(x = 210, y = 153, cex = 0.75))

axis(1, seq(0, 100, 10))
axis(1, seq(110, 210, 10), labels = seq(0, 100, 10))

#Good. Now, we can summarize some of our results as well. Let's look at the AP/NAP ratio, and the frequency of major ecological groups.

#We can make these group-relative percents our new pct table.

FAKEpct = cbind(FAKE_APpct, FAKE_Npct)

#We can subset these on the fly and plot them.

plot(apply(FAKEpct[ ,FAKE_taxa$FAKE_ecol == "Wetland"], 1, sum), #First instantiation of the plot command. Here is where we set plot parameters.
     row.names(FAKEpct),
     xlim = c(0, 100),
     type = "o",
     col = "light blue",
     ylab = "Depth cm",
     xlab = "Percent of Pollen Sum by Group",
     main = "Preliminary Results of Fake Core")

lines(apply(FAKEpct[ ,FAKE_taxa$FAKE_ecol == "Pioneers"], 1, sum),
      row.names(FAKEpct),
      type = "o",
      col = "orange")

lines(apply(FAKEpct[ ,FAKE_taxa$FAKE_ecol == "tropical rain forest"], 1, sum),
      row.names(FAKEpct),
      type = "o",
      col = "dark green")

#We can use the rioja package to make a pollen diagram.

#install.packages("rioja")

library(rioja)

strat.plot(FAKEpct,
           yvar=seq(-200,-2,2),
           scale.percent = TRUE, 
           plot.poly = TRUE, 
           col.poly = c(AP_colors,N_colors))








