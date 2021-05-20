clear
clc
%Image preprocessor
nc=2
%Short intro: Data types in MATLAB
%a=100;%scalar variable
%x=linspace(0,1,a);y=sin(x);plot(x,y,'-r')%function
%A=[1 2 3; 4 5 6; 7 8 9];%matrix variable
 %A(1,1)
%h=180;w=80;z="scorpio" 
%s=struct('height',h,'weight',w,'zodiac',z)
 %s.weight
 
%% 0.Parameters 
classes=["normal","pneumonia"];
N=length(classes);%number of classes
noOfImg=inf;%inf;%number of images or inf (inf means all files in a folder)
imDir="test"
nc=2;%number of clusters
ncr=[3,3];%image cropping by ncr subimages
imageSize=[30 30 3];
clustering="on"
%% 1. Directory
%Current directory
cd 'F:\study\Kaggle\Chest X-Ray Images'
saveDir = cd;

%Initial images DataSet folder
cd (imDir)
saveSubDir0=cd;%subdirectory for images given
cd(saveDir)%comeback

%Processed images DataSet folder 
mkdir ("DataSet")%create folder
cd DataSet
saveSubDir=cd;%subdirectory for images saving
%Create new subfolders for clustered images named as classes
for k=1:N 
        mkdir (classes(k))
end
cd(saveDir)%comeback

%% 2. Images clustering 
% want to learn more on https://www.mathworks.com/help/images/ref/imsegkmeans.html
for k=1:N
    %Chagne directory, read content of the folder and comeback
    cd (imDir)
    cd (classes(k))
    dirlist = dir;%read content of current folder
    cd(saveDir)%comeback
    
    if noOfImg==inf
        n=length(dirlist)
    end
    idx = randperm(length(dirlist),n);%random numbers
    
    for j=1:n
        cd (imDir)
        cd (classes(k))
        %Read file name and file size
        fsize = dirlist(idx(j)).bytes;
        fname = dirlist(idx(j)).name;
        
        if fsize > 0
            %Dowload image
            img=imread(fname);

            if clustering == "on"
                % Clusterisation
                L=imsegkmeans(img,nc);
                B=labeloverlay(img,L);
            else
                %Imitation of 3 layers
                if size(img,3)~=3
                    B=cat(3,img,img,img);
                end
            end
            
            B = imresize(B, imageSize(1:2).*ncr);%resize image

            cd (saveSubDir0)%comeback 
            %Change directory
            cd (saveDir)
            cd DataSet
            cd (classes(k))
                
%           %Save clustered image
%           imwrite(B,(fname))
            
            %Save clustered and cropped image
            count=0;
            width=floor(size(B,1)/ncr(1));
            higth=floor(size(B,2)/ncr(2));
            for k1=1:ncr(1)
                for k2=1:ncr(2)
                    count=count+1;
                    start1=1+(k1-1)*width;
                    start2=1+(k2-1)*higth;
                    subB=B(start1:(start1+width-1),start2:(start2+higth-1),:);
                    imwrite(subB,([num2str(k) '-' fname(1:(end-5)) '-' num2str(count) '.jpeg']))
                    %RGB=imread([num2str(i),'.jpg']);
                
                end
            end
    
        end
        cd (saveDir)%comback
    end
end
                    
