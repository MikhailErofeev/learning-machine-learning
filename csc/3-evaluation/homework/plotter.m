clear ; close all; clc

data = load('learn.txt');
xlearn = data(:, 1); ylearn = data(:, 2);
m = length(ylearn); % number of training examples

theta = [];
X = [];
series_size = 50
xlearnMinusOneDivPlus= (xlearn - 1)./(xlearn + 1);
for n = 0:1:series_size
	poly = 2/(2*n + 1) * xlearnMinusOneDivPlus.^(2*n + 1);
	X = [X, poly];
endfor
theta = pinv(X' * X)*X'*ylearn;


data = load('test.txt');
x = data(:, 1); y = data(:, 2);
m = length(x);

X = [];
xMinusOneDivPlus = (x - 1)./(x + 1);
for n = 0:1:series_size
	poly = 2/(2*n + 1) * xMinusOneDivPlus.^(2*n + 1);
	X = [X, poly];
endfor
val = X * theta;
mse = sum(((y - val).^2)')/m


return
 plot(xlearn, ylearn, 'rx', 'MarkerSize', 3, 'color', 'green'); 
 figure
plot(x, y, 'rx', 'MarkerSize', 3, 'color', 'blue'); 
 figure; 
plot(x, val, 'rx', 'MarkerSize', 3, 'color', 'red'); 
 figure; 


