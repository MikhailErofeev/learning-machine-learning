function mses = multyCV(X, y)

m = size(y);
mses = [];
data = [X y];
cols = length(transpose(data(1:1, :)));


%trainX = data(:,1:cols-1);
%trainY = data(:,cols);
%[trainX, trainY]
%[theta, mse]= normalEqn(trainX, trainY)


for sample = 1:10000;
	data = data(randperm(size(data,1)),:);	
	trainX = data(1:m/2,1:cols-1);
	trainY = data(1:m/2,cols);
	validationX = data(m/2:m, 1:cols-1); 
	validationY = data(m/2:m, cols);
	theta = pinv(trainX' * trainX)*trainX'*trainY;
	predict = transpose((transpose(theta) * transpose(validationX)));
	mse = mean((predict .- validationY) .^2);
	mses = [mses mse];
endfor
mse = mean(mses);
