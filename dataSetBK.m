function [inputsBruel,inputs_testBruel,inputs_valBruel]=...
        dataSetBK(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,NmeasBruel,fm,cutBK,MinValsBruel,DeltaValsBruel,saveDir)
%ПОДПРОГРАММА ФОРМИРОВАНИЯ ЧАСТИ ДАТАСЕТА ПО ДАННЫМ ШАССИ BK
cd DataSet

%Загрузка образца
load saved1
lb=size(FFT_vibro1,1);%базовый размер кадров для измерений B&K
%Проверка условия обрезки данных
switch cutBK
    case 1
        if lb>l%условие укорачивания кадров 
            lb=l; 
        end
end
inputsBruel=zeros(sum(NmeasBruel)*lb,n*Nexp*(Npar-Nexcl));
%Заготовки матриц для тестирования and validation ИНС
inputs_testBruel=zeros(sum(NmeasBruel)*lb,n*size(Ntest,1)*size(Ntest,2));
inputs_valBruel =zeros(sum(NmeasBruel)*lb,n*size(Ntest,1)*size(Ntest,2));
%Заполнение матриц

%Матрицы targetsBruel, targets_testBruel, targets_valBruel
% for i=1:Nexp
%     
%     start=1+((i-1)*n*(Npar-Nexcl));
%     stop=start+(n*(Npar-Nexcl))-1;
%     targetsBruel(i,start:stop)=1;
%     
%     start=1+((i-1)*n*Ntest);
%     stop=start+(n*Ntest)-1;
%     targets_testBruel(i,start:stop)=1;
%     
%     start=1+((i-1)*n*Nval);
%     stop=start+(n*Nval)-1;
%     targets_valBruel(i,start:stop)=1;
% end
% if ns == 2 %переписывание матриц для 2 классов
%     targetsBruel(1,1:(n*(Npar-Nexcl)))=1;
%     targetsBruel(2,(n*(Npar-Nexcl))+1:end)=1;
%     targetsBruel(3:end,:)=[];
%     
%     targets_testBruel(1,1:n*Ntest)=1;
%     targets_testBruel(2,n*Ntest+1:end)=1;
%     targets_testBruel(3:end,:)=[];
% 
%     targets_valBruel(1,1:n*Nval)=1;
%     targets_valBruel(2,n*Nval+1:end)=1;
%     targets_valBruel(3:end,:)=[];
% end

%Матрицы inputsBruel, inputs_testBruel, inputs_valBruel
c=0;c_test=0;c_val=0;i=0;
for i=1:Nexp*Npar %номер опыта
    %num2str(i)
    ic=i;
    load (['saved',num2str(i)])
    if fm==1
        FFT_micro=sgolayfilt(FFT_micro,SGFiltOrder,CadrLeng);
        FFT_vibro1=sgolayfilt(FFT_vibro1,SGFiltOrder,CadrLeng);
        FFT_vibro2=sgolayfilt(FFT_vibro2,SGFiltOrder,CadrLeng);
        FFT_vibro3=sgolayfilt(FFT_vibro3,SGFiltOrder,CadrLeng);
    end

    bufBruel=[(FFT_micro-MinValsBruel(1))./DeltaValsBruel(1);...
              (FFT_micro-MinValsBruel(2))./DeltaValsBruel(2);...
              (FFT_vibro1-MinValsBruel(3))./DeltaValsBruel(3);...
              (FFT_vibro2-MinValsBruel(4))./DeltaValsBruel(4);...
              (FFT_vibro3-MinValsBruel(5))./DeltaValsBruel(5)];
        
    maxnum=size(FFT_vibro1,2);
    rand_numbers = randperm(maxnum);
    
    testID="train";
    if sum(sum(ic==Ntest))>0
        testID="test";
    end
    if sum(sum(ic==Nval))>0
        testID="val";
    end
    
    switch testID
        
        case "val"    
   % if sum(ic==Ntest)>0
        for j=1:n %номер кадра
            if n > maxnum
                s1=randi(maxnum);% случайный столбец из вотерфола
            else
                s1=rand_numbers(j);
            end
            r=0;
            c_val=c_val+1;%счетчик номера столбца м-цы inputs
            for k=1:length(NmeasBruel)%номер типа измерений
                if NmeasBruel(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*lb;
                    stop=start+lb-1;
                    startB=(1+lb*(k-1));
                    inputs_valBruel(start:stop,c_val)=...
                        bufBruel(startB:(startB+lb-1),s1);    
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputs_valBruel(:,c_val)=[];%удаление столбца целиком
                %targets_valBruel(:,c_test)=[];
                c_val=c_val-1;%откат номера
            end
        end
        
        case "test"
        %else
        %rand_numbers = randperm(maxnum);
        for j=1:n %номер кадра
            if n > maxnum
                s1=randi(maxnum);% случайный столбец из вотерфола
            else
                s1=rand_numbers(j);
            end
            r=0;
            c_test=c_test+1;%счетчик номера столбца м-цы inputs
            for k=1:length(NmeasBruel)%номер типа измерений
                if NmeasBruel(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*lb;
                    stop=start+lb-1;
                    startB=(1+lb*(k-1));
                    inputs_testBruel(start:stop,c_test)=...
                        bufBruel(startB:(startB+lb-1),s1);    
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputs_testBruel(:,c_test)=[];%удаление столбца целиком
                %targets_testBruel(:,c_test)=[];
                c_test=c_test-1;%откат номера
            end
        end
        
        case "train"
        for j=1:n %номер кадра
            if n > maxnum
                s1=randi(maxnum);% случайный столбец из вотерфола
            else
                s1=rand_numbers(j);
            end
            r=0;
            c=c+1;%счетчик номера столбца м-цы inputs
            for k=1:length(NmeasBruel)%номер типа измерений
                if NmeasBruel(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*lb;
                    stop=start+lb-1;
                    startB=(1+lb*(k-1));
                    inputsBruel(start:stop,c)=...
                        bufBruel(startB:(startB+lb-1),s1);    
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputsBruel(:,c)=[];%удаление столбца целиком
                %targetsBruel(:,c)=[];
                c=c-1;%откат номера
            end
        end
    end    
end
cd (saveDir)
end

