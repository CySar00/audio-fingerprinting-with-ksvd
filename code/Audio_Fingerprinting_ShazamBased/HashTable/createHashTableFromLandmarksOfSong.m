function hashtable = createHashTableLandmarksOfSong( songID, landmarks  )
%   This function is used to create a hashtable of a song 
%
%   The hashtable is a numberOfLandmarks x 3 matrix that contains 
%           -   the user-defined song id of a song 
%           -   a hash-key which is defined as 
%                   hash_key= (f1, ?f, ?t ) = (f1, f2-f1, t2-t1) 
%           
%           -   a hash-value which is defined as 
%                   hash_value = uint32( songID*16384 + t1% 16384) 
%   where 
%       t1          :   the frame index of an anchor point
%       f1          :   the frequency component of an anchor point 
%       f2          :   a frequency component inside the target zone 
%       t2          :   a frame index inside the target zone 
%
%   Input:: 
%       songID      :   the user-defined song-id 
%       landmarks   :   a numberOfLandmarks x 4 matrix that contains the
%                       landmarks of a song 
%   Output:: 
%       hashtable   :   a numberOfLandmarks x 3 cell array  that contains the
%                       user-defined song id, a hash-key and a hash-value
%                       of a song 

    %   number of landmarks 
    number_of_landmarks = size(landmarks, 1); 
    
    %   a landmark is of the form 
    %       landmark = <t1, f1, f2, t1-t2> 
    
    %   make sure that the frequency components f1, f2 of the landmarks are
    %   integers and 8-bits long (i.e. in the range [0,255])
    for i=1:number_of_landmarks 
        landmarks(i,2)= rem ( round (landmarks(i,2)-1), 256); 
        landmarks (i,3)= rem( round( landmarks(i,3)-1), 256); 
    end 
    
    %   create the hashtable 
    for i=1:number_of_landmarks 
        hashtable{i,1} = songID; 
        
        %   compute the hash-key 
        hash_key=zeros(1,3); 
        
        hash_key(1)= landmarks(i,2); 
        hash_key(2)=landmarks(i,3)-landmarks(i,2); 
        hash_key(3)=landmarks(i,4); 
        
        hashtable{i,2}=hash_key; 
        
        %   compute the hash-value 
        hash_value = uint32( songID*16384  + mod( landmarks(i,1), 16384));
        hashtable{i,3}=hash_value;
        
        
        %   compute 
    end 
    
    
end

