function [mse] = multyCV(X, y)

m = size(y);
mses = [];
for sample = 1:10000;
	validationX = X;
	validationY = y;
	trainX = []; trainY = [];
	for i = 1:m/2;
		r = floor(rand() * length(validationY-1) + 1);
		trainX(i,:) = validationX(r,:);
		trainY(i,:) = validationY(r,:);
		validationY(r,:) =[]; validationX(r,:) = [];
	endfor
	%sampledX = []; sampledY = [];
	%for take = 1:length(trainY)*3;
	%	r = floor(rand() * length(trainY-1) + 1);
%		sampledX(take,:) = trainX(r, :);
%		sampledY(take,:) = trainY(r, :);					
%	endfor
	theta = zeros(size(trainX, 2), 1);
	theta = pinv(trainX' * trainX)*trainX'*trainY;

	predict = transpose((transpose(theta) * transpose(validationX)));
	mse = mean((predict .- validationY) .^2);
	mses = [mses, mse];
endfor
mse = mean(mses);
end
