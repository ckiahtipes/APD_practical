#Script for making up fake cores.

###Buildout for making random pollen data table.

FAKE_taxa = c("Cyperaceae undiff.", "Typha", "Poaceae", "Alchornea", "Macaranga", "Celtis", "Blighia", "Sapotaceae undiff.", "Guibourtia demeusei")

FAKE_depth = seq(-200, -2, 2)
FAKEmin = c(40, 10, 20, 80, 50, 30, 5, 10, 5)
FAKEmax = c(10, 2, 50, 20, 10, 20, 15, 20, 25)
FAKEsd = c(5, 1, 10, 20, 15, 5, 2, 5, 2)

FAKE1234 = matrix(nrow = 100, ncol = length(FAKE_taxa))

for(i in 1:ncol(FAKE1234)){
  FAKE1234[, i] = rnorm(nrow(FAKE1234), c(seq(FAKEmin[i], FAKEmax[i], length.out = nrow(FAKE1234))), FAKEsd[i])
}

FAKE1234 = abs( ceiling(FAKE1234) ) #Using abs() to scrub negative values. 

colnames(FAKE1234) = FAKE_taxa
row.names(FAKE1234) = FAKE_depth

FAKEsum = apply(FAKE1234, 1, sum)

FAKEpct = (FAKE1234/FAKEsum)*100

row.names(FAKEpct) = FAKE_depth

barplot(t(FAKEpct), horiz = TRUE)

barplot(t(FAKEpct), horiz = TRUE, main = "Fake Core Barplot by %", las=1)

write.csv(FAKE1234[100:1,], "FAKE1234.csv", row.names = TRUE)

#Some fake botanical and ecological details.

FAKE_taxa = c("Cyperaceae undiff.", "Typha", "Poaceae", "Alchornea", "Macaranga", "Celtis", "Blighia", "Sapotaceae undiff.", "Guibourtia demeusei")

FAKE_fmly = c("CYPERACEAE", "TYPHACEAE", "POACEAE", "EUPHORBIACEAE", "EUPHORBIACEAE", "CANNABACEAE", "SAPINDACEAE", "SAPOTACEAE", "FABACEAE")
FAKE_plty = c("N", "N", "N", "TRSH", "TRSH", "TRSH", "TRSH", "TRSH", "TRSH")
FAKE_ecol = c("Wetland", "Wetland", "Grasses", "Pioneers", "Pioneers", "semi-deciduous rain forest", "tropical rain forest", "tropical rain forest", "flooded rain forest")

FAKE_details = cbind(FAKE_taxa, FAKE_fmly, FAKE_plty, FAKE_ecol)

write.csv(FAKE_details, "FAKE_taxa.csv")