function [inputs_test,targets_test,inputs_val,targets_val] =...
    val_set_extraction(inputs_test,targets_test,nval,n)
%Подпрограмма извлечения части данных тестирования для валидации
%Матрицы для тестирования просто обворовываются,из них извлекаются пачки по
%"n" cтолбцов, соответствующие случайному опыту. 

%Копирование
inputs_test0=inputs_test;
targets_test0=targets_test; 
%Заготовки
Nexp=size(targets_test,1);
inputs_val=zeros(size(inputs_test,1),nval*n);
targets_val=zeros(size(targets_test,1),nval*n);

%Извлечение
for nv=1:nval*Nexp
    s=(nv-1)*n+1;
    s1=s+n-1;
    N0=size(targets_test0,2)/n;%фактическое количество опытов в датасете
    k=randi([1 N0],1,1);%сл. номер блока для извлечения
    startp=(k-1)*n+1;
    stopp=startp+n-1;
    inputs_val(:,s:s1) = inputs_test0(:,startp:stopp);
    targets_val(:,s:s1)=targets_test0(:,startp:stopp);
    inputs_test0(:,startp:stopp)=[];
    targets_test0(:,startp:stopp)=[];
end
%Переприсвоение
inputs_test=inputs_test0;
targets_test=targets_test0; 
end

