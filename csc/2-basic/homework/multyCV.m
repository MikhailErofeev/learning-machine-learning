function mses = multyCV(X, y, lambda = 0.1, drops)

m = size(y);
mses = [];
data = [X y];
cols = length(transpose(data(1:1, :)));


%trainX = data(:,1:cols-1);
%trainY = data(:,cols);
%[trainX, trainY]
%[theta, mse]= normalEqn(trainX, trainY)

meanTheta = zeros(cols-1, 1);
for sample = 1:10000;
	r = randperm(size(data,1));
	data = data(r,:);	
	
	trainX = data(1:m/2,1:cols-1);
	trainY = data(1:m/2,cols);

	if (length(drops) > 0);
		index = transpose(r);
		index = index(1:m/2-1);	
		for i=drops;
			pos = find(index == i);
			trainX(pos,:) = [];
			trainY(pos,:) = [];
		endfor
	endif

	validationX = data(m/2:m, 1:cols-1); 
	validationY = data(m/2:m, cols);
	
	theta = pinv(trainX' * trainX)*trainX'*trainY;
	thetaReg = theta./length(m).*lambda;
	thetaReg(1) = 0;
	theta = theta - thetaReg;

	meanTheta = meanTheta + theta;
	
	predict = transpose((transpose(theta) * transpose(validationX)));
	
	mse = mean((predict .- validationY) .^2);
	mses = [mses mse];
endfor
%meanTheta / 10000
mse = mean(mses);
