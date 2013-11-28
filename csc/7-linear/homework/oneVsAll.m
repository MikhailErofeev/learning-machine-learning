function [all_theta] = oneVsAll(X, y, num_labels, lambda)
%ONEVSALL trains multiple logistic regression classifiers and returns all
%the classifiers in a matrix all_theta, where the i-th row of all_theta 
%corresponds to the classifier for label i
%   [all_theta] = ONEVSALL(X, y, num_labels, lambda) trains num_labels
%   logisitc regression classifiers and returns each of these classifiers
%   in a matrix all_theta, where the i-th row of all_theta corresponds 
%   to the classifier for label i

% Some useful variables
m = size(X, 1);
n = size(X, 2);

% You need to return the following variables correctly 
all_theta = zeros(num_labels, n + 1);

% Add ones to the X data matrix
X = [ones(m, 1) X];


% Set Initial theta

% Hint: theta(:) will return a column vector.

options = optimset('GradObj', 'on', 'MaxIter', 10);

for c = 1: num_labels
	initial_theta = zeros(n + 1, 1);
	[theta] = ...
      fmincg (@(t)(lrCostFunction(t, X, (y == c), lambda)), ...
              initial_theta, options);
	%fprintf("s1 %f\n", size(theta,1));
	%fprintf("s2 %f\n", size(theta,2));
	%fprintf("as1 %f\n", size(all_theta(c),1));
	%fprintf("as2 %f\n", size(all_theta(c),2));
	all_theta(c,:) = theta';
end

end
