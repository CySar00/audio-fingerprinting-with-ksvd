function AudioClip = ExtractTheAudioClipFromTheMP3(pathToMP3File, clipDuration)
%
%   Input:: 
%       pathToMP3File 
%       clipDuration 
%
%   Output::
%       AudioClip 

    
    if nargin<2 
        clipDuration= 10; 
    end
    
    AudioClip={};
    
    %   read the mp3 file 
    [mp3_audioSignal, mp3_samplingRate]= audioread(pathToMP3File); 
    
    %   convert the mp3 audio signal from stereo to mono
    if size(mp3_audioSignal,2)>1 
        mp3_audioSignal = sum(mp3_audioSignal,2)/2; 
    end 
    
    mp3Length= length(mp3_audioSignal);
    
    tt_ = 0:(1/mp3_samplingRate): (mp3Length-1)/mp3_samplingRate; 
    
    audioClip_startIndex = randi(round((mp3Length-1)/mp3_samplingRate)); 
    audioClip_endIndex = audioClip_startIndex+clipDuration; 
    
    audioClip = zeros( clipDuration*mp3_samplingRate,1); 
    if audioClip_startIndex>(mp3Length-1)/mp3_samplingRate - clipDuration
        indices_ = tt_>=audioClip_startIndex; 
        
        audioClip1= mp3_audioSignal(indices_); 
        audioClip(1:length(audioClip1))= audioClip1; 
    else 
        indices_ = tt_>= audioClip_startIndex & tt_<audioClip_endIndex; 
        
        audioClip= mp3_audioSignal(indices_); 
         
    end 
    sound(audioClip,mp3_samplingRate); 
    
    AudioClip{1}= audioClip; 
    AudioClip{2}= mp3_samplingRate; 
end 