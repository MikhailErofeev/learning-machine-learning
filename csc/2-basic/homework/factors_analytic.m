data = csvread('set.csv');
cols = length(transpose(data(1:1, :)));
X = data(:, 1:cols-1);
y = data(:, cols);
m = length(y);



setenv('GNUTERM','X11')

% Пырю на факторы, ищу зависимости, строю гипотезы
% итерируюсь по факторам, выбрасываю нестабильные, чтобы потом пофиксить их, проверить на точных значениях и мб внедрить обратно
% вижу, что 8 - доля пропущенных лекций - ну просто эпично вооообщееееее нестабильный, смотрю дальше без него
% 9 (после удаления 8, исходно 10) - пиво, сильно нестабильный 
X(:,8) = [];
X(:,9) = [];
for i = 0:columns(X);
	x = X;
	if (i > 0);
		x(:,i) = [];
	endif
	[x, mu, sigma] = featureNormalize(x);
	x = [ones(m, 1), x];
	means = multyCV(x, y);
	fprintf('%d\t%f\t%f\n', i, std(means), mean(means));
endfor
return	

% 2 - средний бал. у отличников плохая зависимость, как их можно выкинуть? 
% 2 - добавил бинарный фактор отличника, почти не зажгло (0.1 балла)
% 2 - кажется, что зависимость квадратичная
% 2 - помимо отличников есть очень выбивающиеся элементы, типа f(4.7) = 0, f(3.3) = 19, f(3) = 16
% 2 - вообще можно ли обучить фактор только без тех %, что дают большую дисперсию?
% 7 - доля пропущенных сама по себе очень шумная, может её можно с чем-нибудь совместить? пол? нет. [пишет фреймворк подбора составного фактора]
% 7 - есть хорошее улучшение (0.8 балла) вместе с 239, прибавляю фактор X(:, 7).* X(:, 3);
excellent = X(:, 2) == 5;
x = X;
x = [x, excellent];

%figure;
%pause;


[x, mu, sigma] = featureNormalize(x);
x = [ones(m, 1), x];
withExcellent = multyCV(x,y)
[x, mu, sigma] = featureNormalize(X);
x = [ones(m, 1), x];
withoutExcellent = multyCV(x,y)
excellent = withExcellent - withoutExcellent

	
return
for i = 0:columns(X);
	x = X(:, 8);
	if (i > 0);
		xAnd = x .* X(:, i);
		x = [xAnd, x];
	endif	
	[x, mu, sigma] = featureNormalize(x);
	x = [ones(m, 1), x];
	[theta, mse] = multyCV(x,y);
	fprintf('%d\t%f\n', i, mse);
endfor