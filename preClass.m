function [inp_new, targ_new,m]=preClass(inputs,targets)

id_met=1;  %1 - евклидова норма; %2 - Расстояние Чебышева po=max_i(|xi-x0i|);
%3 - манхэттенское расстояние; %4 - Степенное расстояние

K=2;
[inputs,targets,n1] = format_data(inputs,targets,K);
Iter=10;
C=10; %кол-во случайных инициализаций начальных центов
m(1)=0;
for i=1:2
    X=inputs((i-1)*n1(1)+1:n1(1)+(i-1)*n1(2),:);
    Y=targets((i-1)*n1(1)+1:n1(1)+(i-1)*n1(2),:);  %по какому эксперменту отсеивание
    n=length(Y);
    [ind] = Clusterisation(X,id_met,n,K,C,Iter);
    [X1,Y1] = filtr_data(ind,X,Y);
    m(i+1)=length(Y1);
    inp_new((i-1)*m(i)+1:m(i+1)+(i-1)*m(i),:)=X1;
    targ_new((i-1)*m(i)+1:m(i+1)+(i-1)*m(i),:)=Y1;
    clear X Y X1 Y1
end   
%  inp_new=inp_new';
%  targ_new=targ_new';
end