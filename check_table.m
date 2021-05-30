clear
clc
a=[1 2 3 ; 4 5 6; 7 8 9; 10 11 12];
b=categorical([1 2 3 4 ]');

n= size(a)
tbl=table(a(:,1),'VariableNames',{'Var1'})
for i=2:n(2)
    tbl=[tbl table(a(:,i),'VariableNames',{['Var',num2str(i)]}) ]
end
tbl=[tbl table(b,'VariableNames',{'Targets'})]
% measurements=a;
% diagnosis=b;
% 
% n=size(a);
% 
% tbl=table(measurements,diagnosis)