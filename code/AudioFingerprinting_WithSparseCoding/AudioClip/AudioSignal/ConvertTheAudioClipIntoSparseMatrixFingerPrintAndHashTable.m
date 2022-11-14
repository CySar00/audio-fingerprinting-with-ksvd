function [audioFrames, sparseCoefficientMatrix,...
    Keypoints1, Keypoints2, Keypoints3, dataTable1, dataTable2,...
    LandmarkPairs1, LandmarkPairs2, LandmarkPairs3, LandmarkPairsFromDataTable2,...
    HashTable1, HashTable2, HashTable3, HashTableFromDataTable2]=...
    ConvertTheAudioClipIntoSparseMatrixFingerPrintAndHashTable(AudioClip,D, varargin)
%
%   Input:: 
%       AudioClip 
%
%       samplingRate_toResample 
%       frame 
%       overlapFactor 
%
%       numberOfKeypoints 
%
%       numberOfKeypointsKept1
%       threshold1 
%       numberOfKeypointsKept2 
%       threshold2 
%
%       N
%       sigma 
%       numberOfKeypointsKept 
%       decayRate 
%
%       plusFrames 
%       plusFrequencies 
%       numberOfClosestKeypoints 

    lengthOfVarargin=length(varargin);
    if lengthOfVarargin<1 
        varargin{1}=8000;
    end 
    samplingRate_toResample = varargin{1}; 
    
    if lengthOfVarargin<2 
        varargin{2}= 256/samplingRate_toResample; 
    end 
    frame = varargin{2}; 
    
    if lengthOfVarargin<3
        varargin{3}=0.5;
    end 
    overlapFactor = varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= randi(size(D,2)); 
    end 
    numberOfSparseCoefficients = varargin{4}; 
    
    if lengthOfVarargin<5 
        varargin{5}= eps;
    end 
    epsilon = varargin{5}; 
    
    if lengthOfVarargin<6 
        varargin{6}=[]; 
    end 
    errorFunction = varargin{6}; 
    
    if lengthOfVarargin<7 
        varargin{7}=[];
    end 
    Options= varargin{7}; 
    
    if lengthOfVarargin<8
        varargin{8}= 500; 
    end 
    numberOfKeypoints= varargin{8}; 
    
    if lengthOfVarargin<9
        varargin{9}= 10; 
    end 
    numberOfKeypointsPerFrame1= varargin{9}; 
    
    if lengthOfVarargin<10
        varargin{10}= 0.5; 
    end 
    threshold1= varargin{10}; 
    
    if lengthOfVarargin<11
        varargin{11}=5; 
    end 
    numberOfKeypointsPerFrame2= varargin{11}; 
    
    if lengthOfVarargin<12 
        varargin{12}= 0.75; 
    end
    threshold2= varargin{12}; 
    
    if lengthOfVarargin<13 
        varargin{13}= 10;
    end 
    N= varargin{13}; 
    
    if lengthOfVarargin<14 
        varargin{14}= 30;
    end 
    sigma= varargin{14}; 
    
    if lengthOfVarargin<15
        varargin{15}=5; 
    end 
    numberOfKeypointsKept = varargin{15}; 
    
    if lengthOfVarargin<16
        varargin{16}= 0.9943;
    end 
    decayRate = varargin{16};
    
    if lengthOfVarargin<17 
        varargin{17}= 64; 
    end 
    plusFrames = varargin{17}; 
    
    if lengthOfVarargin<18
        varargin{18}=32;
    end 
    plusFrequencies = varargin{18}; 
    
    if lengthOfVarargin<19
        varargin{19}= 3; 
    end 
    numberOfClosestKeypoints = varargin{19}; 
    
    audioFrames = SegmentTheAudioClipIntoAudioFrames(AudioClip, samplingRate_toResample, frame, overlapFactor); 
    
    sparseCoefficientMatrix= CalculateTheAudioClipsSparseCoefficientMatrix(audioFrames, D, numberOfSparseCoefficients, epsilon, errorFunction, Options);
    
    Keypoints1= FindTheSparseAudioClipsKeypoints(sparseCoefficientMatrix,numberOfKeypoints);
    [Keypoints2, Keypoints3] = FindTheSparseAudioClipsKeypoints_(sparseCoefficientMatrix, numberOfKeypointsPerFrame1, threshold1, numberOfKeypointsPerFrame2, threshold2); 
    
    dataTable1 = FowardSmoothTheAudioClipsSparseMatrix(sparseCoefficientMatrix, N, sigma, numberOfKeypointsKept, decayRate); 
    dataTable2 = BackwardSmoothTheAudioClipsSparseMatrix(sparseCoefficientMatrix,dataTable1, sigma, decayRate); 
    
    LandmarkPairs1 = FindTheAudioClipsLandmarkPairs(Keypoints1, plusFrames, plusFrequencies, numberOfClosestKeypoints);
    LandmarkPairs2 = FindTheAudioClipsLandmarkPairs(Keypoints2, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    LandmarkPairs3 = FindTheAudioClipsLandmarkPairs(Keypoints3, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    LandmarkPairsFromDataTable2 = FindTheAudioClipsLandmarkPairs(dataTable2, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    
    HashTable1 = ConvertTheAudioClipsLandmarkPairsIntoHashTable(LandmarkPairs1); 
    HashTable2 = ConvertTheAudioClipsLandmarkPairsIntoHashTable(LandmarkPairs2); 
    HashTable3 = ConvertTheAudioClipsLandmarkPairsIntoHashTable( LandmarkPairs3); 
    HashTableFromDataTable2 = ConvertTheAudioClipsLandmarkPairsIntoHashTable(LandmarkPairsFromDataTable2);
    
end 