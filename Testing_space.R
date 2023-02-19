#Tracking markdown things

#First step is to knit the thing, then make an html that is readable in the blog universe.

knitr::knit("APD_Rbasics.Rmd")

markdown::markdownToHTML("APD_Rbasics.md","APD_basics.html",fragment.only=FALSE)