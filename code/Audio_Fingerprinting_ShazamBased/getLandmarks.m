function landmarks =getLandmarks(peaks,varargin)
%   This function is used to find the landmarks of an audio signal 
%
%   Input:: 
%       peaks2 
%       plus_frames                     ( default value : 50)
%       plus_frequency_components       ( default value : 1000) 
%       number_of_nearest_peaks         ( default value : 3) 
%   Output:: 
%       landmark 

    %   length of optional inputs 
    length_of_varargin=length(varargin); 
    
    if length_of_varargin<1
        varargin{1}=  64; 
    end 
    plus_frames = varargin{1}; 
    
    
    if length_of_varargin<2 
        varargin{2}=200; 
    end
    plus_frequencies= varargin{2}; 
    
    if length_of_varargin<3 
        varargin{3}=3; 
    end 
    number_of_nearest_peaks= varargin{3}; 
    
    %   for a landmark 
    %
    %       i.      extract the peak information ( time and frequency
    %               coordinates, i.e. the anchor point ) from the matrix 'peaks2'
    %
    %       ii.     create the target zone
    %   
    %                   the target zone range is 
    %                       i.  from the current peak's frame position +
    %                           'plus_frames' frames 
    %                       ii. from the current peak's frequency component
    %                           position +/- 'plus_frequencies'
    %
    %       iii.    find the 'number_of_nearest_peaks' nearest peaks from the
    %               target zone
    %
    %       iv.     compost the 'number_of_nearest_peaks' nearest peaks
    %               with the anchor point to get the peak pairs  
    %
    %       v.      the peak-pair will be represented in the form of a
    %               landmark 
    %                               landmark = <t1, f1, f2, t2-t1> ']peaks 
    number_of_peaks = size(peaks,1); 
    
    %   landmark index 
    landmark_index=1; 
    
    for i=1:number_of_peaks 
        %   extract the frame index and the frequency component of the i-th
        %   peak 
        anchor_frame= peaks(i,1); 
        anchor_frequency = peaks(i,2); 
        
        %   create the target zone 
        %
        %   the target zone ranges 
        %       i.  from the anchor point's frame index to the anchor point's
        %           frame index + 'plus_frames'
        %   
        %       ii. from the anchor point's frequency component -
        %           'plus_frequencies' to the anchor point's frequency
        %           component + 'plus_frequencies' 
        frame_min = anchor_frame; 
        frame_max = anchor_frame+plus_frequencies; 
        
        frequency_min = anchor_frequency - plus_frequencies; 
        frequency_max = anchor_frequency + plus_frequencies; 
        
        
        %   find the indices of every point inside the target zone 
        possible_frames = peaks(:,1)> frame_min & peaks(:,1)<frame_max; 
        possible_frequencies= peaks(:,2)> frequency_min & peaks(:,2)<frequency_max; 
        
        indices_of_points_inside_target_zone = find (possible_frames & possible_frequencies);
        
        if ~isempty( indices_of_points_inside_target_zone)
            
            peaks_inside_target_zone= peaks(indices_of_points_inside_target_zone,:);
            
            if length(indices_of_points_inside_target_zone) >= number_of_nearest_peaks 
                
                %   extract the top 'number_of_nearest_peaks' peaks inside
                %   the target zone 
                landmark_peaks = peaks_inside_target_zone ( 1: number_of_nearest_peaks,:);
                
                for j=1:number_of_nearest_peaks 
                    %   set the landmark 
                    %
                    %   each landmark will have the form 
                    %           landmark = <t1, f1, f2, t2-t1>
                    %   where 
                    %       t1      :   the anchor point's frame index 
                    %       f1      :   the anchor point's frequency component 
                    %       f2      :   the frequency component of a peak
                    %                   inside the target zone 
                    %       t2-t1   :   the difference between a peak's
                    %                   inside the target zone frame index and the
                    %                   anchor point's frame index 
                    %
                    
                    landmarks(landmark_index,1)= anchor_frame;
                    landmarks(landmark_index,2)= anchor_frequency; 
                    landmarks(landmark_index,3) = landmark_peaks(j, 2); 
                    landmarks(landmark_index,4) = landmark_peaks(j,1)-anchor_frame;
                    
                    landmark_index = landmark_index+1; 
                end 
                
                
                                
                
                
            end 
        end 
        
        
    end 

       
        
        
   
end 