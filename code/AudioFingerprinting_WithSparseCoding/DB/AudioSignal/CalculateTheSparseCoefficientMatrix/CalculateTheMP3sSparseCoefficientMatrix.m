function SparseCoefficientMatrix = CalculateTheMP3sSparseCoefficientMatrix(AudioFrames, D, varargin)
%
%   Input:: 
%       SparseCoefficientMarix   
%       D 
%
%       numberOfSparseCoefficients 
%       epsilon 
%
%       errorFunction 
%       Options 
%
%   Output 
%       SparseCoefficientMatrix 

    AudioFrames_Title = cell2mat(AudioFrames(1)); 
    AudioFrames_frames = cell2mat(AudioFrames(2)); 
    AudioFrame_samplingRate = cell2mat(AudioFrames(3)); 

    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= randi(size(D,2)); 
    end 
    numberOfSparseCoefficients= varargin{1}; 
    
    if lengthOfVarargin<2
        varargin{2}=eps;
    end 
    epsilon =varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= []; 
    end 
    errorFunction = varargin{3}; 
    
    if lengthOfVarargin<4
        varargin{4}=[]; 
    end 
    Options = varargin{4}; 
    
    SparseCoefficientMatrix=cell(1,2); 
    
    X=AudioFrames_frames;
    
    Y=zeros(size(D,2), size(AudioFrames_frames,2)); 
    for i=1:size(AudioFrames_frames,2)
        i
        Y(:,i)= OMP(X(:,i), D, numberOfSparseCoefficients, epsilon, errorFunction, Options);
    end 
    
    SparseCoefficientMatrix{1}= AudioFrames_Title; 
    SparseCoefficientMatrix{2}=Y; 
    

end 