clear ; close all; clc

data = load('learn.txt');
x = data(:, 1); y = data(:, 2);
m = length(y); % number of training examples

theta = zeros(size(x, 2), 1);
[X mu sigma] = featureNormalize(x);
X = [ones(m,1), X];

theta = pinv(X' * X)*X'*y;
val = X * theta;
mse = sum((y - val).^2)/m;
lastMse = mse;
powers = [0, 1];
size(X)
for pw = -3:1:3
	[candidat mu sigma] = featureNormalize(x.^pw);
	X = [X, candidat];
	theta = pinv(X' * X)*X'*y;
	val = X * theta;
	mse = sum((y - val).^2)/m;
	fprintf('add pow %f\tmean err %f\tdiv %f\tmse %f\n', pw,  mean(y - val), std(y-val), mse);
	if lastMse <= mse
		fprintf('less!\n');
		X = resize(X, m, size(X,2));
	else
		powers = [powers, pw];
	endif
	lastMse = mse;
endfor

theta = pinv(X' * X)*X'*y;
val = X * theta;	
mse = sum((y - val).^2)/m
size(X)
powers


 plot(x, y, 'rx', 'MarkerSize', 3, 'color', 'green'); 
 figure

data = load('test.txt');
x = data(:, 1); y = data(:, 2);
m = length(x);
[X mu sigma] = featureNormalize(x);
size(X)
for pw = powers
	[feature mu sigma] = featureNormalize(x.^pw);
	X = [X, feature];
endfor
size(X)
val = X * theta;
mse = sum((y - val).^2)/m


plot(x, y, 'rx', 'MarkerSize', 3, 'color', 'blue'); 
plot(x, val, 'rx', 'MarkerSize', 3, 'color', 'red'); 
%plot(x, val, 'rx', 'MarkerSize', 3); 
 xlabel('x'); 
 ylabel('ln(x)');
 figure; 


