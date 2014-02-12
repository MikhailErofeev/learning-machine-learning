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
  y[i] = realFunction(i) + 0 * rnorm(1)
}
#plot(x,y)

sampleSize = 30
sampleX <- vector(mode = "double", length = sampleSize)
sampleY <- vector(mode = "double", length = sampleSize)
for (i in 1:sampleSize){
  r = sample(x, 1)
  sampleX[i] = r
  sampleY[i] = realFunction(r) + 0 * rnorm(1)
}
plot(sampleX, sampleY)

real = sapply(seq(1, sampleSize), realFunction)
print(sampleX)
print(sampleY)
rss = rss(real, sampleY) #не верно, там треш, а не соотношение. нужно сделать регрессию по сэмплу и соотносить одинаковые x
rse = sqrt(rss/(sampleSize - 2)) #residual standard error
print(rss)
print(rse)
lo <- loess(y~x)
lines(predict(lo), col='red', lwd=2)
#var(10 * rnorm(n))/n
#rands = rnorm(n)
#mean((rands - mean(rands))*2)
