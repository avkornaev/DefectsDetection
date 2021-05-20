function [J]=Costfunc(X,ind,Mu,K,id_met)
    [n,m]=size(X);%n - кол-во опытов; %m - кол-во признаков

    J=0;
    if id_met==1
        for k=1:K
            S=0;
            for i=1:n
                if k==ind(i)
                    for p=1:m
                       S=S+(X(i,p)-Mu(k,p))^2;                    
                    end            
                end
%                 S=S^0.5;
            end        
        J=J+S;
        end
    end
  
    if id_met==2
        for k=1:K           
            for i=1:n
                if k==ind(i)
                       J=J+max(abs(X(i,:)-Mu(k,:)));%po=max_i(|xi-x0i|)                  
                end
            end        
        end
    end
    
    if id_met==3
        for k=1:K
            S=0;
            for i=1:n
                if k==ind(i)
                    for p=1:m
                       S=S+abs(X(i,p)-Mu(k,p));                    
                    end            
                end
            end        
        J=J+S;
        end
    end
    
    if id_met==4
        pn=2;pr=3;
        for k=1:K
            S=0;
            for i=1:n
                if k==ind(i)
                    for p=1:m
                       S=S+(X(i,p)-Mu(k,p))^pn;                    
                    end            
                end
                J=J+S^(1/pr);
            end                
        end
    end
end