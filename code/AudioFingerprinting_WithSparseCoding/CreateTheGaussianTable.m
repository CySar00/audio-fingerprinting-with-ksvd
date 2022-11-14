function gaussianTable = CreateTheGaussianTable(X, sigma)
%
%   Input:: 
%       X 
%       sigma 
%
%   Output:: 
%       gaussianTable 

    if nargin<2 
        sigma = 30; 
    end 
    
    [rho, lambda]= FindTheLocalMaximasOfTheVector(X); 
    
    numberOfFrequencyBins = length(X); 
    numberOfLocalMaximas = length(lambda);
    
    G= zeros( numberOfFrequencyBins, numberOfLocalMaximas); 
    for f= 1: numberOfFrequencyBins 
        for m=1:numberOfLocalMaximas 
            G(f,m)= exp(-0.5*( (f-lambda(m))/sigma)^2); 
        end 
    end 
    
    gaussianTable =zeros(size(G)); 
    for m=1:numberOfLocalMaximas
        gaussianTable(:,m) = rho(m)*G(:,m);
    end 
end 