'load learn'
learn = load('learn.txt'); 
y = learn(:, 2)+1;
cols = length(transpose(learn(1:1, :)));
X = learn(:, 3:cols);
[X, mu, sigma] = featureNormalize(X);
num_labels = 2; %TODO change to uniq

'load test'
test = load('test.txt'); 
yTest = test(:, 2)+1;
cols = length(transpose(test(1:1, :)));
XTest = test(:, 3:cols);
[XTest, mu, sigma] = featureNormalize(XTest);

'train logic regression'
best = -1;
bestLambda = -1;
regularizationLamdas = [0.005, 0.1, 0.2, 0.3, 0.5, 0.75, 1];
lambdaIters = 5; 
retIters = 20;
for lambda = regularizationLamdas;
	[all_theta] = oneVsAll(X, y, num_labels, lambda, lambdaIters);
	pred = predictOneVsAll(all_theta, X);
	coh = cohen(pred, y);
	if (best < coh);
		best = coh;
		bestLambda = lambda;
	endif
endfor

[all_theta] = oneVsAll(X, y, num_labels, bestLambda, retIters);
pred = predictOneVsAll(all_theta, X);
coh = cohen(pred, y);
fprintf('\nLearn Set Cohen Accuracy: %f. best reg. lambda: %f\n', coh, bestLambda);

%test logic regression
pred = predictOneVsAll(all_theta, XTest);
coh = cohen(pred, yTest);

fprintf('\nTest Set Cohen Accuracy: %f\n', coh);