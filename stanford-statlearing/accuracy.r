rss <- function(expectedY, realY){
  rss = 0
  for (i in 1:length(expectedY)){
    ei = (realY[i] - expectedY[i])**2
    rss = rss + ei 
  }
  return (rss)
}

realFunction <- function(i) {
  return 10 + 0.3 * i
}


n = 100
x <- vector(mode = "double", length = n)
y <- vector(mode = "double", length = n)
for (i in 1:n){
  x[i] = i
  y[i] = realFunction(i) + 10 * rnorm(1)
}
#plot(x,y)

sampleSize = 30
sampleX <- vector(mode = "double", length = sampleSize)
sampleY <- vector(mode = "double", length = sampleSize)
for (i in 1:sampleSize){
  r = sample(x, 1)
  sampleX[i] = r
  sampleY[i] = realFunction(r) + 10 * rnorm(1)
}
plot(sampleX, sampleY)

real = sapply(seq(1, sampleSize), realFunction)
print(real)
print(sampleY)
rss = rss(real, sampleY)
curve(real, 0, n, xname = "t", add = TRUE)
print(rss)
#var(10 * rnorm(n))/n
#rands = rnorm(n)
#mean((rands - mean(rands))*2)
