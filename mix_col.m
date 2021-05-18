function [inputs,targets]=mix_col(inputs,targets)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

s=size(targets);
idx=randperm(s(2));
inputs(:,1:end)=inputs(:,idx);
targets(:,1:end)=targets(:,idx);
end

