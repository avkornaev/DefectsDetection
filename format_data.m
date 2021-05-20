function [inp,targ,n1] = format_data(inp,targ,K)
inp=inp';
targ=targ';
n=length(targ);
for i=1:K
    n1(i)=sum(targ(:,i)==1);
end

end