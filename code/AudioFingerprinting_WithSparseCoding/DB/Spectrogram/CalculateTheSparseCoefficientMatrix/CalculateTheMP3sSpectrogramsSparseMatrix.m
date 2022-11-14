function SparseCoefficientMatrix = CalculateTheMP3sSpectrogramsSparseMatrix( mp3_Title, magnitudes, D, varargin)
%
%   Input:: 
%       mp3_Title 
%       magnitudes 
%       D 
%
%       numberOfSparseCoefficients 
%       epsilon 
%       errorFunction 
%       Options 
%
%   Output:: 
%       SparseCoeffcientMatrix

    lengthOfVarargin = length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= randi(size(D,2)); 
    end 
    numberOfSparseCoefficients = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= eps;
    end 
    epsilon=varargin{2}; 
    
    if lengthOfVarargin<3
        varargin{3}= []; 
    end 
    errorFunction = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}=[]; 
    end 
    Options = varargin{4}; 
    
    SparseCoefficientMatrix=cell(2,1); 
    
    X=magnitudes; 
    
    Y=zeros(size(D,2), size(magnitudes,2));
    for i=1:size(magnitudes,2)
        i
        Y(:,i)= OMP(X(:,i), D, numberOfSparseCoefficients, epsilon, errorFunction, Options); 
    end 
    
    SparseCoefficientMatrix{1}= mp3_Title;
    SparseCoefficientMatrix{2}= Y; 



end 