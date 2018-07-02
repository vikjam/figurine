# Schelling segregation model
# Based on https://simulatingcomplexity.wordpress.com/2016/01/06/building-a-schelling-segregation-model-in-r/

number <- 2000
group  <- c(rep(0, (51 * 51) - number), rep(1, number / 2), rep(2, number / 2))
grid   <- matrix(sample(group, 2601, replace = FALSE), ncol = 51)

# par(mar = c(0, 0, 0, 0))

# image(grid, col = c("#00C6D7", "#006A96", "#182B49"), axes = FALSE)

alike_preference  <- 0.60
happiness_tracker <- c()

get_neighbors <- function(p) {
    neighbors <- rbind(c(p[1] - 1, p[2]    ),
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

for(t in c(1:1000)) {
  happy_cells   <- c()
  unhappy_cells <- c()


for (j in c(1:51)) {
  for (k in c(1:51)) {
    current <- c(j,k)
    value   <- grid[j, k]
    if(value > 0) {
      like_neighbors <- 0
      all_neighbors  <- 0
      neighbors <- get_neighbors(current)
      for (i in c(1:nrow(neighbors))) {
        x <- neighbors[i,1]
        y <- neighbors[i,2]
        if (grid[x,y] > 0) {
          all_neighbors <- all_neighbors + 1
        }
        if (grid[x,y] == value) {
          like_neighbors <- like_neighbors + 1
        }
      }
      if (is.nan(like_neighbors / all_neighbors) == FALSE) {
        if ((like_neighbors / all_neighbors) < alike_preference) {
            unhappy_cells <- rbind(unhappy_cells, c(current[1], current[2]))
        }
          else {
            happy_cells <- rbind(happy_cells, c(current[1],current[2]))
          }
      }

      else {
        happy_cells <- rbind(happy_cells, c(current[1], current[2]))
      }
    }
  }
}

happiness_tracker <- append(happiness_tracker,
                            length(happy_cells) / (length(happy_cells) + length(unhappy_cells)))

rand <- sample(nrow(unhappy_cells))

for (i in rand) {
  mover       <- unhappy_cells[i,]
  mover_val   <- grid[mover[1], mover[2]]
  move_to     <- c(sample(1:51,1), sample(1:51,1))
  move_to_val <- grid[move_to[1], move_to[2]]
  while (move_to_val > 0 ){
    move_to     <- c(sample(1:51,1), sample(1:51,1))
    move_to_val <- grid[move_to[1], move_to[2]]
  }
  grid[mover[1], mover[2]]     <- 0
  grid[move_to[1], move_to[2]] <- mover_val
}

  # par(mfrow = c(1, 2))
}

pdf('schelling-segregation-R.pdf', height = 2.16, width = 3.66)
image(grid, col = c("#00C6D7", "#006A96", "#182B49"), axes = FALSE)
dev.off()
