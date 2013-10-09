function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;

a1 = X;
a1 = [ones(m, 1) a1];
z2 = a1 * Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1) a2];
z3 = a2 * Theta2';
a3 = sigmoid(z3);
Y = eye(num_labels)(y, :);
th1 = Theta1;
th1(:,1) = 0;
th2 = Theta2;
th2(:,1) = 0;

J = sum(sum(-Y .* log(a3) - (1-Y).*log(1-a3)));
J = J/m;
th = sum(sum(th1.^2)) + sum(sum(th2.^2));
th = lambda * th / (2*m);
J = J + th;

del_3 = a3 - Y;
del_2 = del_3 * Theta2 .* [ones(m,1) sigmoidGradient(z2)];
del_2 = del_2(:,2:end);
Theta1_grad = (del_2'*a1)/m + lambda*th1/m;
Theta2_grad = (del_3'*a2)/m + lambda*th2/m;


% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
