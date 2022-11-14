function filteredMagnitudes = HighPassFilterTheMP3sSpectrogram( magnitudes, halfPole)
%
%   Input:: 
%       magnitudes 
%       halfPole 
%       
%   Output:: 
%       filteredMagnitudes 

    if nargin<2 
        halfPole = 0.98;
    end 
    
    filteredMagnitudes =zeros(size(magnitudes)); 
    
    filteredMagnitudes(:,1)= magnitudes(:,1); 
    for f=1:size(filteredMagnitudes,1)
        for t=2:size(filteredMagnitudes,2)
            filteredMagnitudes(f,t)= (magnitudes(f,t)-magnitudes(f,t-1))+halfPole*filteredMagnitudes(f,t-1); 
        
        end 
    end 


end 