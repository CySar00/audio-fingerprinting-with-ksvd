function [AudioFrames, SparseCoefficientMatrix,...
    Keypoints1, Keypoints2, Keypoints3, dataTable1, dataTable2,...
    LandmarkPairs1, LandmarkPairs2, LandmarkPairs3, LandmarkPairsFromDataTable2,...
    HashTable1, HashTable2, HashTable3, HashTableFromDataTable2] = ...
    ConvertTheMP3IntoSparseCoefficientMatrixFingerPrintAndHashTable(songID, mp3, D, varargin)
%
%   Input:: 
%       songID
%       mp3 
%       D 
%       
%       samplingRate_toResample 
%       frame 
%       overlapFactor 
%       
%       numberOfSparseCoefficients 
%       epsilon 
%       errorFunction 
%       Options 
%
%       numberOfKeypoints 
%       numberOfKeypointsPerFrame1 
%       threshold1 
%       numberOfKeypointsPerFrame2 
%       threshold2 
%
%       N
%       sigma 
%       numberOfKeypointsKept 
%       decayRate 
%
%   Output:: 
%       AudioFrames 
%       SparseCoefficientMatrix 
%
%       Keypoints1
%       Keypoints2
%       Keypoints3
%       dataTable1 
%       dataTable2 
%   
%       LandmarkPairs1
%       LandmarkPairs2 
%       LandmarkPairs3 
%       LandmarkPairsFromDataTable2
%       
%       HashMap1 
%       HashMap2 
%       HashMap3
%       HashMapFromDataTable2 

    lengthOfVarargin=length(varargin); 
    
    if lengthOfVarargin<1 
        varargin{1}= 8000;
    end 
    samplingRate_toResample= varargin{1}; 
    
    if lengthOfVarargin<2
        varargin{2}= 256/samplingRate_toResample; 
    end 
    frame = varargin{2}; 
    
    if lengthOfVarargin<3
        varargin{3}= 0.5;
    end 
    overlapFactor =varargin{3}; 
    
    if lengthOfVarargin<4 
        varargin{4}= randi(size(D,2));
    end 
    numberOfSparseCoefficients = varargin{4}; 
    
    if lengthOfVarargin<5 
        varargin{5}= eps;
    end 
    epsilon =varargin{5}; 
    
    if lengthOfVarargin<6
        varargin{6}=[]; 
    end
    errorFunction = varargin{6}; 
    
    if lengthOfVarargin<7
        varargin{7}=[]; 
    end 
    Options = varargin{7}; 
    
    if lengthOfVarargin<8
        varargin{8}= 500; 
    end 
    numberOfKeypoints = varargin{8}; 
    
    if lengthOfVarargin<9
        varargin{9}= 10; 
    end 
    numberOfKeypointsPerFrame1 = varargin{9}; 
    
    if lengthOfVarargin<10
        varargin{10}= 0.5;
    end 
    threshold1= varargin{10}; 
    
    if lengthOfVarargin<11
        varargin{11}= 5; 
    end 
    numberOfKeypointsPerFrame2 = varargin{11}; 
    
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
    sigma = varargin{14}; 
    
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
   

    AudioFrames = SegmentTheMP3IntoAudioFrames(mp3, samplingRate_toResample, frame, overlapFactor); 
    
    SparseCoefficientMatrix = CalculateTheMP3sSparseCoefficientMatrix(AudioFrames,D, numberOfSparseCoefficients, epsilon, errorFunction, Options); 
    
    Keypoints1= FindTheMP3sSparseKeypoints(SparseCoefficientMatrix,numberOfKeypoints); 
    [Keypoints2, Keypoints3]= FindTheMP3sSparseKeypoints_(SparseCoefficientMatrix, numberOfKeypointsPerFrame1, threshold1, numberOfKeypointsPerFrame2, threshold2); 
    
    dataTable1= FowardSmoothTheMP3sSparseMatrix(SparseCoefficientMatrix,N,sigma, numberOfKeypointsKept,decayRate); 
    dataTable2 = BackwardSmoothTheMP3sSparseMatrix(SparseCoefficientMatrix,dataTable1, sigma, decayRate); 
    
    LandmarkPairs1= FindTheMP3sSparseLandmarkPairs(Keypoints1, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    LandmarkPairs2= FindTheMP3sSparseLandmarkPairs(Keypoints2, plusFrames, plusFrequencies, numberOfClosestKeypoints);   
    LandmarkPairs3= FindTheMP3sSparseLandmarkPairs(Keypoints3, plusFrames, plusFrequencies, numberOfClosestKeypoints);    
    LandmarkPairsFromDataTable2= FindTheMP3sSparseLandmarkPairs(dataTable2, plusFrames, plusFrequencies, numberOfClosestKeypoints);
    
    HashTable1= ConvertTheMP3sLandmarkPairsToHashTable(songID,LandmarkPairs1);
    HashTable2= ConvertTheMP3sLandmarkPairsToHashTable(songID,LandmarkPairs2);
    HashTable3= ConvertTheMP3sLandmarkPairsToHashTable(songID,LandmarkPairs3);
    HashTableFromDataTable2= ConvertTheMP3sLandmarkPairsToHashTable(songID,LandmarkPairsFromDataTable2);
end 