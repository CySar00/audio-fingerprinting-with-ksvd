function [STFTs, magnitudes, magnitudesWithNoNoise, ...
    normalizedMagnitudesWithNoNoise, filteredMagnitudes,...
    SparseCoefficientMatrix,...
    Keypoints1, Keypoints2, Keypoints3, dataTable1, dataTable2,...
    LandmarkPairs1, LandmarkPairs2, LandmarkPairs3, LandmarkPairsFromDataTable2,...
    HashTable1, HashTable2, HashTable3, HashTableFromDataTable2]=...
    ConvertTheMP3IntoSparseSpectrogramFingerPrintAndHashTable(songID, mp3, D, varargin)
%
%   Input:: 
%       mp3 
%
%   Output:: 

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
        varargin{3}=0.5; 
    end 
    overlapFactor = varargin{3}; 
    
    if lengthOfVarargin<4
        varargin{4}= 'hamming';
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
    
    if lengthOfVarargin<9
        varargin{9}=0.98;
    end 
    halfPole = varargin{9}; 
    
    if lengthOfVarargin<10
        varargin{10} = randi(size(D,2)); 
    end 
    numberOfSparseCoefficients= varargin{10}; 
    
    
    if lengthOfVarargin<11
        varargin{11}=eps; 
    end 
    epsilon = varargin{11}; 
    
    if lengthOfVarargin<12 
        varargin{12}= [];
    end 
    errorFunction = varargin{12}; 
    
    if lengthOfVarargin<13 
        varargin{13}= []; 
    end 
    Options = varargin{13}; 
    
    if lengthOfVarargin<14 
        varargin{14}= 500; 
    end 
    numberOfKeypoints= varargin{14}; 

    if lengthOfVarargin<15
        varargin{15}= 10; 
    end 
    numberOfKeypointsPerFrame1= varargin{15}; 
    
    if lengthOfVarargin<16
        varargin{16}= 0.5; 
    end 
    threshold1= varargin{16}; 
    
    if lengthOfVarargin<17
        varargin{17}= 5; 
    end 
    numberOfKeypointsPerFrame2 = varargin{17}; 
    
    if lengthOfVarargin<18
        varargin{18}= 0.75; 
    end 
    threshold2 = varargin{18}; 
    
    if lengthOfVarargin<19
        varargin{19}= 10; 
    end 
    N= varargin{19}; 
    
    if lengthOfVarargin<20
        varargin{20}= 30; 
    end 
    sigma = varargin{20}; 
    
    if lengthOfVarargin<21
        varargin{21}= 5; 
    end 
    numberOfKeypointsKept= varargin{21}; 
    
    if lengthOfVarargin<22
        varargin{22}= 0.9943;
    end 
    decayRate = varargin{22}; 
    
    if lengthOfVarargin<23
        varargin{23}= 64;
    end 
    plusFrames = varargin{23}; 
    
    if lengthOfVarargin<24
        varargin{24}= 32; 
    end 
    plusFrequencies = varargin{24}; 
    
    if lengthOfVarargin<25
        varargin{25}= 3; 
    end 
    numberOfClosestKeypoints = varargin{25}; 
    
    
    [STFTs, magnitudes, magnitudesWithNoNoise, normalizedMagnitudesWithNoNoise]=...
        CalculateTheMP3sSpectrogram(...
        mp3, samplingRate_toResample, frame, overlapFactor,...
        windowType, windowLength, windowAmplitude, windowSFlag,...
        B...
        ); 
    
    filteredMagnitudes = HighPassFilterTheMP3sSpectrogram( normalizedMagnitudesWithNoNoise, halfPole); 
    
    SparseCoefficientMatrix = CalculateTheMP3sSpectrogramsSparseMatrix( cell2mat(mp3(1)), filteredMagnitudes, D, numberOfSparseCoefficients, epsilon, errorFunction, Options); 
    
    Keypoints1= FindTheMP3sSparseSpectrogramsKeypoints( SparseCoefficientMatrix, numberOfKeypoints);
    [Keypoints2, Keypoints3] = FindTheMP3sSparseSpectrogramsKeypoints_(SparseCoefficientMatrix, numberOfKeypointsPerFrame1, threshold1, numberOfKeypointsPerFrame2, threshold2); 
    
    dataTable1 = FowardSmoothTheMP3sSpectrogramsSparseMatrix(SparseCoefficientMatrix, N,sigma, numberOfKeypointsKept, decayRate); 
    dataTable2 = BackwardSmoothTheMP3sSpectrogramsSparseMatrix(SparseCoefficientMatrix,dataTable1, sigma, decayRate); 
    
    LandmarkPairs1= FindTheMP3sSparseSpectrogramsLandmarkPairs(Keypoints1, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    LandmarkPairs2= FindTheMP3sSparseSpectrogramsLandmarkPairs(Keypoints2, plusFrames, plusFrequencies, numberOfClosestKeypoints); 
    LandmarkPairs3= FindTheMP3sSparseSpectrogramsLandmarkPairs(Keypoints3, plusFrames, plusFrequencies, numberOfClosestKeypoints);
    LandmarkPairsFromDataTable2= FindTheMP3sSparseSpectrogramsLandmarkPairs(dataTable2, plusFrames, plusFrequencies, numberOfClosestKeypoints);
    
    HashTable1 = ConvertTheMP3sSparseLandmarksIntoHashTable(songID, LandmarkPairs1); 
    HashTable2 = ConvertTheMP3sSparseLandmarksIntoHashTable(songID, LandmarkPairs2);    
    HashTable3 = ConvertTheMP3sSparseLandmarksIntoHashTable(songID, LandmarkPairs3); 
    HashTableFromDataTable2 = ConvertTheMP3sSparseLandmarksIntoHashTable(songID, LandmarkPairsFromDataTable2); 
end 