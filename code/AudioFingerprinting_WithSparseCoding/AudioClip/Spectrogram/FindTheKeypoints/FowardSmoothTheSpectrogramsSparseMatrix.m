function dataTable1 = FowardSmoothTheSpectrogramsSparseMatrix(sparseCoefficientMatrix, varargin)
%
%   Input:: 
%       sparseCoefficientMatrix
%
%       N
%       sigma 
%       numberOfKeypointsKept 
%       decayRate 
%
%   Output:: 
%       dataTable1 

    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= 10;
    end 
    N= varargin{1}; 
    
    if lengthOfVarargin<2
        varargin{2}= 30;
    end 
    sigma = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= 5; 
    end 
    numberOfKeypointsKept = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= 0.9943; 
    end 
    decayRate = varargin{4}; 
    
    envelopes= zeros(size(sparseCoefficientMatrix));
    
    sparseCoefficientMatrix_N = sparseCoefficientMatrix(:,1:N); 
    maxSparseCoefficientMatrix_N = max(sparseCoefficientMatrix_N,[],2); 
    
    gaussianTable_N = CreateTheGaussianTable(maxSparseCoefficientMatrix_N,sigma); 
    envelope_Last = max(gaussianTable_N,[],2); 
    envelope_i = envelope_Last; 
    if isempty(envelope_i)
        envelope_i = zeros(size(sparseCoefficientMatrix,1),1); 
    end
    
    numberOfKeypoints=0; 
    for i=1:size(sparseCoefficientMatrix,2)
        sparseCoefficientMatrix_i = sparseCoefficientMatrix(:,i); 
        
        [peaks_i, ~]= FindTheLocalMaximasOfTheVector(max(sparseCoefficientMatrix_i, envelope_i)); 
        [sortedPeaks_i, indices_i]= sort(peaks_i, 'descend'); 
        sortedPeaks_i = sortedPeaks_i(indices_i>0); 
        
        k=0; 
        for j=1:length(sortedPeaks_i)
            p_k = sortedPeaks_i(j);
            l_k = indices_i(j); 
            
            if k<numberOfKeypointsKept 
                if sparseCoefficientMatrix_i(l_k)> envelope_i(l_k)
                    k=k+1; 
                    numberOfKeypoints = numberOfKeypoints+1; 
                    
                    localmax_i=zeros(size(envelope_i)); 
                    for f=1:length(localmax_i)
                        localmax_i(f)= p_k*exp(-0.5*((f-l_k)/sigma)^2); 
                    end 
                    envelope_i = max(localmax_i, envelope_i); 
                    
                    dataTable1(numberOfKeypoints,1)=i; 
                    dataTable1(numberOfKeypoints,2)=l_k; 
                    dataTable1(numberOfKeypoints,3)=p_k; 
                    
                end 
            end 
            
        end 
        envelopes(:,i)=envelope_i; 
        envelope_i = decayRate*envelope_i; 
    end 
    


end 
