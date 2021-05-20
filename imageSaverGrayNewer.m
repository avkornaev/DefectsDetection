function imageSaverNewer(l,inputs,targets,classes,saveSubDir)
%��������� � ���������� ����������� � ������� �� ������� �-� inputs

%��������������� ��������
n=size(inputs);
%picSize=ones(1,2)*ceil(sqrt(n(1)));%������ �����. >= ��.����� ���-�� �����.
picSize=[l,ceil(n(1)/l)];%������ �����.
cd DataSet %������� � ����� ��������
currentClassNo=1;%��������� ��������
ar0=zeros(picSize(1)*picSize(2),1);%��������� �������
cd (classes(currentClassNo))%����� ��� 1 ������

for i=1:n(2)%���� �� ������� ��������
    [M, I]=max(targets(:,i));%����������� ������ �� �-�� �����
    newClassNo=I;
    %���������� �������� ������ ������
    ar=ar0;
    ar(1:n(1))=inputs(:,i);
    %������������ �����������
    Im=reshape(ar,picSize);%
    %I = mat2gray(mat,range);
    %imshow(Im)
    %colormap default
    %����� ���������� (���� ����������) ��� ���������� 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd (classes(currentClassNo))
    end
    %saveas(h,(['data',num2str(i)]),'jpg')
    imwrite(Im,(['data',num2str(i),'.jpg']))
    
end
cd (saveSubDir)%������� � ����� ��������
end

