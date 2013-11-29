%load
learn = load('learn.txt'); 
y = learn(:, 2)+1;
cols = length(transpose(learn(1:1, :)));
X = learn(:, 3:cols);
num_labels = 2; %TODO change to uniq

test = load('test.txt'); 
yTest = test(:, 2)+1;
cols = length(transpose(test(1:1, :)));
XTest = test(:, 3:cols);

%train logic regression
best = -1;
bestLambda = -1;
regularizationLamdas = [0.005, 0.1, 0.2, 0.3, 0.5, 0.75, 1,]; 
for lambda = regularizationLamdas;
	[all_theta] = oneVsAll(X, y, num_labels, lambda);
	pred = predictOneVsAll(all_theta, X);
	coh = cohen(pred, y);
	if (best < coh);
		best = coh;
		bestLambda = lambda;
	endif
	fprintf('\nLearn Set Cohen Accuracy: %f\n', coh);

endfor

%test logic regression
pred = predictOneVsAll(all_theta, XTest);
coh = cohen(pred, yTest);

fprintf('\nTest Set Cohen Accuracy: %f\n', coh);