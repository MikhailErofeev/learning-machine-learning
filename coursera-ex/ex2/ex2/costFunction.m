function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 

J = 0;
for i  = 1:m
  J = J + (- y(i)*log(sigmoid(sum(theta' .* X(i,:)))) - (1-y(i))*log(1-sigmoid(sum(theta' .* X(i,:)))));
end
%J  = 
J = J / m;


grad = zeros(size(theta));

c = zeros(size(grad));
for j = 1:size(theta)
	for i = 1:m
		c(j) = c(j) + (sigmoid(sum(theta' .* X(i,:))) - y(i))*X(i,j);
	end
	c(j) = c(j)/m;
	%c(j) = theta(j) - alpha / length(X) * c(j);
end
for j = 1:length(grad)
	grad(j) = c(j);
end

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%








% =============================================================

end
