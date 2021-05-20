% Программа по созданию и обучению нейронной сети в nnstart
% Классификация данных с помощью ИНС
%
%Настройка обучения ИНС.
%Для начала обучения ИНС необходимо установить TRUE напротив training 
%Для запуска переобучения ИНС с новыми начальными коэффициентами и повышения точности сети при помощи
%функции init, необходимо указать TRUE напротив retraining и выбрать init=TRUE (traning приравнять FALSE)

%Запуск программы
training = true;
retraining = false;
%Выбор типа сети для обучения
%Feedforwardnet = TRUE; %Сеть прямого распространения
%Lvqnet = TRUE; %Сеть векторного квантования
%Способы повышения точности сети
ini = false;

% Данные переменные зараннее определены 
% и являются входными данными:
%
%   houseInputs - матрица входных данных.
%   houseTargets - матрица классов.

%% Загрузка данных
%load ('smal_data');

%Присвойте inputs & targets имена загруженных переменных соответствующих им.
sz1 = size(inputs,2); 
sz2 = size(inputs_test,2);
sz3 = size(inputs_val,2);
inputsNN = [inputs inputs_test inputs_val];
targetsNN = [targets targets_test targets_val];
 

%% Создание нейронной сети
if training
% При указании количества нейронов, зайдайте их ввиде матрицы и получите
% многослойную нейронную сеть(пример: hiddenLayerSize = [10 10] - 2 скрытых слоя по 10 нейронов.
hiddenLayerSize = [10 10]; %Количество нейронов

%Непосредственное создание нейронной сети:
%сначала указывается количество нейронов, затем метод тренировки (по умолчанию используется Левенберг-Марквардт):
% trainlm - Левенберг-Марквардт;
% trainbr - Байесовская регуляризация;
% trainbfg - BFGS Quasi-Newton;
% trainrp - Эластичное обратное распространение;
% trainscg - Чешуйчатый градиент сопряженного;
% traincgb - Конъюгат градиент с перезапуском Пауэлл / Бил;
% traincgf - Флетчер-Пауэлл Конъюгат Градиент;
% traincgp - Поляк-Рибьер Конъюгат Градиент;
% trainoss - Один шаг секущий;
% traingdx - Переменная скорость обучения Градиентный спуск;
% traingdm - Градиентный спуск с импульсом;
% traingd - Градиентный спуск;

%Можно использовать каскадные сети использовав вместо fitnet: cascadeforwardnet
%Сети прямого распространения: feedforwardnet
%Специальные сети прямого распространения:
%для работы с данными: fitnet
%распознование образов: patternnet; использует функцию обучения trainscg

net = patternnet(hiddenLayerSize,'trainscg'); 

% Деление обучающей выборки на группы Training, Validation, Testing
%net.divideFcn
%net.divideParam
 net.divideFcn = 'divideind';
 net.divideParam.trainInd = 1:sz1;
 net.divideParam.valInd   = sz1+1:sz2;
 net.divideParam.testInd  = sz2+1:sz3;
 %[net,tr] = train(net,inputs,targets);
 %view(net)
 %outputs = net(inputs);
 %errors  = gsubtract(targets,outputs);
 %performance  = perform(net,targets,outputs) 
 %trainTargets = targets .* tr.trainMask{1};
 %valTargets   = targets .* tr.valMask{1};
 %testTargets  = targets .* tr.testMask{1};
 %trainPerformance = perform(net,trainTargets,outputs)
 %valPerformance   = perform(net,valTargets,outputs)
 %testPerformance  = perform(net,testTargets,outputs)


%net.divideMode
%net.adaptFcn= 'adaptwb';
%net.initFcn ='initlay';
%net.divideMode ='sample';
%net.divideFcn             ='divideblock'  ;
%net.divideParam.trainRatio = 80/100;
%net.divideParam.valRatio = 20/100;
%net.divideParam.testRatio = 0/100;
%net.divideFcn             ='divideind'  ;
%net.trainRatio = 'inputs';
%net.divideParam.valRatio = 'inputs_val';
%net.divideParam.testRatio = 'inputs_test';

%% Папаметры нейронной сети
%!!!Если параметр вам не нужен советуется закоментировать соответствующую строку, могут не подходить для каскадных сетей!!!

net.trainParam.epochs = 1000; %Максимальное количество эпох для обучения
%net.trainParam.goal = 0; %Цель производительности
net.trainParam.max_fail = 6; %Максимальные ошибки проверки
%net.trainParam.min_grad = 1e-7; %Минимальный градиент производительности
%net.trainParam.mu = 0.001; %Начальный mu
%net.trainParam.mu_dec = 0.1; %mu коэффициент уменьшения
%net.trainParam.mu_inc = 10; %mu коэффициент увеличения
%net.trainParam.mu_max = 1e10; %Максимальная mu
%net.trainParam.show = 25; %Эпохи между дисплеями ( NaN без дисплеев)
%net.trainParam.showCommandLine = true; %Генерация вывода командной строки
%net.trainParam.showWindow = true; %Показать учебный интерфейс
%net.trainParam.time = inf; %Максимальное время тренировки в секундах

%% Тренировка сети
[net,tr] = train(net,inputsNN,targetsNN);
end 
%_________________________________




%______________________________




%% Переобучение сети методом изменения начальных коэффициентов
if retraining
    if ini
    net = init(net);
    net = train(net,inputsNN,targetsNN);
    end
end

%% Тестирование сети
outputs = net(inputs_test);
errors = gsubtract(outputs,targets_test);
performance = perform(net,targets_test,outputs)

tInd = tr.testInd;
tstOutputs = net(inputsNN(:, tInd));
tstPerform = perform(net, targetsNN(tInd), tstOutputs)

%% Расчет точности сети
[m,n]=size(outputs);
a=0;
for i=1:n
   [max_out,ind_out]=max(outputs(:,i));
   [max_targets,ind_targ]=max(targets_test(:,i));
   if ind_out == ind_targ
       a=a+1;
   end
end
accuracy=100*a/n; 
%% Получение информации о сети
%Просмотр схемы сети
view(net)

% Графики информации.
% Раскоментируйте строку чтобы получить график.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, plotfit(targets,outputs)
% figure, plotregression(targets,outputs)
% figure, ploterrhist(errors)
%% Сохранение нейронной сети
%save(['trainedAgent_2D_' datestr(now,'mm_DD_YYYY_HHMM')]);

