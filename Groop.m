function [ind]=Groop(X,Mu,K,id_met)

    [n,m]=size(X);
    if id_met==1
        for i=1:n
            for j=1:K            
                d(j,1)=0;
                for p=1:m                
                    d(j,1)=d(j,1)+(X(i,p)-Mu(j,p))^2;
                end
    %               d(j,1)=d(j,1)^0.5;                
            end     
            [dm,ind(i,1)]=min(d);            
        end
    end
    
	if id_met==2
        for i=1:n
            for j=1:K            
                d(j,1)=max(abs(X(i,:)-Mu(j,:)));%po=max_i(|xi-x0i|)              
            end          
            [dm,ind(i,1)]=min(d);
         end
    end
    
	if id_met==3
        for i=1:n
            for j=1:K            
                d(j,1)=0;
                for p=1:m                
                    d(j,1)=d(j,1)+abs(X(i,p)-Mu(j,p));
                end    
            end     
            [dm,ind(i,1)]=min(d);            
        end
    end
    
	if id_met==4
        pn=2; pr=3;
        for i=1:n
            for j=1:K            
                d(j,1)=0;
                for p=1:m                
                    d(j,1)=d(j,1)+(X(i,p)-Mu(j,p))^pn;
                end
                d(j,1)=d(j,1)^(1/pr);                
            end     
            [dm,ind(i,1)]=min(d);            
        end
    end

end