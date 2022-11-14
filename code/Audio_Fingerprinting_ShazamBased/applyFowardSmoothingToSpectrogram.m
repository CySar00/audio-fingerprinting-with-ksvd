function [ envelope, max_, peaks, envelopes] = applyFowardSmoothingToSpectrogram( magnitudes, varargin)
%   This function 
%           i.  finds the peaks of the spectrogram 
%           ii. updates the envelope 
%           iii. records the peaks 
%
%   Input:: 
%       magnitudes
%       fs1
%       number_of_frames    :
%       sigma               :   (default value: 30) 
%       number_of_peaks     :   (max value: 5 , default value: 30)
%       decay_rate          :   (default value: 0.9943)
%   Output:: 


    %   number of optional inputs 
    length_of_varargin= length(varargin); 
    
    if length_of_varargin<1 
        varargin{1}=11025; 
    end 
    fs1=varargin{1}; 
    
    if length_of_varargin<2 
        varargin{2}= 10;
    end 
    number_of_frames=varargin{2}; 
    
    if length_of_varargin<3 
        varargin{3}=30; 
    end 
    sigma=varargin{3}; 
    
    
    if length_of_varargin<4 
        varargin{4}= 5; 
    end 
    max_peaks_per_frame=varargin{4}; 
    
    if length_of_varargin<5 
        varargin{5}= 0.9943; 
    end 
    decay_rate= varargin{5}; 
    
    
    if max_peaks_per_frame>5 
        error('error!!! invalid number of max peaks/ frame'); 
    end 
    
    
    %   number of frames 
    number_of_frames = size(magnitudes,2); 
    
    %   length of spectrum 
    length_of_spectrum =size(magnitudes,1); 
    
    %   length of signal (in samples , an approximation) 
    length_of_signal =2*length_of_spectrum *number_of_frames 
    
    %   duration of the signal (in seconds) 
    duration_of_signal = length_of_signal/fs1; 
    
    %   total number of maxes 
    %number_of_maxes = round( duration_of_signal*max_peaks_per_frame); 
    
    
    %   create the initial envelope 
    [~,~,~,~,~,envelope]=establishEnvelopeOfSpectrogram(magnitudes,number_of_frames,sigma); 
    envelope=envelope'; 
    
    %   1. find peaks 
    %       i.      extract the i-th frame
    %
    %       ii.     for each data point , if the data point is 
    %                   i.  a local maxima 
    %                   ii. greater than the envelope 
    %               then it will be treated as a peak 
    %                          
    %       iii.    sort the peaks in descending order according to their
    %               value  
    %
    %       iv.     obtain the top 'max_peaks_per_frames' peaks
    %
    %
    %   2. envelope update : 
    %           the peaks are 
    %                   i.      multiplied by the gaussian kernel 
    %                                       localmax_f = p_k x G(f, l_k)
    %
    %                   ii.     compared with the envelope to update the
    %                           envelope 
    %                               envelope_f = max( localmax_f, envelope_f)
    %   
    %   3.  record peaks : 
    %           for each peak retained, 
    %               i.   the frame position 
    %               ii.  the frequency position 
    %               iii. the data point 
    %       are stored in the 'peaks' table 
    %                               
    %
    %   4.  when processing the (i+1)-th frame 
    %           the envelope is multiplied with 'decay_rate' to decay the
    %           envelope 
    %peaks =zeros(number_of_maxes,3); 
    peak_index=1; 
    
    envelopes=zeros( size(magnitudes));
    
    for i=1:number_of_frames 
        
        
        
        %   extract the i-th frame of the spectrogram 
        frame_i = magnitudes(:,i); 
        
        %   check if each data point of the frame is greater than the
        %   current envelope 
        max_ = max( frame_i, envelope); 
        
        %   find the frame's local maxima 
        local_maxima_of_frame_i = getLocalMaxima( max_); 
        
        %   sort the peaks in descending order based on their value 
        [sorted_peaks, sorted_indices]= sort(max_, 'descend'); 
        
        %   obtain the non-negative (and non-zero) values 
        sorted_indices1= find(sorted_peaks>0); 
        
        k=1;
        %   run through the peak's indices 
        for j=1:length(sorted_indices1)
            
            if k<max_peaks_per_frame
                l_k = sorted_indices(k); 
                
                %   update the envelope 
                %   check if the peak is greater than the envelope value 
                if frame_i(l_k)> envelope(l_k)
                    
                    %   create the gaussian kernel function 
                    for f=1:length_of_spectrum 
                        
                        G(f,l_k)= exp(-0.5*( ( (f-l_k)/sigma)^2)   );
                        
                        
                        %   multiply the peak value with the gaussian kernel
                        %   function 
                        localmax_f(f)=frame_i(l_k)*G(f,l_k);
                    end 
                    
                    %   update the envelope 
                    envelope = max(localmax_f', envelope);
                    
                    %   record the peaks 
                    peaks(peak_index,1)=i;
                    peaks(peak_index,2)=l_k;
                    peaks( peak_index,3)=frame_i(l_k);
                    
                    
                    k=k+1; 
                    peak_index= peak_index+1; 
                end 
               
            end 
            
            
            
        end 
        
        %   update the envelope (i.e. multiply the envelope by
        %   'decay_rate')
        envelope= decay_rate*envelope;
        envelopes(:,i)=envelope;
        
        
        
        
    end 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
end 