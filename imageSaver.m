function imageSaver(inputs,targets,classes,saveSubDir)
%��������� � ���������� ����������� � ������� �� ������� �-� inputs
h=figure('Color','w');
%��������������� ��������
n=size(inputs);
picSize=ones(1,2)*ceil(sqrt(n(1)));%������ �����. >= ��.����� ���-�� �����.
cd DataSet %������� � ����� ��������
currentClassNo=1;%��������� ��������
ar0=zeros(picSize(1)^2,1);%��������� �������
cd (classes(currentClassNo))%����� ��� 1 ������

for i=1:n(2)%���� �� ������� ��������
    [M, I]=max(targets(:,i));%����������� ������ �� �-�� �����
    newClassNo=I;
    %���������� �������� ������ ������
    ar=ar0;
    ar(1:n(1))=inputs(:,i);
    %������������ �����������
    Im=reshape(ar,picSize);%
    imshow(Im)
    colormap default
    %����� ���������� (���� ����������) ��� ���������� 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd (classes(currentClassNo))
    end
    saveas(h,(['data',num2str(i)]),'jpg')
    
end
cd (saveSubDir)%������� � ����� ��������
end

