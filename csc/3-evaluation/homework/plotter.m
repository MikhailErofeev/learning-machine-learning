clear ; close all; clc

data = load('learn.txt');
xlearn = data(:, 1); ylearn = data(:, 2);
m = length(ylearn); % number of training examples

theta = [];
X = [];
tailor_series_size = 20
for n = 1:1:tailor_series_size
	feature = (-1)^(n + 1) / n * (xlearn - 1).^n;	 
	X = [X, feature];
	theta = pinv(X' * X)*X'*ylearn;
	val = X * theta;
	fprintf('mse %f\n', sum((ylearn - val).^2)/m);	
endfor

X
theta

data = load('test.txt');
x = data(:, 1); y = data(:, 2);
m = length(x);

X = [];
for n = 1:1:tailor_series_size
	feature = (-1)^(n + 1) / n * (x - 1).^n;	 
	X = [X, feature];
endfor
val = X * theta;
mse = sum((y - val).^2)/m


 plot(xlearn, ylearn, 'rx', 'MarkerSize', 3, 'color', 'green'); 
 figure
plot(x, y, 'rx', 'MarkerSize', 3, 'color', 'blue'); 
 figure; 
plot(x, val, 'rx', 'MarkerSize', 3, 'color', 'red'); 
%plot(x, val, 'rx', 'MarkerSize', 3); 
 figure; 


