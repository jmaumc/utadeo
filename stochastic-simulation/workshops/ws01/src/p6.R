
num.points <- 1000

circle.pts <- 0
square.pts <- 0

for (i in num.points^2) {
  rand.x <- runif(min=-1, max=1)
  rand.y <- runif(min=-1, max=1)
  
  dist <- rand.x^2 + rand.y^2
  
  if (dist <= 1) circle.pts <- circle.pts + 1
  square.pts <- square.pts + 1
  
  pi = 4 * circle.pts / square.pts
    
}

print(pi)