function [G, gaussian_table]= createGaussianTable1(X,sigma)
%   This function is used to create the gaussian table 
%
%   The gaussian table is a F x M matrix 
%       -   each of the matrix's column represents a local maximum 
%           point multiplied by the gaussian kernel 
%       
%           -   the gaussian kernel function is defined as 
%                       G(f, l_m)= exp(-0.5 x {{{f-l_m} over {f_sd}}^{2}}
%
%   The gaussian table is calculated as follows 
%               gaussian_table(f,m) =rho(m) x G(f,l_m)
%   where 
%       rho(m)  :   the value of the local maximum point
%       f       :   1,2,..., F 
%       m       :   1,2,..., M 
%
%   Input:: 
%       X 
%       sigma 
%   Output:: 
%       G 
%       gaussian_table 

    if nargin<2
        sigma=30; 
    end 
    
    %   compute the local maximum points of X 
    rho=getLocalMaxima1(X); 
    
    %   create the gaussian kernel 
    for f=1:length(X)
        for m=1:length(rho)
            
            G(m,f)= exp(-0.5 * (( (f-m)/sigma)^2));
            
        end 
    end 
    
    %   create the gaussian table 
    for i=1:length(X)
        
        for m=1:length(rho)
            gaussian_table(f,m)=rho(m)*G(f,m);
        end 
    end 
    
    
    
end 