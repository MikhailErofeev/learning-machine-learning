function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
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

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %







    % ============================================================

    % Save the cost J in every iteration    
	j = computeCost(X, y, theta);
    J_history(iter) = j;

end

end
