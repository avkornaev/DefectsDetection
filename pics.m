function pics(inputs_train, inputs_test, inputs_val, targets_train, targets_test, targets_val)

mkdir('pics/train')
mkdir('pics/test')
mkdir('pics/val')

n=64;
pic_width = floor(size(inputs_train, 1) / 8);
figure('Color','w', 'position',[1 1 120 120])
for i = 1:size(inputs_train,2)
    set(gcf, 'Visible', 'on', 'position',[1 1 120 120]);
    surf([inputs_train(1:pic_width,i) inputs_train(pic_width*1+1:pic_width*1+pic_width,i) inputs_train(pic_width*2+1:pic_width*2+pic_width,i) inputs_train(pic_width*3+1:pic_width*3+pic_width,i) inputs_train(pic_width*4+1:pic_width*4+pic_width,i) inputs_train(pic_width*5+1:pic_width*5+pic_width,i) inputs_train(pic_width*6+1:pic_width*6+pic_width,i) inputs_train(pic_width*7+1:pic_width*7+pic_width,i)], 'EdgeColor', 'none', 'FaceColor', 'interp');
    view(0,90);
    colormap(colorcube);
    axis([1 8 1 pic_width min(min(inputs_train)) max(max(inputs_train))]);
    caxis([ min(min(inputs_train)) max(max(inputs_train))])
    axis off;
    hgexport(gcf, ['pics/train/',num2str(i),'.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
end


figure('Color','w', 'position',[1 1 120 120])
for i = 1:size(inputs_test,2)
    set(gcf, 'Visible', 'on', 'position',[1 1 120 120]);
    surf([inputs_test(1:pic_width,i) inputs_test(pic_width*1+1:pic_width*1+pic_width,i) inputs_test(pic_width*2+1:pic_width*2+pic_width,i) inputs_test(pic_width*3+1:pic_width*3+pic_width,i) inputs_test(pic_width*4+1:pic_width*4+pic_width,i) inputs_test(pic_width*5+1:pic_width*5+pic_width,i) inputs_test(pic_width*6+1:pic_width*6+pic_width,i) inputs_test(pic_width*7+1:pic_width*7+pic_width,i)], 'EdgeColor', 'none', 'FaceColor', 'interp');
    view(0,90);
    colormap(colorcube);
    axis([1 8 1 pic_width min(min(inputs_train)) max(max(inputs_train))]);
    caxis([ min(min(inputs_train)) max(max(inputs_train))])
    axis off;
    hgexport(gcf, ['pics/test/',num2str(i),'.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
end

figure('Color','w', 'position',[1 1 120 120])
for i = 1:size(inputs_val,2)
    set(gcf, 'Visible', 'on', 'position',[1 1 120 120]);
    surf([inputs_val(1:pic_width,i) inputs_val(pic_width*1+1:pic_width*1+pic_width,i) inputs_val(pic_width*2+1:pic_width*2+pic_width,i) inputs_val(pic_width*3+1:pic_width*3+pic_width,i) inputs_val(pic_width*4+1:pic_width*4+pic_width,i) inputs_val(pic_width*5+1:pic_width*5+pic_width,i) inputs_val(pic_width*6+1:pic_width*6+pic_width,i) inputs_val(pic_width*7+1:pic_width*7+pic_width,i)], 'EdgeColor', 'none', 'FaceColor', 'interp');
    view(0,90);
    colormap(colorcube);
    axis([1 8 1 pic_width min(min(inputs_train)) max(max(inputs_train))]);
    caxis([ min(min(inputs_train)) max(max(inputs_train))])
    axis off;
    hgexport(gcf, ['pics/val/',num2str(i),'.jpg'], hgexport('factorystyle'), 'Format', 'jpeg');
end

inputs_pics_train = zeros(size(inputs_train,2),n,n,3);

for i=1:size(inputs_train,2)
    I=imread(['pics/train/',num2str(i),'.jpg']);
    GI = I(9:103,16:108,:);
    GI = imresize(GI,[n n]);
    GI = im2double(GI);
    GIv=reshape(GI,n*n*3, 1);
    inputs_pics_train(i,:,:,:) = GI;
end

inputs_pics_test = zeros(size(inputs_test,2),n,n,3);

for i=1:size(inputs_test,2)
    I=imread(['pics/test/',num2str(i),'.jpg']);
    GI = I(9:103,16:108,:);
    GI = imresize(GI,[n n]);
    GI = im2double(GI);
    GIv=reshape(GI,n*n*3, 1);
    inputs_pics_test(i,:,:,:) = GI;
end

inputs_pics_val = zeros(size(inputs_val,2),n,n,3);

for i=1:size(inputs_val,2)
    I=imread(['pics/val/',num2str(i),'.jpg']);
    GI = I(9:103,16:108,:);
    GI = imresize(GI,[n n]);
    GI = im2double(GI);
    GIv=reshape(GI,n*n*3, 1);
    inputs_pics_val(i,:,:,:) = GI;
end

save('pics/inputs_pics_train.mat', 'inputs_pics_train');
save('pics/inputs_pics_test.mat', 'inputs_pics_test');
save('pics/inputs_pics_val.mat', 'inputs_pics_val');
save('pics/targets_train.mat', 'targets_train');
save('pics/targets_test.mat', 'targets_test');
save('pics/targets_val.mat', 'targets_val');

end