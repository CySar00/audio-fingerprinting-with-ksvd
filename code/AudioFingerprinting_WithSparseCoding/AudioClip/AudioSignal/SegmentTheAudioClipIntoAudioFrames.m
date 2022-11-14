function audioFrames = SegmentTheAudioClipIntoAudioFrames(AudioClip, varargin)
%
%   Input:: 
%       AudioClip
%
%       samplingRate_toResample 
%       frame 
%       overlapFactor 
%
%   Output:: 
%       AudioFrames 

    AudioClip_audioClip=cell2mat(AudioClip(1)); 
    AudioClip_samplingRate = cell2mat(AudioClip(2)); 
    
    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1
        varargin{1}=8000;
    end 
    samplingRate_toResample= varargin{1}; 
    
    if lengthOfVarargin<2
        varargin{2}= 256/samplingRate_toResample; 
    end 
    frame = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}=0.5;
    end 
    overlapFactor = varargin{3}; 
    
     if size(AudioClip_audioClip,2)>1
        AudioClip_audioClip = sum(AudioClip_audioClip,2)/2; 
     end 
     
     resampledAudioClip = resample(AudioClip_audioClip, samplingRate_toResample, AudioClip_samplingRate); 
     
     resampledAudioClipLength= length(resampledAudioClip); 
     frameLength = round(samplingRate_toResample*frame); 
     numberOfOverlappingSamples = round(samplingRate_toResample*frame*overlapFactor); 
     
     numberOfFrames = ceil( (resampledAudioClipLength-frameLength)/numberOfOverlappingSamples)+1; 
     
     audioFrames =zeros(frameLength,numberOfFrames); 
     for i=1:numberOfFrames 
        positionIndex = (i-1)*numberOfOverlappingSamples+1; 
        
        if i~=numberOfFrames 
            audioFrames(:,i)= resampledAudioClip(positionIndex : positionIndex+frameLength-1); 
        else 
            numberOfRemainingSamples= resampledAudioClipLength-positionIndex+1;
            audioFrames(1:numberOfRemainingSamples,i)= resampledAudioClip(positionIndex:end); 
        end 
     end 
end