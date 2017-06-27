library(spatstat)
library(fpc)
library(RColorBrewer)
spatstat.options(gpclib = TRUE)

infiles <- dir(pattern='\\.txt$') #Place this file in the dirrectory of the files
change.files <- function(file){
	
data <- read.table(file, header = TRUE) #inport the data
xc <- data$Xc
yc <- data$Yc
xcc <- xc-min(xc)
ycc <- yc-min(yc)
Z <- cbind(xcc,ycc)
X <- ppp(xcc, ycc, c(0, max(xcc)), c(0, max(ycc)))

pdf(file=paste(file,"_raw.pdf")) #make an image of the raw data
plot(Z, pch=".", main="raw data")
dev.off()
dev.new()

d <- dbscan(Z,eps=60, MinPts=10) #Noise filter DBSCAN
str(d)
dbs <- table(d$cluster)
ZB <- cbind(Z,d$cluster) 
no_zero = apply(ZB, 1, function(row) all(row !=0 ))
filterZB <- ZB[no_zero,]
write.table(filterZB, "filterZB.txt", sep="\t")

pdf(file=paste(file,"_noisefilter.pdf")) #create the picture of Data minus the noise
plot(filterZB, pch=".", main="noise filter", xlim=c(0, max(xcc)), ylim=c(0, max(ycc)))
dev.off()
dev.new()

data2 <- read.table("filterZB.txt", header = TRUE)
xz <- data2$xcc
yz <- data2$ycc
ZBL <- ppp(xz, yz, c(0, max(xcc)), c(0, max(ycc)))

#second DBSCAN
P <- cbind(xz,yz)
d2 <- dbscan(P,eps=30, MinPts=20) # Preforms a DBSCAN to isolate clustered localizations
str(d2)
dbs2 <- table(d2$cluster)
PB <- cbind(P,d2$cluster) 
no_zero = apply(PB, 1, function(row) all(row !=0 ))
filterPB <- PB[no_zero,]
write.table(filterPB, "filterPB.txt", sep="\t")
pdf(file=paste(file,"_clustercolor.pdf"))
plot(d2,P, cex=0.2, main="DBSCAN eps=30, MinPts=20", xlim=c(0, max(xcc)), ylim=c(0, max(ycc)))
dev.off()
dev.new()

pdf(file=paste(file,"_cluster.pdf")) #Creates the image of the clustered data
plot(filterPB, pch=".", main="monomer cluster filter", xlim=c(0, max(xcc)), ylim=c(0, max(ycc)))
dev.off()
dev.new()

monomer <- dbs2[1]/sum(dbs2)*100
multimer <- (sum(dbs2)-dbs2[1])/sum(dbs2)*100

bars <- c(monomer,multimer)
pdf(file=paste(file,"_barplot.pdf")) #Creates barplot of the data
barplot(bars, col = c("black","grey50"), names.arg=c("monomer","multimer"), ylim=c(0,100), ylab="% of total molecules")
    #write.table(bars, quote=FALSE, sep="\t", sub("\\.txt$","_bars.txt", file))
    filename <- paste(file)
    append_bars <- data.frame(filename, monomer, multimer, NROW(filterZB))
    write.table(append_bars, file="collected_bars.txt", append=TRUE, sep="\t", quote=FALSE, row.names=FALSE, col.names=FALSE)
dev.off()
dev.new()

#density filtered
data3 <- read.table("filterPB.txt", header = TRUE)
xp <- data3$xz
yp <- data3$yz
PBL <- ppp(xp, yp, c(0, max(xcc)), c(0, max(ycc)))

den3 <- density(PBL, sigma=50, dimyx=512)
pdf(file=paste(file,"_density.pdf"))
plot(den3, main="density monomer cluster filter", zlim=c(0,0.01), xlim=c(0,max(xcc)), ylim=c(0,max(ycc)))
plot(X, pch=".", add = TRUE)
dev.off()
#dev.new()
#den4 <- density(PBL, sigma=50, dimyx=512)
#pdf(file=paste(file,"_quant.pdf"))
#plot(den4, col=grey(0), zlim=c(0,0.002), main="density monomer cluster filter", xlim=c(0,max(xcc)), ylim=c(0,max(ycc))
#dev.off()
graphics.off()
}
lapply(infiles, change.files)
