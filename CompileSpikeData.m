function CompileSpikeData(calciumToSpikeParams)

%This function creates a matrix containing all the binary spike information
%across the different layers.



for layerIndex = 1:calciumToSpikeParams.numLayers
    
    [fileName filePath] = uigetfile('',strcat('Open the layer', " ", num2str(layerIndex)," ",'data that was obtained using the CalciumToSpike GUI'));
    cd(filePath)
    load(fileName)
    
    spikeData(layerIndex).layer = populationSpikeMatrix;

    clearvars -except spikeData calciumToSpikeParams
    
end


cd(calciumToSpikeParams.saveAnalyzedData)
allSpikeMatrix = vertcat(spikeData(:).layer);
save('layerWiseSpikeData.mat','spikeData')
save('allLayerSpikesPooled.mat','allSpikeMatrix')
cd(calciumToSpikeParams.originalCodePath)