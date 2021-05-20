function [Mu]=Centroid(X,ind,K)
    
    [n,m]=size(ind);
    for j=1:K
        S=zeros(1,m);
        q=0;
        for i=1:n
            if j==ind(i,1)
                    S=S+X(i,:);
                    q=q+1;
            end
        end
        Mu(j,:)=S/q;
    end
    
end