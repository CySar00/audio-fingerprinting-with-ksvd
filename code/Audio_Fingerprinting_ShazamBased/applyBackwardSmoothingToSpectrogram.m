function [peaks2, envelopes] = applyBackwardSmoothingToSpectrogram( magnitudes, peaks1, varargin)
%   This function is used to apply backward smoothin to the signal's
%   spectrogram
%
%   Input:: 
%       magnitudes 
%       peaks1 
%       fs1 
%       sigma 
%       decay_rate 
%   Output:: 
%       peaks2
%       envelopes 

    %   length of optional inputs
    length_of_varargin= length(varargin); 
    
    if length_of_varargin<1 
        varargin{1}=11025;
    end 
    fs1= varargin{1}; 
    
    if length_of_varargin<2 
        varargin{2}=30;
    end 
    sigma=varargin{2}; 
    
    if length_of_varargin<3 
        varargin{3}=0.9943;
    end 
    decay_rate=varargin{3}; 
    
    addContainingDirectoriesAndSubDirectories(); 
    
    %   number of frames 
    number_of_frames= size(magnitudes,2); 
    
    %   length of spectrum 
    length_of_spectrum =size(magnitudes,1); 
    
    %   length of the audio signal (an approximation)
    length_of_signal= 2*length_of_spectrum*number_of_frames; 
    
    %   1. calculate the envelope 
    %               i.      extract the last frame of the spectrogram 
    %
    %               ii.     establish the envelope of that frame 
    %
    %   2. select the peaks 
    %               i.      extract the data from the matrix's 'peaks1'
    %                       last entry 
    %
    %               ii.     check if the index of 'peaks1' last entry is
    %                       equal to the current frame's index 
    %
    %               iii.    if yes, then compare 'peaks1' frame value to the envelope 
    %                                       Y_ft >= envelope_f 
    %                       then the data will be retained and the envelope
    %                       updated 
    %
    %               iv.     if not, then the index of 'peaks1' will be
    %                       moved to the frame index which 'peaks1' is pointing at
    %                       and compared to the envelope 
    %   
    %               v.      each time to process a front frame, the
    %                       envelope will be multiplied by 'decay_rate' to attenuate the 
    %                       envelope
    
    peak_index=1; 
    
    
    
    %   establish the envelope of the spectrogram's last frame 
    envelope = establishEnvelopeOfLastAudioFrame( magnitudes(:,end), sigma); 
    
    envelopes= zeros( size(magnitudes)); 
  
    %   index of the matrix's 'peaks1' last entry 
    last_entry_of_peaks1 = size(peaks1,1)
    
    j=1; 
    for i= number_of_frames : (-1):1
        
        %   extract the i-th frame 
        frame_i = magnitudes(:,i); 
        
        
        while last_entry_of_peaks1>=1 && i==peaks1(last_entry_of_peaks1,1)
            
            l_k = peaks1(last_entry_of_peaks1,2); 
            p_k = peaks1(last_entry_of_peaks1,3); 
            
            %   compare p_k to the envelope 
            if p_k>=envelope(l_k)
                
                
                %   create the gaussian kernel 
                for f=1:length_of_spectrum 
                    G(f,l_k) = exp( -0.5* ( ( (f-l_k)/sigma)));
                    
                    %   multiply the gaussian kernel function with p_k 
                    localmax_f(f)= p_k*G(f,l_k); 
                end 
                
                %   update the envelope 
                envelope= max( localmax_f, envelope); 
                
                
                %   store the frame index and the frequency component to
                %   the matrix 'peaks2' 
                peaks2(peak_index,2)=i; 
                peaks2(peak_index,1)=l_k; 
                
                
                peak_index= peak_index+1;
            end 
            
            
            
            last_entry_of_peaks1=last_entry_of_peaks1-1;
        end 
        
        
        %   
        envelope= decay_rate*envelope; 
        envelopes(:,j)= envelope;
        j=j+1;
    end 
    
    %peaks2 = fliplr(peaks2); 
    
    
    figure('Name', 'Prominent Peaks'), 
    %imagesc( magnitudes), axis xy, 
    %hold on; 
    plot(peaks1(:,1),peaks1(:,2), '*'); 
    title('Prominent Peaks')
    
   figure('Name', 'Constellation Map'), 
   plot(peaks2(:,2), peaks2(:,1),'*');
   title('Constellation Map');
    
    
    
    

end 