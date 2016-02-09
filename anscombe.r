# Minimal plot of Anscombe's Quartet
library(ggplot2)
library(cowplot)

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
  plot.background  = element_rect(fill = "#A31F34"))
}

# Create function to plot
plot_anscombe <- function(x, y) {
  p <- ggplot(anscombe, aes(get(x), get(y)))
  a <- p + geom_point(colour = "white", size = 1) + 
            geom_smooth(method  = 'lm',
                        se      = FALSE,
                        colour  = "white",
                        size    = 0.5,
                        formula = y ~ x)            +
            theme_bare()
  a
}

# Assemble plots
a1        <- plot_anscombe("x1", "y1")
a2        <- plot_anscombe("x2", "y2")
a3        <- plot_anscombe("x3", "y3")
a4        <- plot_anscombe("x4", "y4")
all_plots <- plot_grid(a1, a2, a3, a4, align = "hv")

# Export
save_plot('anscombe.pdf',
          all_plots,
          base_height = 2.16,
          base_width  = 3.66)

# End of script
