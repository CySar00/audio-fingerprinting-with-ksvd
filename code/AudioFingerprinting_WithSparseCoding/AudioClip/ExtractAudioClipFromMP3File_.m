function AudioClip = ExtractAudioClipFromMP3File_(mp3, clipDuration)
%
%   Input:: 
%       mp3 
%       clipDuration 
%
%   Output:: 
%       AudioClip 

    mp3_Title = mp3(1); 
    mp3_audioSignal = cell2mat(mp3(2)); 
    mp3_samplingRate = cell2mat(mp3(3)); 

    if nargin<2 
        clipDuration = 10; 
    end 
    
    %   convert the audio signal from stereo to mono 
    if size(mp3_audioSignal,2)>1
        mp3_audioSignal = sum(mp3_audioSignal,2)/2;
    end 
    mp3Length = length(mp3_audioSignal); 
    
    tt_ = 0:(1/mp3_samplingRate): (mp3Length-1)/mp3_samplingRate; 
    
    audioClip_startIndex = randi( round( (mp3Length-1)/mp3_samplingRate)); 
    audioClip_endIndex = audioClip_startIndex+clipDuration; 
    
    
    if audioClip_startIndex > ((mp3Length-1)/mp3_samplingRate)-clipDuration
        indices_ = tt_>=audioClip_startIndex; 
        
        audioClip= mp3_audioSignal(indices_); 
        audioClip = [audioClip; zeros( clipDuration*mp3_samplingRate-length(audioClip),1)];
    
    else 
        indices_  = tt_>=audioClip_startIndex & tt_<audioClip_endIndex; 
        audioClip = mp3_audioSignal(indices_); 
    end 
    
    
    AudioClip{1}= audioClip; 
    AudioClip{2}= mp3_samplingRate; 
    %sound(audioClip, mp3_samplingRate); 



end 