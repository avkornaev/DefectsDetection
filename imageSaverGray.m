function imageSaver(inputs,targets,folder,classes,saveSubDir,imDim)
%��������� � ���������� ����������� � ������� �� ������� �-� inputs

%��������������� ��������
n=size(inputs);
picSize=ones(1,2)*ceil(sqrt(n(1)));%������ �����. >= ��.����� ���-�� �����.
cd DataSet %������� � ����� �������
cd(folder)%path to train, val, or test folder
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
    
%     imwrite(Im,'img.jpeg');
%     Im=[];
%     img=imread('img.jpeg');
%     
%     %Clustering
%     L=imsegkmeans(img,nc);
%     Im=labeloverlay(img,L);
%     Im(:,:,1)=Im(:,:,1)+0.3;
    
    %I = mat2gray(mat,range);
%     imshow(Im)
    %colormap default
    %����� ���������� (���� ����������) ��� ���������� 
    if newClassNo~=currentClassNo
        currentClassNo=newClassNo;
        cd (saveSubDir)
        cd(folder)
        cd (classes(currentClassNo))
    end
    %saveas(h,(['data',num2str(i)]),'jpg')
    imwrite(Im,(['data',num2str(i),'.jpeg']))
    
end
cd (saveSubDir)%������� � ����� ��������
end

