function sparseCoefficientMatrix = CalculateTheAudioClipsSparseCoefficientMatrix(audioFrames, D, varargin)
%
%   Input:: 
%       audioFrames 
%       D 
%
%       numberOfSparseCoefficients 
%       epsilon 
%       errorFunction 
%       Options 
%
%   Output:: 
%       sparseCoefficientMatrix 

    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= randi(size(D,2)); 
    end 
    numberOfSparseCoefficients = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= eps; 
    end 
    epsilon = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= []; 
    end 
    errorFunction = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= []; 
    end
    Options= varargin{4}; 
    
    X=audioFrames; 
    
    sparseCoefficientMatrix=zeros(size(D,2), size(X,2)); 
    for i = 1:size(audioFrames,2)
        sparseCoefficientMatrix(:,i) = OMP(X(:,i), D, numberOfSparseCoefficients, epsilon , errorFunction, Options); 
    end 



end 