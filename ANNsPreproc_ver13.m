%% Программа подготовки выборок для обучения иск. нейронной сети и решения
%задачи классификации с количеством классов, равным кол-ву экспериментов. 
%В результате выполнения программы формируются матрицы "inputs", "targets"
%для обучения ИНС, а также "inputs_test", "targets_test" для доп.тестир.

clear
clc
tic%начало отсчета
%% 1.Исходные данные 
%План 'Plan_exp301119.xls' включал 6 экспериментов по 5 паралл. опытов,
%доп.план 'Plan_exp_mar_03_2020.xls' вкл.6 экспериментов по 5 паралл. опытов
%Все опыты, кроме опытов с номером Ntest используются для обучения ИНС.
%Используются два способа подкл. изм.оборудования: шасси NI и Bruel&Kjaer

% Домашняя директория
cd %'G:\Exp_Defects_Detecting_Competition_mar_2020'
saveDir = cd;

% Настройки формирования датасета
Nexp=6;%кол-во эксп.по плану эксп.
Npar=10;%кол-во параллельных опытов в кажд. эксп. по плану эксп.
Nexcl=3;%кол-во исключенных опытов в каждом эксп., исп.для валид. и тестир.
nval=2;ntest=Nexcl-nval;%кол-во опытов для валид. и тестир. соотв.
%[Ntest,Nval]=random_test_numbers(Nexp,Npar,Nexcl)
[Ntest,Nval]=random_test_numbers(Nexp,Npar,ntest,nval);%случ.номера опытов для тестир.
Ntest=[3;17;26;40;44;60];Nval=[5 6; 12 19; 24 29; 33 38; 48 50; 54 57];%specific numbers

% Свитчи
ns=Nexp;%количество состояний: 2 (норма, неиспр.) или Nexp
normData="useSaved";%нормализация данных, "off","calculate","useSaved"
preClustering="off";%pre-clusterization of inputs and inputs_test
data2img ="off";%генерация картинок из данных выбранных измерений:
%"off"-выкл.,%"GrayData"-то же, но серые
imDim="2D";% "1D" or "2D"
%lingVar="train";%вспом.лингвистич.перем.,"train","test","NI","BK" 
witchHunt="off";%пров.гипотез о равенстве средних ("off","manual","auto")
fm=0;%фильтрация АЧХ с датчиков BK: 0- выкл., 1-вкл.
dNI=0;%дифференцирование сигналов с NI: 0- выкл., 1-вкл.
cutBK=1;%обрезка результатов с B&K по размеру l: 0-выкл., 1-вкл.
fr=0;%АЧХ для виброперемещений: 0- выкл., 1-вкл. !!!!!!!!!!Не работает пока

% Параметры обработки данных
alp=0.05; %уровень значимости при проверке гипотез о равенстве средних
rate1=1e+1;%частота записи сигналов
LF=2^9-1;%длина кадра для АЧХ
DR=0;%диапазон номеров измерений [] или 0, если весь диап.
 % Параметры обработки данных с шасси NI
 l =200;% кол-во измерений 1 фактора для 1 обучающей выборки
 n =100;% кол-во обучающих выборок из 1 опыта
 % Параметры обработки данных с Bruel&Kjaer
 %ld - кол-во измерений 1 фактора для 1 обучающей выборки фиксировано
 %Обработка и вывод данных 
 SGFiltOrder=3;%порядок фильтра Савицкого-Голея
 CadrLeng=9;%длина кадра

% Настройки генерации изображений траекторий (устарело)
X1minv=550; X1maxv=850;
X2minv=900; X2maxv=1200;
leng1v=143.6; leng2v=143.6;
%Визуализация фрагментов датасета
npic=9;%кол-во изображений

%Выбор типов измерений для обучения: 
%NI chasis
%CRRSm - коэффициент эл. сопротивления смазочного слоя сглаж, В (1);
%FCout - нагрузка на привод по показаниям частотн.регулятора, В (2);
%PPGreen - виброперемещение гориз., мкм (3);
%PPGreenSm - виброперемещение гориз. сглаженное, мкм (4);
%PPOrange- виброперемещение верт., мкм (5);
%PPOrangeSm- виброперемещение верт. сглаженное, мкм (6);
%Pressure - давление, МПа (7);
%pSm - давление сглаженное, МПа (8);
Nmeas=[0 0 0 0 0 0 0 0];%0 - измерение выкл., 1- измерение вкл.

%Bruel&Kjaer
%FFTMicro - (1);
%CPBMicro - (2);
%FFTVibro1- (3);
%FFTVibro2- (4);
%FFTVibro3- (5);
NmeasBruel=[1 0 1 1 1];%0 - измерение выкл., 1- измерение вкл.
%NmeasBruel=[1 0 0 0 0]
%% 2. Проверка некоторых настроек
check_settings(normData,data2img,nval,Nexcl)

%% 3. Подготовка нормализации данных, если н. необходима
%После н. все даные измер.в диап.от 0 до 1 
    
MinVals=zeros(length(Nmeas),1);MinValsBruel=zeros(length(NmeasBruel),1);
DeltaVals=MinVals+1;DeltaValsBruel=MinValsBruel+1;%вариант без н.
switch normData
    case "calculate"
        if sum(Nmeas)>0 %проверка условия использования данных с NI
            [MaxVals,MinVals,DeltaVals]=...
                scale_factors("NI",Nexp,Npar,Nmeas,saveDir);
        end
        if sum(NmeasBruel)>0 %проверка условия использования данных с ВК
            [MaxValsBruel,MinValsBruel,DeltaValsBruel]=...
                scale_factors("BK",Nexp,Npar,NmeasBruel,saveDir);
        end
    case "useSaved"
        MinVals=[0.016828791205853;0.013187689000000;4.289881004362182e+02;7.391443350568824e+02;2.498822770843990e+02;4.259113744973018e+02;-0.139759697690399;0.333950503116824];
        MinValsBruel=[-3.451290000000000;-3.451290000000000;-1.608340000000000e+02;-1.568270000000000e+02;-1.516540000000000e+02];
        DeltaVals=[1.316440528906987;0.270102371000000;1.003993519134704e+03;5.695451327544964e+02;1.113321885264418e+03;5.554771180049149e+02;2.598506219533248;0.206796662541645];
        DeltaValsBruel=[1.058642900000000e+02;1.058642900000000e+02;98.155100000000000;92.382500000000000;94.649800000000000];
end

%% 4. Создание папок для изображений, если необходимо
cd DataSet
saveSubDir=cd;
folders=["train","val","test"];
if data2img =="ColorData" || ...
        data2img =="GrayData" %пр.усл.постр.изобр. данных измерений
    %Создание папок по классам
    classes=["N1Normal", "N2BedBolt2", "N3BedBolts2and3",...
        "N4MotorScrew2","N5HighImbalance", "N6BedBolt2andMotorScrew2"];
for i=1:length(folders)
    mkdir (folders(i))
    cd (folders(i))
    for k=1:Nexp %заготовки папок под картинки в соответствии с классами
        mkdir (classes(k))%обучение
    end
    cd (saveSubDir)
end    
%     classes_val=["valN1Normal", "valN2BedBolt2", "valN3BedBolts2and3",...
%         "valN4MotorScrew2","valN5HighImbalance", "valN6BedBolt2andMotorScrew2"];
%     classes_test=["testN1Normal", "testN2BedBolt2", "testN3BedBolts2and3",...
%         "testN4MotorScrew2","testN5HighImbalance", "testN6BedBolt2andMotorScrew2"];
% for k=1:Nexp %заготовки папок под картинки в соответствии с классами
%         mkdir (classes(k))%обучение
%         mkdir (classes_val(k))% валидация
%         mkdir (classes_test(k))%тестирование
% end
end
cd (saveDir)
%% 5. Проверка гипотез о равенстве средних, если необходимо
Ndef=0;%заготовка матрицы с номерами дефектных опытов, которые следует исклол
switch witchHunt
    case "off"
    case "manual"
        [Z_p,Z_kr,X,Ndef]=witch_hunting(Nmeas,NmeasBruel,Nexp,Npar,...
            l,MinVals,DeltaVals,MinValsBruel,DeltaValsBruel,alp,saveDir);
        prompt = 'Enter the numbers of the defective tests using matrix format [1 2 3], or just push Enter ';
        %Ndef = input(prompt)
        Ndef %actual numbers of suspicious tests
        Ndef=[24];%assumed numbers of ...
        NoOfDefectiveTests=length(Ndef)
    case "auto"
        [Z_p,Z_kr,X,Ndef]=witch_hunting(Nmeas,NmeasBruel,Nexp,Npar,...
            l,MinVals,DeltaVals,MinValsBruel,DeltaValsBruel,alp,saveDir);
        Ndef=Ndef
        NoOfDefectiveTests=length(Ndef)
end

%% 6. Загрузка данных эксперимента. NI chasis
[inputs,targets,inputs_test,targets_test,inputs_val,targets_val]=...
    dataSetNI(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,Nmeas,ns,fr,DR,...
    MinVals,DeltaVals,saveDir);
if dNI==1
    inputs=diff(inputs);
    inputs_test=diff(inputs_test);
    inputs_val=diff(inputs_val);
end
%% 7. Загрузка данных эксперимента. Bruel&Kjaer
if sum(NmeasBruel)~=0
    [inputsBruel,inputs_testBruel,inputs_valBruel]=...
        dataSetBK(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,NmeasBruel,fm,...
        cutBK,MinValsBruel,DeltaValsBruel,saveDir);
    % Объединение данных
    inputs=[inputs;inputsBruel];    
    inputs_test=[inputs_test;inputs_testBruel];
    inputs_val=[inputs_val;inputs_valBruel];
end
inputsBruel=[];inputs_testBruel=[];inputs_valBruel=[];

%% 8. Извлечение части данных из м-ц inputs_test,targets_test для валидации
% The section is obsolet

% [inputs_test,targets_test,inputs_val,targets_val] =...
%     val_set_extraction(inputs_test,targets_test,nval,n);
%% 8 1/2. Preclustering
if preClustering=="on"
[preclustInfo]=preclustering(inputs,targets);%separates coulumns into 2 clusters of relativelly normal and abnormal data  
[clustInfo]=clustering(inputs,targets);%separates coulumns into 2 clusters of normal and defected
end
%% 9. Представление данных в виде изображений, если необходимо
switch data2img
%     case "ColorData"
%         cd(saveDir)
%         imageSaver(inputs,targets,classes,saveSubDir)
%         cd(saveDir)
%         imageSaver(inputs_val,targets_val,classes_val,saveSubDir)
%         cd (saveDir)
%         imageSaver(inputs_test,targets_test,classes_test,saveSubDir)
%         cd (saveDir)
    case "GrayData"
        cd(saveDir)
        imageSaverGray1D(inputs,targets,folders(1),classes,saveSubDir)
        cd(saveDir)
        imageSaverGray1D(inputs_val,targets_val,folders(2),classes,saveSubDir)
        cd (saveDir)
        imageSaverGray1D(inputs_test,targets_test,folders(3),classes,saveSubDir)
        cd (saveDir)
end
simulationTime=toc

%% 10. Сохранение матриц inputs,targets и др. для формирования датасета
clearvars alp CadrLeng cutBK data2img DeltaVals DeltaValsBruel dNI DR ...
 fm fr inputs_testBruel inputsBruel leng1v leng2v LF MinVals ...
 MinValsBruel Ndef Nexcl normData Npar ntest ...
 nval rate1 saveDir saveSubDir SGFiltOrder simulationTime ...
 witchHunt X1maxv X1minv X2maxv X2minv
save dataSet

%% 11. Дополнительная визуализация фрагментов датасета
%Визуализация
if sum(Nmeas) == 0 && sum(NmeasBruel) == 2
    npic=9;
    %size(targets,2)
    idx = randperm(size(targets,2),npic);
    figure ('Color','w')
    for i = 1:npic
        subplot(sqrt(npic),sqrt(npic),i)
        semilogy(inputs(:,idx(i)))
        text(0, 0.9, 'Microphone (FFT)')
        text(400, 0.9, 'Vibroaccelerometer (FFT)')
        [M,I]=max(targets(:,idx(i)));
        label = [num2str(i),'. Class ',num2str(I)];
        title(string(label));
        %axis ([1 (size(inputs(:,1),1)-2) 0 1])
        grid on
    end
end