function [inputs_test,targets_test,inputs_val,targets_val] =...
    val_set_extraction(inputs_test,targets_test,nval,n)
%������������ ���������� ����� ������ ������������ ��� ���������
%������� ��� ������������ ������ ��������������,�� ��� ����������� ����� ��
%"n" c�������, ��������������� ���������� �����. 

%�����������
inputs_test0=inputs_test;
targets_test0=targets_test; 
%���������
Nexp=size(targets_test,1);
inputs_val=zeros(size(inputs_test,1),nval*n);
targets_val=zeros(size(targets_test,1),nval*n);

%����������
for nv=1:nval*Nexp
    s=(nv-1)*n+1;
    s1=s+n-1;
    N0=size(targets_test0,2)/n;%����������� ���������� ������ � ��������
    k=randi([1 N0],1,1);%��. ����� ����� ��� ����������
    startp=(k-1)*n+1;
    stopp=startp+n-1;
    inputs_val(:,s:s1) = inputs_test0(:,startp:stopp);
    targets_val(:,s:s1)=targets_test0(:,startp:stopp);
    inputs_test0(:,startp:stopp)=[];
    targets_test0(:,startp:stopp)=[];
end
%��������������
inputs_test=inputs_test0;
targets_test=targets_test0; 
end

