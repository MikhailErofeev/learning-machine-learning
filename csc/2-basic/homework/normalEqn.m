function [theta, diff] = normalEqn(X, y)
%NORMALEQN Computes the closed-form solution to linear regression 
%   NORMALEQN(X,y) computes the closed-form solution to linear 
%   regression using the normal equations.

theta = zeros(size(X, 2), 1);

theta = pinv(X' * X)*X'*y;

predict = transpose((transpose(theta) * transpose(X)));
diff = (predict .- y) .^2;

end
