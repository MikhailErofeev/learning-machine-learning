function [theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters)
%GRADIENTDESCENTMULTI Performs gradient descent to learn theta
%   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);

for iter = 1:num_iters
	c = zeros(length(theta),1);
	for j = 1:length(theta)
		for i = 1:length(X)
			c(j) = c(j) + (sum(theta' .* X(i,:)) - y(i))*X(i,j);
		end
		c(j) = theta(j) - alpha / length(X) * c(j);
	end
	for j = 1:length(theta)
		theta(j) = c(j);
	end








    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCostMulti(X, y, theta);

end

end
