function pics_rgb(inputs_train, inputs_test, inputs_val, targets_train, targets_test, targets_val)

mkdir('pics_rgb/train')
mkdir('pics_rgb/test')
mkdir('pics_rgb/val')

n_sens = size(inputs_train,1) / 3;
n = sqrt(n_sens);

temp1 = min(min(inputs_train(1:n_sens,:)));
temp2 = min(min(inputs_train(n_sens*1+1:n_sens*1+n_sens,:)));
temp3 = min(min(inputs_train(n_sens*2+1:n_sens*2+n_sens,:)));

inputs_train(1:n_sens,:) = (inputs_train(1:n_sens,:) ./ temp1);
inputs_val(1:n_sens,:) = (inputs_val(1:n_sens,:) ./ temp1);
inputs_test(1:n_sens,:) = (inputs_test(1:n_sens,:) ./ temp1);

inputs_train(n_sens*1+1:n_sens*1+n_sens,:) = (inputs_train(n_sens*1+1:n_sens*1+n_sens,:) ./ temp2);
inputs_val(n_sens*1+1:n_sens*1+n_sens,:) = (inputs_val(n_sens*1+1:n_sens*1+n_sens,:) ./ temp2);
inputs_test(n_sens*1+1:n_sens*1+n_sens,:) = (inputs_test(n_sens*1+1:n_sens*1+n_sens,:) ./ temp2);

inputs_train(n_sens*2+1:n_sens*2+n_sens,:) = (inputs_train(n_sens*2+1:n_sens*2+n_sens,:) ./ temp3);
inputs_val(n_sens*2+1:n_sens*2+n_sens,:) = (inputs_val(n_sens*2+1:n_sens*2+n_sens,:) ./ temp3);
inputs_test(n_sens*2+1:n_sens*2+n_sens,:) = (inputs_test(n_sens*2+1:n_sens*2+n_sens,:) ./ temp3);

inputs_pics_rgb_train = zeros(size(inputs_train, 2),n,n,3);
figure()
for i=1:size(inputs_train, 2)
    a = reshape(inputs_train(1:n*n,i),n,n);
    b = reshape(inputs_train(n*n+1:n*n*2,i),n,n);
    c = reshape(inputs_train(n*n*2+1:n*n*3,i),n,n);
    img = zeros(n,n,3);
    img(:,:,1) = a;
    img(:,:,2) = b;
    img(:,:,3) = c;
    inputs_pics_rgb_train(i,:,:,:) = img;
    imshow(img)
end

inputs_pics_rgb_test = zeros(size(inputs_test, 2),n,n,3);

for i=1:size(inputs_test, 2)
    a = reshape(inputs_test(1:n*n,i),n,n);
    b = reshape(inputs_test(n*n+1:n*n*2,i),n,n);
    c = reshape(inputs_test(n*n*2+1:n*n*3,i),n,n);
    img = zeros(n,n,3);
    img(:,:,1) = a;
    img(:,:,2) = b;
    img(:,:,3) = c;
    inputs_pics_rgb_test(i,:,:,:) = img;
    imshow(img)
end

inputs_pics_rgb_val = zeros(size(inputs_val, 2),n,n,3);

for i=1:size(inputs_val, 2)
    a = reshape(inputs_val(1:n*n,i),n,n);
    b = reshape(inputs_val(n*n+1:n*n*2,i),n,n);
    c = reshape(inputs_val(n*n*2+1:n*n*3,i),n,n);
    img = zeros(n,n,3);
    img(:,:,1) = a;
    img(:,:,2) = b;
    img(:,:,3) = c;
    inputs_pics_rgb_val(i,:,:,:) = img;
    imshow(img)
end

save('pics_rgb/inputs_pics_rgb_train.mat', 'inputs_pics_rgb_train');
save('pics_rgb/inputs_pics_rgb_test.mat', 'inputs_pics_rgb_test');
save('pics_rgb/inputs_pics_rgb_val.mat', 'inputs_pics_rgb_val');
save('pics_rgb/targets_train.mat', 'targets_train');
save('pics_rgb/targets_test.mat', 'targets_test');
save('pics_rgb/targets_val.mat', 'targets_val');

end