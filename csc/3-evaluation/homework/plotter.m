clear ; close all; clc

data = load('learn.txt');
xlearn = data(:, 1); ylearn = data(:, 2);
m = length(ylearn); % number of training examples

theta = [];
X = [];
series_size = 500
for n = 1:1:series_size
	polynome = [];
	%poly = 2/(2*n + 1) * ((xlearn - 1)/(xlearn + 1))^(2*n + 1)
	for xlearn_single = xlearn'		
		if xlearn_single > 1
			inv = xlearn_single / (xlearn_single - 1);
			polynome = [polynome, 1./(n * inv^n)]; %Mercator, i choose you!
		else		
			sign = (-1)^(n + 1);
			polynome = [polynome, sign * (xlearn_single - 1)^n / n];		
		endif
		pos = pos + 1;
	endfor	 
	X = [X, polynome'];
	theta = pinv(X' * X)*X'*ylearn;
	val = X * theta;
endfor

X;
theta

data = load('test.txt');
x = data(:, 1); y = data(:, 2);
m = length(x);

X = [];
for n = 1:1:series_size
	polynome = [];	
	for x_single = x'
		if x_single > 1
			inv = x_single / (x_single - 1);
			polynome = [polynome, 1./(n * inv^n)]; %Mercator, i choose you!
		else		
			sign = (-1)^(n + 1);
			polynome = [polynome, sign * (x_single - 1)^n / n];		
		endif
	endfor
	X = [X, polynome']; 
endfor
val = X * theta;
mse = sum(((y - val).^2)')/m


 plot(xlearn, ylearn, 'rx', 'MarkerSize', 3, 'color', 'green'); 
 figure
plot(x, y, 'rx', 'MarkerSize', 3, 'color', 'blue'); 
 figure; 
plot(x, val, 'rx', 'MarkerSize', 3, 'color', 'red'); 
%plot(x, val, 'rx', 'MarkerSize', 3); 
 figure; 


