function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 

J = 0;
for i  = 1:m
  J = J + (- y(i)*log(sigmoid(sum(theta' .* X(i,:)))) - (1-y(i))*log(1-sigmoid(sum(theta' .* X(i,:)))));
end
J = J / m;

jR = 0;
for i = 2:size(theta)
	jR = jR + theta(i)^2;
end
J = J + jR * lambda / (2 * m);

grad = zeros(size(theta));

c = zeros(size(grad));
for j = 1:size(theta)
	for i = 1:m
		c(j) = c(j) + (sigmoid(sum(theta' .* X(i,:))) - y(i))*X(i,j);
	end
	c(j) = c(j)/m;
	if (j > 1)
		c(j) = c(j) + theta(j)*lambda/m;
	end
	%c(j) = theta(j) - alpha / length(X) * c(j);
end
for j = 1:length(grad)
	grad(j) = c(j);
end




% =============================================================

end
