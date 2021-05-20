function [Z_p,Z_kr,X,Ndef]=witch_hunting(Nmeas,NmeasBruel,Nexp,Npar,...
    l,MinVals,DeltaVals,MinValsBruel,DeltaValsBruel,alp,saveDir)
%ПРОВЕРКА ГИПОТЕЗ О РАВЕНСТВЕ СРЕДНИХ

%Загрузка данных
cd DataSet %вход в директорию с датасетом
%X=zeros(sum(Nmeas)*l,Npar);%заготовка матрицы для сравнения
%XBruel=zeros(sum(NmeasBruel)*l,Npar);%заготовка матрицы для сравнения

figure ('Color','w')

%Заготовка матрицы Z_p
Z_p=zeros(Npar,Npar,Nexp);
%Однократные расчеты
load saved1%загрузка 1го опыта
%Данные с NI
Lf=length(PPOrange);
s1=randi(Lf-l);%случ.нач.точка,(Lf-l)- диап.опред.начальной точки кадра
lNmeas=length(Nmeas);
%Данные с BK
lb=size(FFT_vibro1,1);%базовый размер кадров для измерений B&K
maxnum=size(FFT_vibro1,2);
s1Bruel=randi(maxnum);% случайный столбец из вотерфола
lNmeasBruel=length(NmeasBruel);

%Формирование выборок и проверка гипотез
counter=0;
for ne=1:Nexp%номер эксперимента
    X=zeros(sum(Nmeas)*l,Npar);%заготовка матрицы для сравнения
    XBruel=zeros(sum(NmeasBruel)*lb,Npar);%заготовка матрицы для сравнения
    n=0;h=0;
    for np=1:Npar %номер опыта
        counter=counter+1;%главный счетчик
        n=n+1;%счетчик опытов от 1 до Npar
        buf=0;bufBruel=0;%обнуление буферов
        load (['saved',num2str(counter)])%загрузка опыта
        %ch=FFT_vibro3(1:5,s1Bruel)
        %ch=PPGreen(1:5)
        %[n ne]
        %Данные с NI
        buf=([CRRSm;FCout; PPGreen; PPGreenSm;...
            PPOrange; PPOrangeSm;...
            Pressure; pSm]'-MinVals')./DeltaVals';
        r=0;
        for nm=1:lNmeas
            if Nmeas(nm)~=0
                r=r+1;%счетчик номера использ. измер.
                start=1+(r-1)*l;
                stop=start+l-1;
                X(start:stop,n)=(buf(s1:(s1+l-1),nm));
            end
        end
        %Данные с BK
        bufBruel=[(FFT_micro-MinValsBruel(1))./DeltaValsBruel(1);...
              (FFT_micro-MinValsBruel(2))./DeltaValsBruel(2);...
              (FFT_vibro1-MinValsBruel(3))./DeltaValsBruel(3);...
              (FFT_vibro2-MinValsBruel(4))./DeltaValsBruel(4);...
              (FFT_vibro3-MinValsBruel(5))./DeltaValsBruel(5)];
        %Проверка размера файла
        if size(FFT_vibro1,2)~=1200
            warning (['The Bruel&Kjaer data in the test ',num2str(counter), ' has shorter length'])
        end
        
        r=0;start=0;stop=0;
        for nmb=1:lNmeasBruel
            if NmeasBruel(nmb)~=0
                r=r+1;%счетчик номера использ. измер.
                start=1+(r-1)*lb;
                stop=start+lb-1;
                startB=(1+lb*(nmb-1));
                s1Bruel=s1Bruel;
                %n=n
                %lb=lb
                %size(bufBruel)
                XBruel(start:stop,n)=(bufBruel(startB:(startB+lb-1),s1Bruel));
                %XBruel(1:5,:)
            end
        end
    end
    %Формирование полной матрицы измерений одного эксперимента
    if size(X)==0
        X=XBruel;
    else
        if size(XBruel)==0
            X=X;
        else
            X=[X;XBruel];
        end
    end
    Mu=mean(X);
    sigma2=var(X);
    sigma=sigma2.^0.5;
    %Проверка гипотез о равенстве средних и дисперсий:
    i=0;j=0;
    for i=1:Npar
        for j=i:Npar
            Z_p(i,j,ne)=abs(Mu(i)-Mu(j))/(sigma2(i)/length(X(:,i))+...
                sigma2(j)/length(X(:,j)))^0.5;
            if  sigma2(i)>=sigma2(j)
                F_p(i,j)=sigma2(i)/sigma2(j);
            else
                F_p(i,j)=sigma2(j)/sigma2(i);
            end
        end
    end
    %G_koxr=max(sigma2(K+1:K+10))/sum(sigma2(K+1:K+10));
    F_kr=finv(1-alp,length(X),length(X));
    Z_kr=norminv((1-alp)/2+0.5,0,1);
    FpSize=size(F_p);

    subplot(2,Nexp/2,ne);
    h=heatmap(round(Z_p(:,:,ne)/Z_kr,1));%,'ColorLimits',[0 1]);
    %h.ColorScaling = 'scaledrows';
    h.XLabel = 'Test number';
    h.YLabel = 'Test number';
    title (['Experiment ',num2str(ne)])  
%     ZZ=round(Z_p/Z_kr,2);    
%     figure
%     h=heatmap(Z_p);
%     h.ColorScaling = 'scaledrows';
%     h.XLabel = 'No of experiment';
%     h.YLabel = 'No of experiment';
%     hR.Title = (['\alpha=0.01, Zkr=',num2str(round(Z_kr,2)) ': if Zp_{i,j}/Zkr>1, then \mu_i!=\mu_j']);

end
%Формирование матрицы дефектных опытов
ne=0;counter=0;ch=0;Ndef=0;
for ne=1:Nexp
    for i=1:Npar
        counter=counter+1;
        j=i;
        ch=sum(Z_p(i,:,ne)>Z_kr)+sum(Z_p(:,j,ne)>Z_kr);
        %[counter j ch]
        %[(Z_p(i,:,ne)>Z_kr) ;(Z_p(:,j,ne)>Z_kr)']
        if ch>=Npar/2;%Npar-1
            Ndef=[Ndef counter];
        end
    end
end
Ndef(1)=[];
cd (saveDir)
end

