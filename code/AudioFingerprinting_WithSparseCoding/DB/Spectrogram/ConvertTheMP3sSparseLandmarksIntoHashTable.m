function HashTable = ConvertTheMP3sSparseLandmarksIntoHashTable(songID, LandmarkPairs)
%
%   Input:: 
%       LandmarkPairs 
%
%   Output:: 
%       HashTable 

    HashTable =zeros(size(LandmarkPairs,1),3); 
    
    for i=1:size(LandmarkPairs,3)
        LandmarkPair_i = LandmarkPairs(i,:); 
        
        hashKey = ConvertLandmarkPairIntoHashKey(LandmarkPair_i); 
        
        HashTable(i,1)=uint32(songID); 
        HashTable(i,2)= hashKey; 
        HashTable(i,3)= uint32(LandmarkPair_i(1));
            
    end 

end 