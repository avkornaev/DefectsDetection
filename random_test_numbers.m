function [Ntest,Nval]=random_test_numbers(Nexp,Npar,ntest,nval)
%random_test_numbers ������������ ��������� ������� ��������� �������
%������, ������� ����� ������������ ��� ������������ � ��������� ���
Ntest=zeros(Nexp,ntest);Nval=zeros(Nexp,nval);%��������� ������

order=randperm(Npar);
for i=1:Nexp
    Ntest(i,:)= order(1:ntest)+(i-1)*Npar;
    Nval(i,:) = order((ntest+1):(ntest+nval))+(i-1)*Npar;
end
%Ntest(1)=[];Nval(1)=[];%�������� �������� ��������

% 
% for i=1:Nexp
%     q=(i-1)*Npar;
%     for j=1:Nexcl
%         Ntest0=randi([1+q Npar+q],1,1);
%         while sum(Ntest0==Ntest)
%             Ntest0=randi([1+q Npar+q],1,1);
%         end
%         Ntest=[Ntest Ntest0];
%     end
%     %Ntest0=randi([1+q Npar+q],1,Nexcl);
%     %Ntest=[Ntest Ntest0];
% end
% Ntest(:,1)=[];%�������� �������� ��������
% 
% %Check
% s=0;
% for k=1:length(Ntest)
%     s=s+sum(Ntest(k)==Ntest)-1;
% end
% if s>0
%     warning 'The numbers of tests in Ntest matrix can be repeating, since the built-in randi() function is used.' 
% end
% end

