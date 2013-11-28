function [J, grad] = lrCostFunction(theta, X, y, lambda)
%LRCOSTFUNCTION Compute cost and gradient for logistic regression with 
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;

%for i  = 1:m
%  J = J + (- y(i)*log(sigmoid(sum(theta' .* X(i,:)))) - (1-y(i))*log(1-sigmoid(sum(theta' .* X(i,:)))));
%end
%J = J / m;

hx = zeros(m);
hx = sigmoid(X*theta);
J = -(1/m)*( (y'*log(hx)) + (1-y)' *log(1-hx));
temp =  theta.*theta;
temp(1) =  0;
J = J + sum(theta(2:end).^2)*lambda/(2*m);


temp = zeros(size(theta)); 
grad = zeros(size(theta));
grad = X'*(hx - y)/m;
temp =  (lambda/m)*theta;
temp(1) =  0;
grad = grad + temp;
%grad = grad/m;


grad = grad(:);

end
