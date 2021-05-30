function [layers] = mlp(numFeatures,hiddenLayerSize,numClasses)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
layers = [
    featureInputLayer(numFeatures,'Normalization', 'zscore',"Name","input")
    fullyConnectedLayer(hiddenLayerSize,"Name","fc_2")
    batchNormalizationLayer("Name","batchnorm_1")
    reluLayer("Name","relu_1")
    fullyConnectedLayer(hiddenLayerSize,"Name","fc_3")
    batchNormalizationLayer("Name","batchnorm_2")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(hiddenLayerSize,"Name","fc_4")
    batchNormalizationLayer("Name","batchnorm_3")
    reluLayer("Name","relu_3")
    fullyConnectedLayer(hiddenLayerSize,"Name","fc_5")
    batchNormalizationLayer("Name","batchnorm_4")
    reluLayer("Name","relu_4")
    fullyConnectedLayer(numClasses,"Name","fc_1")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classification")];
end

