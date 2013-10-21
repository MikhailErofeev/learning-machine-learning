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
'оценки из 239',
'квадрат средней оценки',
'оценка с 2.5 минусом школьникам 239',
'экспериментальный трешак'
];

setenv('GNUTERM','X11')

#{
Поискать сложные зависимости
Начать с наиболее жгучих факторов 
	Кажется, что в данном случае достаточно только по theta для всего сета
!У фактора должно быть нормальное распределение (построить гистограммы)
	!получилось подровнять только средний балл для 239. 
	!пробовал занизить отличников - на итоговой метрике портилось
	!не нашёл с чем ок коррелирует доля 
!Посмотреть на отсуствующие факторы. Заменить их лучше, чем средним?
%Посмотреть на строки, которые дают сильное отклонение? Сколько их? Не обучаться на них? 
	%Попробовал  - на multyCV всё зло
	!попробовать добавить факторов и повыкидывать ними?
!Посмотреть корреляцию факторов, построить матрицу корреляций. 
	!Выкинуть низкую корреляцию и объединить факторы с высокой (как?)
	!не нашёл ничего интересного
!Добавить регуляризацию к параметру. Искать оптимальный по multyCV
	!зажгло
ln, x^n факторов
получение новых факторов из существующих 
%SOM
#}

x = X;

schoolEval = X(:,2);
%попробуем сделать моном крутая школа * школьная оценка
hardSchool = X(:,5).*schoolEval;
%попробуем сделать моном 239 * школьная оценка
school239 = X(:,3).*schoolEval;

meanEvalSqr = schoolEval.^2;
excellent = X(:, 2) == 5;
attend = 1 - X(:, 6);
notPiter = X(:, 4) == 0;
girl = X(:, 1) == 0;
excellentGirl = excellent .* girl==0;
parentsMore (X:3)=-1;
index = transpose(1: m);
%пробую занизить иногородних отличников - не работает. всех отличников - тоже
excellentFromPiter = excellent .* notPiter==0;
experimental = 0.5 * excellentFromPiter + schoolEval;
[excellent excellentFromPiter schoolEval experimental];

plus239ToMean =  schoolEval - 2.5 * (school239 > 0);
minAtt = attend < 0.5;
experimental = attend;
[a, mu, sigma] = featureNormalize(1 - 2 * attend);
%plot(meanEvalSqr, y, 'rx' , 'MarkerSize', 10)
%hist(a)
%pause
%return
#{
[x, mu, sigma] = featureNormalize([meanEvalSqr, plus239ToMean]);
plot(
	x(:,1), y, 'rx' , 'MarkerSize', 10,
	x(:,2), y, 'go' , 'MarkerSize', 10
	);
pause
return
#}

%базовый скор - 6.55
%регуляризация
%+средний балл - 6.32
%+оценка родителей выше - 5.82
%+ср оценка с 2.5 минусом школьникам 239 - 4.67
x = [x, hardSchool, school239, meanEvalSqr, plus239ToMean, experimental];
[x, mu, sigma] = featureNormalize(x);
x = [ones(m, 1), x];
[theta, mu] = normalEqn(x,y);
for i = 1:length(theta);	
	fprintf('%d\t%s\t%f',i, FACTORS(i,:), theta(i))		
	fprintf('\n')
endfor
mu

#{
for i=2:length(theta);
	for j=1:length(theta);
		f1 = x(:,i);
		f2 = x(:,j);
		cor = cov(f1,f2);
		fprintf('%s\t%s\t%f\n',FACTORS(i,:), FACTORS(j,:), cor);
	endfor
endfor
#}

factorsToBuild = [1, 3, 8, 17];


Xret =[];
for i = 1:length(factorsToBuild);
	factor = factorsToBuild(i);
	Xret = [Xret x(:, factor)];
endfor

[theta, mu] = normalEqn(Xret, y);

fprintf('\n')
fprintf('\n')
fprintf('SHIP IT:\n')
for i = 1:length(factorsToBuild);
	factor = factorsToBuild(i);
	fprintf('%d\t%s\t%f',i, FACTORS(factor,:), theta(i))		
	fprintf('\n')
endfor

mu
%hist(x(:,18));

regularizationLamdas = [0, 0.3, 0.5, 0.75, 1,]; 
[Xret, y];

	
%for drop = [];	% пробую выбрасывать плохие строчки, но нифига не получается
	%drop
	bestMean = 100500;
	bestL = 100500;
	for lambda = regularizationLamdas;
		means = multyCV(Xret, y, lambda, []);
		meansS = sum(means);
		meansL = length(means);
		pm = sqrt(sum(means.*means) - meansS*meansS/meansL)/meansL;
		meanError = mean(means);
		if (meanError < bestMean);
			bestMean = meanError;
			bestL = lambda;
		endif			
		fprintf('%f\t%f\t~%f\n',lambda, meanError, pm);
	endfor	
	fprintf('best score (lambda = %f)  = %f\n', bestL, bestMean);
%endfor

return