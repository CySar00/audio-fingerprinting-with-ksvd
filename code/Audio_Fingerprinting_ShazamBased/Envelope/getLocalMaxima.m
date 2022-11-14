function [rho,rho1] = getLocalMaxima(a)
%   This funcion is used to identify the local maximum points 
%
%   Identifying the local maximum points 
%       If the f-th data point of the vector a, a_f is higher that it's two
%       neighbor data points (a_{f+1}, a_{f-1}) then it's will be treated
%       as a local maximum point 
%
%   Input:: 
%       a       :
%   Output::
%       rho     :

    %   convert the vector a to a row 
    a = a(:)';

    %   find the local maximum points of a
    number_of_bins = [a,a(end)]>= [a(1),a]; 
    
    rho = a.*number_of_bins(1:end-1).*(1- number_of_bins(2:end)); 
    
    rho1 =zeros(size(a)); 
    
    for i= 1 : length(a)-1
        
        if i==1
            
            if a(i)> a(i+1)
                rho1(i)=a(i); 
            end 
            
        elseif i>1 
       
            if a(i)> a(i+1) && a(i)>a(i-1)
                rho1(i)=a(i); 
            end 
            
        end 
        
        
    end 
    
    
    
end 