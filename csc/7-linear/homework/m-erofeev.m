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
lambda = 0.1;
[all_theta] = oneVsAll(X, y, num_labels, lambda);
pred = predictOneVsAll(all_theta, X);
coh = cohen(pred, y)
fprintf('\nLearn Set Cohen Accuracy: %f\n', coh);

%test logic regression
pred = predictOneVsAll(all_theta, XTest);
coh = cohen(pred, yTest)

fprintf('\nTest Set Cohen Accuracy: %f\n', coh);