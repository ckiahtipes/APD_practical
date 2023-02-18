###Building code for APD Practical workshop.

#Reading and manipulating data.

#Vectors

x = 5
y = 6

#Can also be multiple things

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

#Like vectors, we can conjure a matrix by explicitly defining it.

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

FAKE_ECO[1,]=c(80,90,5)
FAKE_ECO[2,]=c(70,90,8)
FAKE_ECO[3,]=c(90,60,12)

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
  FKE1234[,i]=rnorm(nrow(FKE1234),c(seq(FAKE_ECO[i,1],FAKE_ECO[i,2],length.out = nrow(FKE1234))),FAKE_ECO[i,3])
}

#Add some pretend depths

d = seq(-2,-100,-2)

#Make up pretend taxa

taxa = c("Alchornea", "Macaranga", "Syzygium", "Blighia", "Terminalia", "Tetrorchidium", "Nymphaea")

#Doctor up the matrix

row.names(FKE1234) = d
colnames(FKE1234) = taxa

#This basically works. We've made up a fake dataset!

barplot(t(FKE1234), horiz = TRUE)



