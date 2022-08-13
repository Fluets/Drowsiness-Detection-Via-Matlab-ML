clear;
clc;
%% For file in folder
for i = 1 : 34
    
    matFileName = sprintf('EEG_Data\\eeg_record%d.mat', i);
    if isfile(matFileName)
        %% Get the data
		lore = load(matFileName);
        data = lore.o.data;
        
        %% Split data into three chunks, discard the middle chunk
        numRows = size(data,1);
        numExcessRows = mod(numRows, 128);
        idealNumRows = numRows - numExcessRows;
        numFrames = idealNumRows/128;
        numFramesInChunk = floorDiv((numFrames), 3); %May round up unexpectedly (precision error?)
        numRowsInChunk = numFramesInChunk*128;
        
        firstChunk = data(1:numRowsInChunk, 4:17);                  %From row 1 to the first third
        thirdChunk = data((2*numRowsInChunk):idealNumRows, 4:17);   %From two thirds to the end
        
        %% Save first chunks into one folder and third chunks into another
        focusedMatFileName = sprintf('EEG_Data_Focused\\eeg_focused_record%d.mat', i);
        drowsyMatFileName = sprintf('EEG_Data_Drowsy\\eeg_drowsy_record%d.mat', i);
        save(focusedMatFileName, 'firstChunk')
        save(drowsyMatFileName, 'thirdChunk')
        
	else
		fprintf('File %s does not exist.\n', matFileName);
    end
end
%End