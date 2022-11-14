function AudioFrames = SegmentTheMP3IntoAudioFrames(mp3, varargin)
%
%   Input:: 
%       mp3 
%       samplingRate_toResample 
%       frame 
%       overlapFactor 
%
%   Output:: 
%       AudioFrames 

    
    mp3_Title = cell2mat(mp3(1)); 
    mp3_audioSignal = cell2mat(mp3(2)); 
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
        varargin{3}=0.5; 
    end 
    overlapFactor= varargin{3}; 
    
    AudioFrames=cell(1,3); 
    
    if size(mp3_audioSignal,2)>2 
        mp3_audioSignal= sum(mp3_audioSignal,2)/2;
    end 

    resampledMP3AudioSignal =resample(mp3_audioSignal, samplingRate_toResample, mp3_samplingRate); 
    
    resampledMP3Length =length(resampledMP3AudioSignal); 
    frameLength = round(samplingRate_toResample*frame); 
    numberOfOverlappingSamples = round(samplingRate_toResample*frame*overlapFactor); 
    
    numberOfFrames =ceil( (resampledMP3Length-frameLength)/numberOfOverlappingSamples)+1; 
    audioFrames = zeros(frameLength, numberOfFrames); 
    
    for i=1:numberOfFrames 
        positionIndex = (i-1)*numberOfOverlappingSamples+1; 
        
        if i~=numberOfFrames
            audioFrames(:,i) = resampledMP3AudioSignal(positionIndex : positionIndex+frameLength-1); 
        
        elseif i==numberOfFrames 
            numberOfSamples = resampledMP3Length-positionIndex+1;
            
            audioFrames(1:numberOfSamples,i)=resampledMP3AudioSignal(positionIndex: resampledMP3Length);
        end 
    
    end 
    
    
    
    
    AudioFrames{1}= mp3_Title; 
    AudioFrames{2}= audioFrames; 
    AudioFrames{3}= samplingRate_toResample;
end 