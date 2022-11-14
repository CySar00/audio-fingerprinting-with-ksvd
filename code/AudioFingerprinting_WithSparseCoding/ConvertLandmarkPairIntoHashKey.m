function hashKey= ConvertLandmarkPairIntoHashKey(landmarkPair)
%
%   Input:: 
%       landmarkPair 
%
%   Output:: 
%       hashKey 
%
%   This function is convert a landmark pair into a hash key
%
%   The hash key is a 20-bit number with the following structure 
%          19               11              5                0 
%       --|-----------------|---------------|----------------|--
%         |   f1            |      f2-f1    |   delta_t      |
%       --|-----------------|---------------|----------------|--
%         |<--- 8 bits ---->|<---6 bits --->|<--- 6 bits --->|


    f1 = landmarkPair(2); 
    f2 = landmarkPair(3); 
    delta_t = landmarkPair(4); 
    
    %   set the range of 'f1' to [0, 255]
    Freq1 = mod( round(f1-1),2^8); 
    
    delta_f = f2-f1; 
    
    %   set the range of 'delta_f' to [0, 127] 
    if delta_f <0
        delta_f = delta_f+2^6;
    end 
    DeltaFreq=mod(round(delta_f-1), 2^6); 
    
    %   set the range of 'delta_t' to [0,127]
    DeltaTime = mod(round(delta_t-1), 2^6); 
    
    binaryDeltaFreq1= de2bi( Freq1,8); 
    binaryDeltaFreq = de2bi(DeltaFreq,6); 
    binaryDeltaTime = de2bi(DeltaTime, 6); 
    
    sum1=0; 
    sum2=0; 
    sum3=0; 
    hashKey=0;
    
    for i=1:length(binaryDeltaFreq1)
        sum1= sum1 + (2^(i+11))*binaryDeltaFreq1(i); 
    end 
    
    for i=1:length(binaryDeltaFreq)
        sum2 = sum2+ (2^(i+5))*binaryDeltaFreq(i); 
    end 
    
    for i=1:length(binaryDeltaTime)
        sum3 = sum3 + (2^(i-1))*binaryDeltaTime(i); 
    end 

    hashKey = sum1+sum2+sum3;
end 