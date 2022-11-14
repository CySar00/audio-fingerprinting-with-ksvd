function [STFTs, magnitudes] = getSTFTsOfAudioSignal(audio_signal,fs,varargin)
%   This function 
%           i.  reduces the signal's sampling rate from fs to fs1
%           ii. computes the short-term fourier transforms (STFTs) of the
%               audio signal
%   Input:: 
%       audio_signal        :   a numberOfSamples x numberOfChannels matrix
%                               that contains the samples of the audio signal 
%       fs                  :   sampling rate (in Hz)
%       fs1                 :   the sampling rate to which the signal's
%                               initial sampling rate is reduced to (in Hz,
%                               default value:11025 Hz)
%       frame               :   frame duration analysis (in seconds, range
%                               value: 10-100ms, default value:0.0464 seconds)
%       hop_factor          :   factor that determines the number of
%                               overlapping samples (range value:0-1, default value:0.5)
%       window_type         :   name of the window (possible values :
%                               {'hamming','hann', 'rectwin'}, default value: {'hamming'} )
%       window_length       :   length of the window ( default value :
%                               round(fs1*frame) )
%       window_amplitude    :   amplitude of the window (default value: 1)
%       window_sflag        :   window sampling rate ( possible values :
%                               {'periodic', 'symmetric'}, default value : {'periodic'})
%   Output:: 
%       STFTs               :   a numberOfFrequencyComponents/Frame x
%                               numberOfFrames matrix that contains the audio singal's  short-term fourier
%                               transforms (STFTs) 
%       magnitudes          :   a numberOfFrequencyComponents/Frame x
%                               numberOfFrames matrix that contains the spectral magnitudes of the audio singal's  short-term fourier
%                               transforms (STFTs)

    %   number of optional inputs 
    length_of_varargin=length(varargin); 
    
    if length_of_varargin<1 
        varargin{1}=11025; 
    end 
    fs1=varargin{1}
    
    %   each frame must contain 512 samples 
    if length_of_varargin<2
        if varargin{1}==11025 
            varargin{2}=0.0464; 
        else 
            varargin{2}= 512/varargin{1}; 
        end 
    end 
    frame=varargin{2}; 
    
    if length_of_varargin<3 
        varargin{3}=0.5; 
    end 
    hop_factor= varargin{3}; 
    
    if length_of_varargin<4 || ~ischar(varargin{4})
        varargin{4}='hamming';
    end 
    window_type=lower(varargin{4}); 
    
    if length_of_varargin<5 || ~isreal(varargin{5})
        varargin{5}=round(fs1*frame); 
    end 
    window_length=varargin{5}; 
    
    if length_of_varargin<6 || ~isreal(varargin{6})
        varargin{6}=1; 
    end 
    window_amplitude= varargin{6}; 
    
    if length_of_varargin<7 || ~ischar(varargin{7})
        if ~strcmp(varargin{3}, 'rectwin')
            varargin{7}='periodic';
        else
            varargin{7}=' ';
        end 
    end 
    window_sflag= lower(varargin{7}); 
    
     if length_of_varargin>7 
         error('error!!! invalid number of optional inputs'); 
     end 
    
    
    %   based on 'A Survey on Audio-Based Classification and Annotation' a frame 
    %   must have duration 10-100ms 
    if frame>0.1 && frame<0.01
        error('error!!! invalid frame size'); 
    end 
    
    if hop_factor>1 && hop_factor<0
        error('error!!! invalid hop factor value'); 
    end 
    
    if fs1>fs
        error('error!!! invalid re-sampling rate'); 
    end 
    
    
    %   pre-process the audio signal 
    audio_signal=preProcessTheAudioSignal(audio_signal,fs,fs1); 
    
    %   length of the signal
    length_of_signal=length(audio_signal); 
    
    %   length of frame 
    length_of_frame=round(fs1*frame); 
    
    %   length of step between two consecutive frames/ number of
    %   overlapping samples 
    length_of_step= round(fs1*frame*hop_factor); 
    
    %   create the window 
    if strcmp(window_type, 'rectwin')
        window_ = ( window( str2func( window_type), window_length)).'; 
    else
        window_= ( window(str2func(window_type), window_length, window_sflag)).';
    end 
    
    window_amplitude= window_amplitude(:).'; 
    window_ = window_amplitude.*window_; 
    
    %   compute the STFTs of the audio signal 
    audio_signal=[audio_signal; zeros(length_of_frame,1)]; 
    
    STFTs = spectrogram(     audio_signal,...
                            window_,...
                            length_of_frame-length_of_step,...
                            length_of_frame,...
                            fs1, ...
                            'yaxis'...
                        );  
                    
   %    compute the magnitudes of the audio signal 
   magnitudes = 2*abs(STFTs)/length_of_frame; 
   
   figure('Name', 'Magnitudes Of Signal''s Spectrogram')
   imagesc( 20*log10(magnitudes)); 
   axis xy 
   xlabel('Time'); 
   ylabel('Frequency');
   colorbar
   

end 