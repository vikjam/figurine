# Minimal plot of the housing bubble
library(quantmod)
library(ggplot2)

# Create bare theme
theme_bare <- function() {
    theme(axis.line  = element_blank(),
    axis.text.x      = element_blank(),
    axis.text.y      = element_blank(),
    axis.ticks       = element_blank(),
    axis.title.x     = element_blank(),
    axis.title.y     = element_blank(),
    legend.position  = "none",
    panel.background = element_blank(),
    panel.border     = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    plot.background  = element_rect(fill = "black"))
}

# Download housing and rent data from FRED, then merge results
getSymbols(c("CSUSHPISA", "CUSR0000SEHC"), src = "FRED")
bubble.df <- merge(CSUSHPISA, CUSR0000SEHC)

# Calculate price to rent ratio
bubble.df$pr.ratio <- with(bubble.df, CSUSHPISA / CUSR0000SEHC)

# Remove missing values and convert to data.frame
bubble.df <- data.frame(na.omit(bubble.df))

# Extract dates into variable
bubble.df$date <- as.Date(rownames(bubble.df))

# Rescale to January 1998
scaling.factor <- as.numeric(bubble.df['1991-12-01', "pr.ratio"])
bubble.df$pr.ratio <- bubble.df$pr.ratio / scaling.factor

# Plot
ylims       <- c(floor(min(bubble.df$pr.ratio) * 10) / 10, 
                 ceiling(max(bubble.df$pr.ratio) * 10) / 10)
p           <- ggplot(bubble.df, aes(x = date, y = pr.ratio))
bubble.plot <- p + geom_area(fill = "#A31F34")                   +
                   coord_cartesian(ylim = ylims, expand = FALSE) +
                   theme_bare()

# Export
ggsave(bubble.plot, file = "bubble_plot.pdf", height = 2.16, width  = 3.66)

