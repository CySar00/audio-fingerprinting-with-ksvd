function [rho,rho1, gaussian_kernel, gaussian_table, envelope1,envelope2] = establishEnvelopeOfSpectrogram(STFTs,number_of_frames, sigma)
%   This function is used to establish the envelope of the signal's
%   spectrogram
%
%   Input:: 
%       STFTs 
%       number_of_frames 
%       sigma
%   Output:: 
%       envelope 

    if nargin<2
        number_of_frames=10; 
    end


    if nargin<3
        sigma=30; 
    end 
    
    
    if length(sigma)==1 
        W= 4*sigma; 
        E= exp( -0.5 * ( ( (-W:W)/sigma).^2)); 
    end 
    
    %   extract the first 'number_of_frames' frames of the spectrogram to
    %   get a F x 'number_of_frames' matrix where F =size(STFTs,1) 
    STFTs1 = STFTs(:, 1:10); 
    
    %   find the maximum of each row to get a F x 1 column vector 
    a = max(STFTs1,[],2); 
    
    [rho,rho1] = getLocalMaxima( a);
    
    envelope1= 0*rho; 
    
    length_of_rho= length(rho); 
    max_i = length_of_rho + length(sigma); 
    
    
    s_pos = 1+round( (length(E)-1)/2); 
    
    for i=1:find(rho>0)
        EE= [zeros(1,i), E]; 
        EE(max_i)=0; 
        
        EE = EE(s_pos+ (1:length_of_rho)); 
        envelope1= max( envelope1, rho(i)*EE); 
    end 
    
    [gaussian_kernel, gaussian_table]=createGaussianTable(a);
    
    %   establish the envelope 
    %
    %   to create the envelope,the maximum value of each row is found to get a 
    %   F x 1 vector 
    envelope2 = (max(gaussian_table))'; 
    
    
    
    



end 