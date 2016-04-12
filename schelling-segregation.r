# Schelling segregation model
# Based on https://simulatingcomplexity.wordpress.com/2016/01/06/building-a-schelling-segregation-model-in-r/

number <- 2000
group  <- c(rep(0, (51 * 51) - number), rep(1, number / 2), rep(2, number / 2))
grid   <- matrix(sample(group, 2601, replace = F), ncol = 51)

par(mar = c(0, 0, 0, 0))
image(grid, col = c("white", "#A31F34", "black"), axes = F)

alike_preference  <- 0.60
happiness_tracker <- c()

get_neighbors <- function(p) {
    neighbors <- c(c(p[1] - 1, p[2]    ),
                   c(p[1]    , p[2] - 1),
                   c(p[1] - 1, p[2] - 1),
                   c(p[1] + 1, p[2]    ),
                   c(p[1]    , p[2] + 1),
                   c(p[1] + 1, p[2] + 1),
                   c(p[1] - 1, p[2] + 1),
                   c(p[1] + 1, p[2] - 1))
    neighbors[neighbors <  1] <- 51
    neighbors[neighbors > 51] <- 1
    return(neighbors)
}

for (t in c(1:1000)) {
happy_cells<-c()
unhappy_cells<-c() 

