function Keypoints = FindTheMP3sSparseKeypoints(SparseCoefficientMatrix, numberOfKeypoints)
%
%
%   Input:: 
%       SparseCoefficientMatrix 
%       numberOfKeypoints 
%
%   Output:: 
%       Keypoints 

    SparseCoefficientMatrix_Title =cell2mat(SparseCoefficientMatrix(1)); 
    sparseCoefficientMatrix = cell2mat(SparseCoefficientMatrix(2)); 

    if nargin<2 
        numberOfKeypoints = 500; 
    end
    
    Keypoints = zeros(numberOfKeypoints,3); 
    [sortedSparseCoefficients, indices]= sort(sparseCoefficientMatrix(:),'descend');
    [yy, xx]= ind2sub(size(sparseCoefficientMatrix), indices); 
    
    for i=1:numberOfKeypoints 
        Keypoints(i,1)= xx(i); 
        Keypoints(i,2)= yy(i); 
        Keypoints(i,3)= sortedSparseCoefficients(i); 
    end 
end 