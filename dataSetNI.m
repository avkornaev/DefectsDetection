function [inputs,targets,inputs_test,targets_test,inputs_val,targets_val]=...
    dataSetNI(Nexp,Npar,Nexcl,Ntest,Nval,Ndef,n,l,Nmeas,ns,fr,DR,MinVals,DeltaVals,saveDir)
%ПОДПРОГРАММА ФОРМИРОВАНИЯ ЧАСТИ ДАТАСЕТА ПО ДАННЫМ ШАССИ NI
cd DataSet

%Заготовки матриц для обучения ИНС
inputs=zeros(sum(Nmeas)*l,n*Nexp*(Npar-Nexcl));%
targets=zeros(Nexp,n*Nexp*(Npar-Nexcl));%
%Заготовки матриц для тестирования ИНС
inputs_test=zeros(sum(Nmeas)*l,n*size(Ntest,1)*size(Ntest,2));%
targets_test=zeros(Nexp,n*size(Ntest,1)*size(Ntest,2));%
%Заготовки матриц для валидации ИНС
inputs_val=zeros(sum(Nmeas)*l,n*size(Nval,1)*size(Nval,2));%
targets_val=zeros(Nexp,n*size(Nval,1)*size(Nval,2));%

size(inputs_val)
size(targets_val)
%Заполнение матриц
%Матрицы targets, targets_test, targets_val для упорядоченного плана эксп. заполн.просто
for i=1:Nexp
    
    start=1+((i-1)*n*(Npar-Nexcl));
    stop=start+(n*(Npar-Nexcl))-1;
    targets(i,start:stop)=1;
    
    start=1+((i-1)*n*size(Ntest,2));
    stop=start+(n*size(Ntest,2))-1;
    targets_test(i,start:stop)=1;
    
    start=1+((i-1)*n*size(Nval,2));
    stop=start+(n*size(Nval,2))-1;
    targets_val(i,start:stop)=1;
    
end

if ns == 2 %переписывание матриц для 2 классов
    targets(1,1:(n*(Npar-Nexcl)))=1;
    targets(2,(n*(Npar-Nexcl))+1:end)=1;
    targets(3:end,:)=[];
    
    targets_test(1,1:n*size(Ntest,2))=1;
    targets_test(2,n*size(Ntest,2)+1:end)=1;
    targets_test(3:end,:)=[];

    targets_val(1,1:n*size(Nval,2))=1;
    targets_val(2,n*size(Nval,2)+1:end)=1;
    targets_val(3:end,:)=[];
end

%Матрицы inputs, inputs_test, inputs_val
c=0;c_test=0;c_val=0;i=0;
for i=1:Nexp*Npar %номер опыта
    ic=i;
    load (['saved',num2str(i)])
    %Проверка условия построения АЧХ
    if fr==1
        [f1,A1]=AmpFreqResp(PPGreen,rate,LF);
        %Обрезка первых значений (амплитуды условно бесконечны)
        A1(1)=[];%A2(1)=[];
        f1(1)=[];%f2(1)=[];
        PPGreen=A1;
        l=length(f1);
    end
    %Проверка условия взятия фрагментов данных или полных данных    
    if DR==0
        buf=([CRRSm;FCout; PPGreen; PPGreenSm;...
            PPOrange; PPOrangeSm;...
            Pressure; pSm]'-MinVals')./DeltaVals';
    else
        buf=([CRRSm(DR(1):DR(2)); FCout(DR(1):DR(2)); PPGreen(DR(1):DR(2));...
            PPGreenSm(DR(1):DR(2)); PPOrange(DR(1):DR(2));...
            PPOrangeSm(DR(1):DR(2));Pressure(DR(1):DR(2));...
            pSm(DR(1):DR(2))]'-MinVals')./DeltaVals';
    end
    Lf=size(buf,1);
    
    testID="train";
    if sum(sum(ic==Ntest))>0
        testID="test";
    end
    if sum(sum(ic==Nval))>0
        testID="val";
    end
    
    switch testID
        
        case "val"
        for j=1:n %номер кадра
            s1=randi(Lf-l);%(Lf-l)- диап.начальной точки кадра
            r=0;
            c_val=c_val+1;%счетчик номера столбца м-цы inputs
            for k=1:length(Nmeas)%номер типа измерений
                if Nmeas(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*l;
                    stop=start+l-1;
                    inputs_val(start:stop,c_val)=(buf(s1:(s1+l-1),k));
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputs_val(:,c_val)=[];%удаление столбца целиком
                targets_val(:,c_val)=[];
                c_val=c_val-1;%откат номера
            end
        end
        
        case "test"
        for j=1:n %номер кадра
            s1=randi(Lf-l);%(Lf-l)- диап.начальной точки кадра
            r=0;
            c_test=c_test+1;%счетчик номера столбца м-цы inputs
            for k=1:length(Nmeas)%номер типа измерений
                if Nmeas(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*l;
                    stop=start+l-1;
                    inputs_test(start:stop,c_test)=(buf(s1:(s1+l-1),k));
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputs_test(:,c_test)=[];%удаление столбца целиком
                targets_test(:,c_test)=[];
                c_test=c_test-1;%откат номера
            end
        end
        case "train"
        for j=1:n %номер кадра
            s1=randi(Lf-l);%(Lf-l)- диап.начальной точки кадра
            r=0;
            c=c+1;%счетчик номера столбца м-цы inputs
            for k=1:length(Nmeas)%номер типа измерений
                if Nmeas(k)~=0
                    r=r+1;%счетчик номера использ. измер
                    start=1+(r-1)*l;
                    stop=start+l-1;
                    inputs(start:stop,c)=buf(s1:(s1+l-1),k);    
                end
            end
            %А теперь удаление, если тест дефектный
            if sum(ic==Ndef)>0
                inputs(:,c)=[];%удаление столбца целиком
                targets(:,c)=[];
                c=c-1;%откат номера
            end
        end
    end
end
cd (saveDir)
end