function [X_new,Y_new] = filtr_data(ind,X,Y)
   n=length(ind);
    if sum(ind==1)<=sum(ind==2)        
        j=0;
        for i=1:n            
            if ind(i,1)==2
                j=j+1;
                X_new(j,:)=X(i,:);  
                Y_new(j,:)=Y(i,:);
            end
        end        
    else
        j=0;
        for i=1:n            
            if ind(i,1)==1
                j=j+1;
                X_new(j,:)=X(i,:); 
                Y_new(j,:)=Y(i,:);
            end
        end   
    end

end