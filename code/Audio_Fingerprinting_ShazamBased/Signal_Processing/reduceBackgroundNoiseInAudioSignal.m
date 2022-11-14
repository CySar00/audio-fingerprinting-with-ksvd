function magnitudes = reduceBackgroundNoiseInAudioSignal( magnitudes, LB)
%   This function is used to reduce the background noise in audio frames. 
%
%   To reduce the background noise in the signal's spectrogram
%       i. the noise is limited by a dynamic range in the spectrogram
%       (i.e. a lower bound is computed which is the spectrogram's max
%       value divided by LB) 
%
%       ii. the energy signals are compressed by using the natural
%           logarithm (ln)  : 
%               magnitudes(i,j)= log( max( magntidues(i,j), LB)
%           where LB={max_magnitudes} over {10^6}
%
%       iii.    the magnitude magnitudes(i,j) is normalized by subtracting
%               the mean value so the the mean magnitude is 0 
%                   magnitudes(i,j)= magnitudes(i,j)-mu_magnitudes
%
%   Input:: 
%       magnitudes  :   a numberOfFrequencyComponents/Frame x
%                       numberOfFrames matrix that contains the spectral magnitudes of the audio singal's  short-term fourier
%                       transforms (STFTs)  
%       LB          :   
%
%   Output:: 

    if nargin<2
        LB=10^6; 
    end
    
    %   i. find the spectrogram's max values 
    max_magnitude =max(max(magnitudes));
    
    %   ii. compress the energy signal's by using the natural logarithm 
    LB= max_magnitude/LB; 
    
    magnitudes= log( max(magnitudes, LB)); 
    
    %   iii. normalize the magnitudes by subtracting the mean magnitude 
    mu_magnitude =mean2(magnitudes)
    
    mu_magnitude= mu_magnitude*ones(size(magnitudes)); 
    
    magnitudes = magnitudes-mu_magnitude;
    
    
    figure('Name', 'Remove background noise from spectrogram'); 
    imagesc(magnitudes),
    axis xy 
    xlabel('Time'),
    ylabel('Frequency'), 
    colorbar
    
end 