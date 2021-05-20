function [ind_rez,Mu_rez] = Clusterisation(X,id_met,n,K,C,Iter)
    Cost=1e+15;
    for c=1:C
        num=randperm(n);
        %для 2х кластеров K(1)
        Mu=X(num(1:K),:);  
         for i=1:Iter   
                [ind]=Groop(X,Mu,K,id_met);
                [Mu]=Centroid(X,ind,K);
                [J(i,c)]=Costfunc(X,ind,Mu,K,id_met);
                if J(i,c)<Cost
                    Mu_rez=Mu;
                    ind_rez=ind;
                    Cost=J(i,c);
                end            
         end
    end
    
end