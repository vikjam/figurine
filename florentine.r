library(ergm)

pdf('florentine.pdf', bg = '#006A96')

plot.network(flomarriage,
	         edge.col      = 'white',
	         edge.lwd      = 3,
	         vertex.col    = '#FFCD00',
	         vertex.border = '#FFCD00',
	         vertex.cex    = 2)

dev.off()
