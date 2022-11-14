function Keypoints = FindTheSparseSpectrogramsKeypoints(sparseCoefficientMatrix, numberOfKeypoints)
%
%   Input:: 
%       sparseCoefficientMatrix
%       numberOfKeypoints 
%
%   Output:: 
%       Keypoints

    if nargin<2 
        numberOfKeypoints=500; 
    end 
    
    [sortedSparseCoefficients, indices]= sort(sparseCoefficientMatrix(:),'descend'); 
    [yy,xx] = ind2sub( size(sparseCoefficientMatrix), indices); 
    
    Keypoints = zeros(numberOfKeypoints,3); 
    for i=1:numberOfKeypoints 
        Keypoints(i,1)= xx(i); 
        Keypoints(i,2)=yy(i); 
        Keypoints(i,3)= sortedSparseCoefficients(i); 
    end 
    


end 