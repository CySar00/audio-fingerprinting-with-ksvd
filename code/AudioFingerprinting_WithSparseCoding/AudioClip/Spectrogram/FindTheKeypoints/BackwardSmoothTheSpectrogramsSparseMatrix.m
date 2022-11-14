function dataTable2 = BackwardSmoothTheSpectrogramsSparseMatrix(sparseCoefficientMatrix, dataTable1, varargin)
%
%   Input:: 
%       sparseCoefficientMatrix
%       dataTable1 
%       
%       sigma 
%       decayRate 
%
%   Output:: 
%       dataTable2 

    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1} = 30;
    end 
    sigma= varargin{1}; 
    
    if lengthOfVarargin<2
        varargin{2}= 0.9943;
    end 
    decayRate = varargin{2}; 
    
    sparseCoefficientMatrix_Last = sparseCoefficientMatrix(:,end); 
    maxSparseCoeffcientMatrix_Last = max(sparseCoefficientMatrix_Last,[],2); 
    
    gaussianTable_Last = CreateTheGaussianTable(maxSparseCoeffcientMatrix_Last,sigma); 
    envelope_Last= max(gaussianTable_Last,[],2); 
    envelope_i = envelope_Last; 
    if isempty(envelope_i)
        envelope_i= zeros(size(sparseCoefficientMatrix,1),1); 
    end 
    
    numberOfInitialKeypoints=size(dataTable1,1); 
    
    numberOfKeypoints=0;
    for i= size(sparseCoefficientMatrix,2): (-1) : 1
        sparseCoefficientMatrix_i = sparseCoefficientMatrix(:,i); 

        while numberOfInitialKeypoints >0 && dataTable1(numberOfInitialKeypoints,1)==i
            p_k = dataTable1(numberOfInitialKeypoints,3); 
            l_k = dataTable1(numberOfInitialKeypoints,2); 

            if p_k> envelope_i(l_k)
                numberOfKeypoints= numberOfKeypoints+1;
        
                localmax_i =zeros(size(envelope_i)); 
                for f=1:length(localmax_i)
                    localmax_i(f) = p_k*exp(-0.5*( ( (f-l_k)/sigma)^2));
                end 
                envelope_i = max(localmax_i, envelope_i); 
                
                dataTable2(numberOfKeypoints,1)=i;
                dataTable2(numberOfKeypoints,2)=l_k;
            end 
            

            numberOfInitialKeypoints= numberOfInitialKeypoints-1;
        end 
        envelope_i = decayRate*envelope_i;
    end 

    if numberOfKeypoints==0
        dataTable2 = zeros(1,2); 
    end 

end 