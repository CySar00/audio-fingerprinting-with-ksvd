function [STFTs, magnitudes, magnitudesWithNoNoise,...
    normalizedMagnitudesWithNoNoise] =...
    CalculateTheAudioClipsSpectrogram(AudioClip, varargin)
%
%   Input:: 
%       AudioClip 
%       
%       samplingRate_toResample 
%       frame 
%       overlapFactor 
%
%       windowType
%       windowLength 
%       windowAmplitude 
%       windowSFlag 
%
%       B 
%
%   Output:: 
%       STFTs
%       magnitudes 
%       magnitudesWithNoNoise 
%       normalizedMagnitudesWithNoNoise 

    AudioClip_audioClip = cell2mat(AudioClip(1)); 
    AudioClip_samplingRate =cell2mat(AudioClip(2)); 
    
    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1 
        varargin{1}= 8000;
    end 
    samplingRate_toResample =varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 256/samplingRate_toResample;
    end 
    frame = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}=0.5; 
    end 
    overlapFactor = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}='hamming';
    end 
    windowType = lower(varargin{4}); 
    
    if lengthOfVarargin<5 
        varargin{5}= round(samplingRate_toResample*frame); 
    end 
    windowLength= varargin{5}; 

    if lengthOfVarargin<6
        varargin{6}= 1;
    end 
    windowAmplitude = varargin{6}; 
    
    if lengthOfVarargin<7 
        varargin{7}= 'periodic';
    end 
    windowSFlag = varargin{7}; 
    
    if lengthOfVarargin<8
        varargin{8}=10^8;
    end 
    B= varargin{8}; 
    
    if size(AudioClip_audioClip,2)>1
        AudioClip_audioClip = sum(AudioClip_audioClip,2)/2;
    end 
    
    resampledAudioClip = resample(AudioClip_audioClip, samplingRate_toResample, AudioClip_samplingRate);
    
    frameLength= round(samplingRate_toResample*frame); 
    numberOfOverlappingSamples  = round(samplingRate_toResample*frame*overlapFactor); 
    
    if strcmp( windowType, 'rectwin')
        Window_= (window(str2func(windowType), windowLength)).';
    else 
        Window_ = (window(str2func(windowType), windowLength, windowSFlag)).';
    end 
    windowAmplitude=windowAmplitude(:);
    Window_ = windowAmplitude.*Window_; 
    
    resampledAudioClip = [resampledAudioClip; zeros(frameLength,1)];
    
    STFTs= spectrogram(...
        resampledAudioClip,...
        Window_,...
        frameLength-numberOfOverlappingSamples,...
        frameLength,...
        samplingRate_toResample,...
        'yaxis'...
        ); 
    
    magnitudes = abs(STFTs); 
    
    maxMagnitude = max(magnitudes(:)); 
    LB  = maxMagnitude/B; 
    
    magnitudesWithNoNoise = log(max(magnitudes,LB)); 
    mu_= mean(magnitudesWithNoNoise(:)); 
    normalizedMagnitudesWithNoNoise = magnitudesWithNoNoise-mu_; 
    
        
end 