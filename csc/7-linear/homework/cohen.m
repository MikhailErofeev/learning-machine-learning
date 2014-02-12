function [ret] = cohen(predictions, y)
accuracy = mean(double(predictions == y));
errors = 1 - accuracy;
ret = (accuracy - errors)/(1 - errors);

