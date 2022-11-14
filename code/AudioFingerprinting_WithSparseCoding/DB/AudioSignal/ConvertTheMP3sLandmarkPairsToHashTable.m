function HashTable = ConvertTheMP3sLandmarkPairsToHashTable(songID, LandmarkPairs)
%
%   Input:: 
%       songID 
%       LandmarkPairs 
%
%   Output:: 
%       HashTable 

    HashTable=zeros(size(LandmarkPairs,1),1); 
    
    for i=1:size(LandmarkPairs,1)
        LandmarkPair_i =LandmarkPairs(i,:); 
        
        hashKey= ConvertLandmarkPairIntoHashKey(LandmarkPair_i); 
        
        HashTable(i,1)=uint32(songID); 
        HashTable(i,2)= hashKey; 
        HashTable(i,3)= uint32(LandmarkPair_i(1));
    end
end 