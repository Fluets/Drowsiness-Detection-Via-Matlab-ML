clear;
clc;

%% Get the data

focusedData = dir('EEG_Data_Focused');
focusedData = focusedData(3:end); % Remove the first two entries as they represent folders, not files (. and .., respectively)

drowsyData = dir('EEG_Data_Drowsy');
drowsyData = drowsyData(3:end); % Remove the first two entries as they represent folders, not files (. and .., respectively)


%% Variables to be used for calculating

% Initialize the array that will hold energy feature for a single channel 
oneChannelEnergyFeature=[];
% Initialize the arrays that will hold energy features
energyFeaturesFocused=[];
energyFeaturesDrowsy=[];

% Initialize the array that will hold the MAD feature for a single channel
oneChannelMADFeatures=[];
% Initialize the arrays that will hold the MAD features
MADFeaturesFocused=[];
MADFeaturesDrowsy=[]; 

%% Pre-proccessing focused

for sampleNumber = 1:length(focusedData)
    sampleName = sprintf('EEG_Data_Focused\\eeg_focused_record%d.mat', sampleNumber);
    sample = load(sampleName).firstChunk;
    
%    % Uncomment in order to observe manual denoising (1 of 3)
%     figure()
%     tiledlayout(2,1)
        
    for channelNumber = 1:14
        channel = sample(:,channelNumber);
        
        %% Wavelet Denoising
        
        % Calculate default noise threshold using global threshold
        [threshold,sorh,keepapp] = ddencmp('den','wv',channel);
        
%        % Uncomment to increase threshhold by 10^5 to have a more noticeable
%        % effect denoising (bad idea) - ALSO UNCOMMENT FOR DROWSY IF YOU DO
%        threshold = threshold*10^5;
        

%         % Method 1: Wavelet denoising using Daubechies wavelet
%         cleanChannel = wdencmp('gbl',channel,'db3',2,threshold,sorh,keepapp);
        

        % Method 2: Manual denoising with FFT 
        %Compute the FFT
        channelLength = length(channel);
        fHat = fft(channel, channelLength); 
        
%        % Uncomment in order to observe manual denoising (2 of 3)
%         hold on 
%         nexttile(1)
%         plot(abs(fHat))
%         hold off
        
        %Remove noisy frequencies
        PSD = fHat.*conj(fHat)/channelLength;
        frequency = 1/(0.001*channelLength)*(0:channelLength); %Create x-axis of frequencies in Hz
        L = 1:floor(channelLength/2);
        fHat(abs(fHat)<threshold) = 0;
        
%        % Uncomment in order to observe manual denoising (3 of 3)
%         hold on
%         nexttile(2)
%         plot(abs(fHat))
%         hold off
        
        %Inverse FFT to get clean signal
        cleanChannel = ifft(fHat);
        
        %% Feature extraction
        % Energy
        oneChannelEnergyFeature(channelNumber)=sum(cleanChannel.^2);
        
        % Mean absolute deviation
        oneChannelMADFeatures(channelNumber) = mad(cleanChannel,1);
        % Mad(X,0) uses the means and mad(X,1) uses the medians
    end
    
        
    energyFeaturesFocused = [energyFeaturesFocused; oneChannelEnergyFeature];
    MADFeaturesFocused = [MADFeaturesFocused; oneChannelMADFeatures];
    
    % Reset the arrays for next use
    oneChannelEnergyFeature = [];
    oneChannelMADFeatures = [];
    
end


%% Pre-proccessing drowsy

for sampleNumber = 1:length(drowsyData)
    sampleName = sprintf('EEG_Data_Drowsy\\eeg_drowsy_record%d.mat', sampleNumber);
    sample = load(sampleName).thirdChunk;
    for channelNumber = 1:14
        channel = sample(:,channelNumber);
        
        %% Wavelet Denoising
        
        % Calculate default noise threshold
        [threshold,sorh,keepapp] = ddencmp('den','wv',channel);
        
%        % Uncomment to increase threshhold by 10^5 to have a more noticeable
%        % effect denoising (bad idea) - ALSO UNCOMMENT FOR FOCUSED IF YOU DO
%       threshold = threshold*10^5;
        

%        % Method 1: Wavelet denoising using Daubechies wavelet
%        cleanChannel = wdencmp('gbl',channel,'db3',2,threshold,sorh,keepapp);
        

        % Method 2: Manual denoising with FFT 
        %Compute the FFT
        channelLength = length(channel);
        fHat = fft(channel, channelLength); 
        
        %Remove noisy frequencies
        PSD = fHat.*conj(fHat)/channelLength;
        frequency = 1/(0.001*channelLength)*(0:channelLength); %Create x-axis of frequencies in Hz
        L = 1:floor(channelLength/2);
        fHat(abs(fHat)<threshold) = 0;
        
        %Inverse FFT to get clean signal
        cleanChannel = ifft(fHat);

        
        %% Feature extraction
        % Energy
        oneChannelEnergyFeature(channelNumber)=sum(cleanChannel.^2);
        
        % Mean absolute deviation
        oneChannelMADFeatures(channelNumber) = mad(cleanChannel,1);
        % Mad(X,0) uses the means and mad(X,1) uses the medians
    end
    
    energyFeaturesDrowsy = [energyFeaturesDrowsy; oneChannelEnergyFeature];
    MADFeaturesDrowsy = [MADFeaturesDrowsy; oneChannelMADFeatures];
    
    % Reset the arrays
    oneChannelEnergyFeature = [];
    oneChannelMADFeatures = [];
    
end