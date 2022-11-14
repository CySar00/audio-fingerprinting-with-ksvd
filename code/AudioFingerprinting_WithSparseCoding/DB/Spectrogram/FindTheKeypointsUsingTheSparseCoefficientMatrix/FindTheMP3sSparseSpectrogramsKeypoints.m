function Keypoints = FindTheMP3sSparseSpectrogramsKeypoints( SparseCoefficientMatrix, numberOfKeypoints)
%
%   Input:: 
%       SparseCoefficientMatrix 
%       numberOfKeypoints 
%
%   Output:: 
%       Keypoints 

    SparseCoefficientMatrix_Title  = cell2mat(SparseCoefficientMatrix(1)); 
    SparseCoefficientMatrix_matrix = cell2mat(SparseCoefficientMatrix(2)); 

    if nargin<2
        numberOfKeypoints = 500; 
    end 

    [sortedSparseCoefficients, indices] = sort(SparseCoefficientMatrix_matrix(:),'descend');
    [yy , xx]= ind2sub(size(SparseCoefficientMatrix_matrix), indices); 
    
    Keypoints = zeros(numberOfKeypoints,3);
    for i=1:numberOfKeypoints
        Keypoints(i,1)=xx(i); 
        Keypoints(i,2)=yy(i); 
        Keypoints(i,3)= sortedSparseCoefficients(i); 
    end 
    
end 