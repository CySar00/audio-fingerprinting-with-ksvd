function HashMap = ConvertTheMP3sHashTableIntoHashMap(HashTable)
%
%   Input:: 
%       HashTable 
%
%   Output:: 
%       HashMap 
    
    keySet =zeros(size(HashTable,1),1); 
    valueSet = zeros(size(HashTable,1),1); 
    
    for i=1:size(HashTable,1)
        keySet(i)= HashTable(i,2);
        valueSet(i)= HashTable(i,3); 
    end 
    
    HashMap = containers.Map(keySet,valueSet);


end 