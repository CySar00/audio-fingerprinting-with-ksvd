function [Keypoints1, Keypoints2] = FindTheMP3sSparseSpectrogramsKeypoints_( SparseCoefficientMatrix,varargin)
%
%   Input:: 
%       SparseCoefficientMatrix 
%
%       numberOfKeypointsPerFrame1
%       threshold1 
%       numberOfKeypointsPerFrame2 
%       threshold2 
%
%   Output:: 
%       Keypoints1 
%       Keypoints2 

    SparseCoefficientMatrix_Title = cell2mat(SparseCoefficientMatrix(1)); 
    SparseCoefficientMatrix_matrix = cell2mat(SparseCoefficientMatrix(2)); 
    
    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= 10;
    end 
    numberOfKeypointsPerFrame1= varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 0.5; 
    end 
    threshold1= varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= 5; 
    end 
    numberOfKeypointsPerFrame2 = varargin{3}; 
     
    if lengthOfVarargin<4
        varargin{4}= 0.75;
    end 
    threshold2= varargin{4}; 
    
    threshold1 = threshold1*max(SparseCoefficientMatrix_matrix(:)); 
    
    numberOfKeypoints1=0; 
    for i=1:size(SparseCoefficientMatrix_matrix)
        SparseCoefficientMatrix_i= SparseCoefficientMatrix_matrix(:,i); 
        
        [sortedSparseCoefficients_i, indices_i]= sort(SparseCoefficientMatrix_i, 'descend'); 
        
        k=0; 
        for j=1:length(sortedSparseCoefficients_i)
            p_k = sortedSparseCoefficients_i(j); 
            l_k = indices_i(j); 
            
            if k<numberOfKeypointsPerFrame1 
                if sortedSparseCoefficients_i(l_k)>threshold1 
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
    for i=1:size(SparseCoefficientMatrix_matrix,2)
        SparseCoefficientMatrix_i = SparseCoefficientMatrix_matrix(:,i); 
        
        Threshold2= threshold2*max(SparseCoefficientMatrix_i); 
        
        [sortedSparseCoefficients_i, indices_i] = sort(SparseCoefficientMatrix_i, 'descend'); 
        
        k=0;
        for j=1:length(sortedSparseCoefficients_i)
            p_k = sortedSparseCoefficients_i(j);
            l_k = indices_i(j); 
            
            if k<numberOfKeypointsPerFrame2 
                if SparseCoefficientMatrix_i(l_k)> Threshold2
                    k=k+1;
                    numberOfKeypoints2 = numberOfKeypoints2+1; 
                    
                    Keypoints2(numberOfKeypoints2,1)=i;
                    Keypoints2(numberOfKeypoints2,2)=l_k; 
                    Keypoints2(numberOfKeypoints2,3)=p_k;
                end 
            end 
        end 
    end 
    
end 