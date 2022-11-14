function [ envelope ] = establishEnvelopeOfLastAudioFrame( magnitudes, sigma )
%   This function is used to create the envelope of the spectrogram's last
%   frame 
%
%   Input:: 
%       magnitudes  :   a numberOfFrequencyComponents/Frame x 1 vector that
%                       contains the magnitudes of the spectrogram's last frame
%       sigma       :   standard deviation value used in the gaussian
%                       kernel function (default value: 30)
%   Output:: 
%       envelope    :

    if nargin<2 
        sigma=30; 
    end 
    
    %   create the gaussian kernel and the gaussian table 
    [gaussian_kernel, gaussian_table] = createGaussianTable1(magnitudes); 
    
    %   establish the envelope 
    %
    %   to create the envelope, the maximum value of each row is found to
    %   get a Fx1 vector 
    envelope=max(gaussian_table); 

end

