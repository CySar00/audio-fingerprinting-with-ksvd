function [Keypoints1, Keypoints2] = FindTheSparseSpectrogramsKeypoints_(sparseCoefficientMatrix, varargin)
%
%   Input:: 
%       sparseCoefficientMatrix 
%
%       numberOfKeypoints1 
%       threshold1 
%       numberOfKeypoints2 
%       threshold2 
%
%   Output:: 
%       Keypoints1 
%       Keypoints2 


    lengthOfVarargin=length(varargin);
    if lengthOfVarargin<1 
        varargin{1}= 10; 
    end 
    numberOfKeypointsPerFrame1 = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 0.5; 
    end 
    threshold1 = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= 5; 
    end 
    numberOfKeypointsPerFrame2= varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= 0.75;
    end 
    threshold2= varargin{4}; 
    
    threshold1 = threshold1*max(sparseCoefficientMatrix(:)); 
    
    numberOfKeypoints1=0; 
    for i=1:size(sparseCoefficientMatrix,2)
        sparseCoefficientMatrix_i = sparseCoefficientMatrix(:,i); 
        
        [sortedSparseCoefficients_i, indices_i]= sort(sparseCoefficientMatrix_i, 'descend'); 
        
        k=0;
        for j=1:length(sortedSparseCoefficients_i)
            p_k = sortedSparseCoefficients_i(j); 
            l_k = indices_i(j); 
            
            if k<numberOfKeypointsPerFrame1 
                if sparseCoefficientMatrix_i(j)>threshold1
                    k=k+1; 
                    numberOfKeypoints1= numberOfKeypoints1+1; 
                    
                    Keypoints1(numberOfKeypoints1,1)=i; 
                    Keypoints1(numberOfKeypoints1,2)=l_k; 
                    Keypoints1(numberOfKeypoints1,3)=p_k; 
                end 
            end 
        
        end 
        
    end 
    
    numberOfKeypoints2=0; 
    for i=1:size(sparseCoefficientMatrix,2)
        sparseCoefficientMatrix_i = sparseCoefficientMatrix(:,i); 
        
        Threshold2 = threshold2*max(sparseCoefficientMatrix_i); 
        
        [sortedSparseCoefficients_i, indices_i]= sort(sparseCoefficientMatrix_i,'descend'); 
        
        k=0; 
        for j=1:length(sortedSparseCoefficients_i)
            p_k = sortedSparseCoefficients_i(j); 
            l_k = indices_i(j); 
            
            if k<numberOfKeypointsPerFrame2
                if sparseCoefficientMatrix_i(l_k)>Threshold2 
                    k=k+1; 
                    numberOfKeypoints2= numberOfKeypoints2+1; 
                    
                    Keypoints2(numberOfKeypoints2,1)=i;
                    Keypoints2(numberOfKeypoints2,2)=l_k;
                    Keypoints2(numberOfKeypoints2,3)= p_k; 
                
                end 
            end 
        end 
    
    end 


end 