function [STFTs, magnitudes, magnitudesWithNoNoise, normalizedMagnitudesWithNoNoise] = CalculateTheMP3sSpectrogram(mp3, varargin)
%
%   Input:: 
%       mp3 
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
%   Output:: 
%       STFTs 
%       magnitudes
%       magnitudesWithNoNoise 
%       normalizedMagnitudesWithNoNoise

    mp3_Title =cell2mat(mp3(1)); 
    mp3_audioSignal =cell2mat(mp3(2)); 
    mp3_samplingRate= cell2mat(mp3(3)); 
    
    lengthOfVarargin=length(varargin);
    if lengthOfVarargin<1 
        varargin{1}= 8000;
    end 
    samplingRate_toResample = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 256/samplingRate_toResample; 
    end
    frame = varargin{2}; 
    
    if lengthOfVarargin<3
        varargin{3}= 0.5; 
    end 
    overlapFactor = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= 'hamming';
    end 
    windowType =lower(varargin{4});
    
    if lengthOfVarargin<5 
        varargin{5}= round(samplingRate_toResample*frame); 
    end 
    windowLength =varargin{5};
    
    if lengthOfVarargin<6 
        varargin{6}=1;
    end 
    windowAmplitude = varargin{6}; 
    
    if lengthOfVarargin<7
        varargin{7}= 'periodic';
    end 
    windowSFlag = lower(varargin{7}); 
    
    if lengthOfVarargin<8
        varargin{8}= 10^8;
    end 
    B= varargin{8}; 
    
    if size(mp3_audioSignal,2)>1 
        mp3_audioSignal =sum(mp3_audioSignal,2)/2;
    end 
    
    resampledMP3= resample(mp3_audioSignal, samplingRate_toResample, mp3_samplingRate); 
    
    frameLength= round(samplingRate_toResample*frame); 
    numberOfOverlappingSamples = round(samplingRate_toResample*frame*overlapFactor); 
    
    if strcmp(windowType, 'rectwin')
        Window_= (window( str2func(windowType), windowLength)).';
    else 
        Window_ = (window( str2func(windowType), windowLength, windowSFlag)).';
    end 
    windowAmplitude = windowAmplitude(:);
    Window_ = windowAmplitude.*Window_; 
    
    resampledMP3= [resampledMP3; zeros(frameLength,1)]; 
    STFTs= spectrogram(...
        resampledMP3,...
        Window_,...
        frameLength-numberOfOverlappingSamples,...
        frameLength,...
        samplingRate_toResample,...
        'yaxis'...
        ); 
    
    magnitudes = abs(STFTs); 
    
    maxMagnitude = max(magnitudes(:)); 
    LB= maxMagnitude/B; 
    
    magnitudesWithNoNoise= log(max(magnitudes, LB)); 
    mu_= mean(magnitudesWithNoNoise(:)); 
    normalizedMagnitudesWithNoNoise= magnitudesWithNoNoise-mu_;


end 