
function LandmarkPairs = FindTheMP3sSparseSpectrogramsLandmarkPairs(Keypoints, varargin)
%
%   Input:: 
%       Keypoints 
%
%       plusFrames 
%       plusFrequencies 
%       numberOfClosestKeypoints 
%
%   Output:: 
%       LandmarkPairs 
    
    lengthOfVarargin=length(varargin); 
    if lengthOfVarargin<1
        varargin{1}= 64;
    end 
    plusFrames = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 32;
    end 
    plusFrequencies = varargin{2}; 
    
    if lengthOfVarargin<3 
        varargin{3}= 3; 
    end 
    numberOfClosestKeypoints = varargin{3}; 
    
    numberOfLandmarkPairs =0; 
    for i=1:size(Keypoints,1)
        anchorPoint_frameIndex = Keypoints(i,1); 
        anchorPoint_frequencyIndex = Keypoints(i,2); 
        
        targetZone_startFrameIndex = anchorPoint_frameIndex; 
        targetZone_endFrameIndex = anchorPoint_frameIndex+plusFrames; 
        
        targetZone_startFrequencyIndex = anchorPoint_frequencyIndex-plusFrequencies; 
        targetZone_endFrequencyIndex = anchorPoint_frequencyIndex+plusFrequencies; 
        
        possibleKeypoints=find(...
            Keypoints(:,1)>targetZone_startFrameIndex &...
            Keypoints(:,1)<targetZone_endFrameIndex &...
            ...
            Keypoints(:,2)>targetZone_startFrequencyIndex &...
            Keypoints(:,2)<targetZone_endFrequencyIndex...
            ); 
        
        
        if length(possibleKeypoints)>numberOfClosestKeypoints 
            possibleKeypoints= possibleKeypoints(1:numberOfClosestKeypoints); 
        end 
        
        for keypoint = 1:length(possibleKeypoints)
            numberOfLandmarkPairs = numberOfLandmarkPairs+1; 
            
            LandmarkPairs(numberOfLandmarkPairs,1) = anchorPoint_frameIndex; 
            LandmarkPairs(numberOfLandmarkPairs,2) = anchorPoint_frequencyIndex; 
            LandmarkPairs(numberOfLandmarkPairs,3) = Keypoints(possibleKeypoints(keypoint),2); 
            LandmarkPairs(numberOfLandmarkPairs,4) = Keypoints(possibleKeypoints(keypoint),1)- anchorPoint_frameIndex; 
        end 
    end 

    if numberOfLandmarkPairs==0
        LandmarkPairs=zeros(1,4); 
    end
end 