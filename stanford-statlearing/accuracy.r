rss <- function(expectedY, realY){
  rss = 0
  for (i in 1:length(expectedY)){
    ei = (realY[i] - expectedY[i])**2
    rss = rss + ei 
  }
  return (rss)
}

slope <- function(x,y){
  meanX = mean(x)
  meanY = mean(y)
  up = 0
  down = 0
  for (i in 1:length(x)){
    dx = (x[i] - meanX)
    dy = (y[i] - meanY)
    up = up + dx*dy
    down = down + dx**2
  }
  return(up/down)
}

intercept <- function(y, slope, x){
  return mean(y) - slope*mean(x)
}

realFunction <- function(i) {
  return 10 + 0.3 * i
}

linear <- function(x, slope, intercept){
  return inetercept + x*slope
}

n = 100
x <- vector(mode = "double", length = n)
y <- vector(mode = "double", length = n)
for (i in 1:n){
  x[i] = i
  y[i] = realFunction(i)
}
#plot(x,y)

sampleSize = 100
sampleX <- vector(mode = "double", length = sampleSize)
sampleY <- vector(mode = "double", length = sampleSize)
for (i in 1:sampleSize){
  r = sample(n, 1)
  sampleX[i] = x[r]
  sampleY[i] = y[r]
}
expectingB = solve((t(sampleX) %*% sampleX)) %*% t(sampleX) %*% sampleY
print(expectingB)
testSize = 100
testX <- vector(mode = "double", length = testSize)
testY <- vector(mode = "double", length = testSize)
testRealY <- vector(mode = "double", length = testSize)
for (i in 1:testSize){
  r = sample(n, 1)
  testX[i] = x[r]
  ret = expectingB * x[r]
  testY[i] = ret
  testRealY[i] = y[r]
  #print (ret)
  #print (realFunction(x[r]))
}
rss = rss(testRealY, testY) #residual sum of squares -- остаточная сумма квадратов 
rse = sqrt(rss/(testSize - 2)) #residual standard error
print(rss)
print(rse)


#loSample <- loess(testY~testX)
#lines(predict(loSample), col='red', lwd=2)
#loReal <- loess(y~x)
#lines(predict(loReal), col='green', lwd=2)

#var(10 * rnorm(n))/n
#rands = rnorm(n)
#mean((rands - mean(rands))*2)
