function [Y,Y1] = highPassFilterTheMagnitudes(magnitudes, alpha)
%   This function is used to high-pass filter the signal's spectral
%   magnitudes
%
%
%   Input:: 
%       magnitudes  : 
%       alpha       :
%   Outpudt:: 
%       Y

    if nargin<2
        alpha =0.98; 
    end 

    %   number of frames 
    number_of_frames = size(magnitudes,2); 
    
    %   length of spectrum 
    length_of_spectrum =size(magnitudes,1); 
    
    Y= filter( [1 -1] , [1 -alpha], magnitudes')';
    
    magnitudes1= magnitudes'; 
    
    Y1=zeros(size(magnitudes)); 
    Y1(:,1)= magnitudes(:,1);
    
    for j=1:length_of_spectrum 
        for i=2:number_of_frames 
            
            Y1(j,i)= magnitudes(j,i)-magnitudes(j,i-1)+alpha*Y1(j,i-1);
        end 
    end 
    
    figure('Name', 'High-Pass The Spectrogram'); 
    imagesc(Y1); 
    axis xy 
    xlabel('Time')
    ylabel('Frequency')
    colorbar
    
    
    
    
    
    
    
end 