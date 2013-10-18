data = csvread('set.csv');
cols = length(transpose(data(1:1, :)));
X = data(:, 1:cols-1);
y = data(:, cols);
m = length(y);

FACTORS = [
'базовый',
'Мужчина',
'Средний школьный балл',
'239',
'Питер',
'Крутая школа',
'Доля пропущенных лекций',
'Оценка родителей выше',
'Пиво/неделя',
'Друзей в ОК/FB/ВК',
'Расстояние от дома до универа',
'Ряд в аудитории',
'Средний периметр головы',

'оценки из крутой школы',
'оценки из 239'
];

setenv('GNUTERM','X11')

#{
Поискать сложные зависимости
Начать с наиболее жгучих факторов 
	Кажется, что в данном случае достаточно только по theta для всего сета
У фактора должно быть нормальное распределение (построить гистограмму!)
Посмотреть на отсуствующие факторы. Заменить их лучше, чем средним?
Посмотреть на строки, которые дают сильное отклонение? Сколько их? Не обучаться на них?
Посмотреть корреляцию факторов, построить матрицу корреляций. 
	Выкинуть низкую корреляцию и объединить факторы с высокой (как?)
Добавить регуляризацию к параметру. Искать оптимальный по multyCV
ln, x^n факторов
получение новых факторов из существующих 
SOM
#}

x = X;
%попробуем сделать моном крутая школа * школьная оценка
hardSchool = X(:,5).*X(:,2);
%попробуем сделать моном 239 * школьная оценка
school239 = X(:,3).*X(:,2);
%x(:,3) = [];
plot(school239, y, 'rx', 'MarkerSize', 10);

x = [x, hardSchool, school239];
[x, mu, sigma] = featureNormalize(x);
x = [ones(m, 1), x];
[theta, mu] = normalEqn(x,y);
mu
for i = 1:length(theta);
	fprintf('%d\t%s\t%f\n',i, FACTORS(i,:), theta(i))
endfor

%hist(x(:, 4));
%plot(x(:,4), y, 'rx', 'MarkerSize', 10);
%pause
factorsToBuild = [1,3,4,14];

Xret =[];
for i = 1:length(factorsToBuild);
	factor = factorsToBuild(i);
	Xret = [Xret x(:, factor)];
endfor

[Xret, y];
means = multyCV(Xret, y);
meansS = sum(means);
meansL = length(means);
pm = sqrt(sum(means.*means) - meansS*meansS/meansL)/meansL;
fprintf('%f\t~%f\n', mean(means), pm);
	

return


% Пырю на факторы, ищу зависимости, строю гипотезы
% итерируюсь по факторам, выбрасываю нестабильные, чтобы потом пофиксить их, проверить на точных значениях и мб внедрить обратно
% вижу, что 8 - пиво - ну просто эпично вооообщееееее нестабильный, смотрю дальше без него
% 9 (после удаления 8, исходно 10) - расстояние до универа, сильно нестабильный 
X(:,8) = [];
FACTORS(8, :) = [];
X(:,9) = [];
FACTORS(9, :) = [];
% начинаю уточнять оставшиеся факторы. 
% 2 - средний бал. у отличников плохая зависимость, пробую добавить бинарный фактор отличника 
% 2 - добавил бинарный фактор отличника. на multy CV только шумит
% excellent = X(:, 2) == 5;
% X = [X, excellent];
% 2 на графике похож на квадратичный. если выкинуть линейный, небольшой прирост есть. 
%X = [X, X(:,2).^2];

for i = 0:columns(X);
	x = X;
	if (i > 0);
		FACTORS(i,:)
		x(:,i) = [];
	endif
	[x, mu, sigma] = featureNormalize(x);
	x = [ones(m, 1), x];
	means = multyCV(x, y);
	meansS = sum(means);
	meansL = length(means);
	pm = sqrt(sum(means.*means) - meansS*meansS/meansL)/meansL;
	fprintf('%d\t%f\t~%f\n', i, mean(means), pm);
	%считаю этот фактор в комбинации с любым из других
	continue
	x = X;
	[x, mu, sigma] = featureNormalize(x);
	x = [ones(m, 1), x];	
	if (i > 0);
		for j = 1:columns(X);
			if (i != j);
				xAnd = x(:,i) .* x(:,j);
				withAnd = [x, xAnd];	
				means = multyCV(withAnd, y);
				pm = sqrt((sum(means) - sum(means)*sum(means)/length(means))/length(means))/length(means)
				fprintf('%d\t%f\t+-%f\n', i, mean(means), pm);
				endif
		endfor
	endif
endfor
return	

% 2 - помимо отличников есть очень выбивающиеся элементы, типа f(4.7) = 0, f(3.3) = 19, f(3) = 16
% 2 - вообще можно ли обучить фактор только без тех %, что дают большую дисперсию?
% 7 - доля пропущенных сама по себе очень шумная, может её можно с чем-нибудь совместить? пол? нет. [пишет фреймворк подбора составного фактора]
% 7 - есть хорошее улучшение (0.8 балла) вместе с 239, прибавляю фактор X(:, 7).* X(:, 3);
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