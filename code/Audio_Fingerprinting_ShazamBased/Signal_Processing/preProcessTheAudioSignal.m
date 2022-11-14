function audio_signal = preProcessTheAudioSignal(audio_signal,fs, fs1)
%   This function 
%           i.      converts the signal from stereo to mono
%           ii.     reduces the signal's sampling rate from fs to fs1 
%           iii.    normalizes the audio signal by the signal's max audio
%                   sample
%
%   Input:: 
%       audio_signal    :   a numberOfSamples x numberOfChannels matrix
%                           that contains the samples of the audio signal
%       fs              :   sampling rate (in Hz)
%       fs1             :   the sampling rate to which the signal's initial
%                           sampling rate is reduced to (in Hz, default value:11025 Hz)
%   Output:: 
%       audio_signal    :   a numberOfSamples x 1 vector that contains the
%                           signal's audio samples with sampling rate fs1

    if nargin<3
        fs1=11025; 
    end 
    
    %   convert the audio signal from stereo to mono 
    if size(audio_signal,2)>1
        audio_signal=sum(audio_signal,2)/2; 
    end 
    
    figure('Name', 'Preprocess The Audio Signal'); 
    t=0: (1/fs): (length(audio_signal)-1)/fs;
    subplot(1,2,1),plot(t,audio_signal), title('Original Audio Signal'); 
    
    
    
    %   reduce the signal's sampling rate from fs to fs1 
    if fs1>=fs
        error('error!!! invalid new sampling rate value'); 
    else
        audio_signal= resample(audio_signal,fs1,fs); 
    end 
    
    %   normalize the signal by it's max (absolute value) audio sample 
    max_sample=max(abs(audio_signal)); 
    
    if max_sample==0
        max_sample = eps;
    end 
    audio_signal= audio_signal/max_sample; 
    
    t=0:(1/fs1) : (length(audio_signal)-1)/fs1; 
    subplot(1,2,2),plot(t, audio_signal), title('Re-sampled Audio Signal'); 
end 