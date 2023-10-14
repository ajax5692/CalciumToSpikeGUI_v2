function CompileSpikeData(calciumToSpikeParams)

%This function creates a matrix containing all the binary spike information
%across the different layers.


cd(calciumToSpikeParams.saveAnalyzedData)

analyzedFiles = dir('*.mat');


for layerIndex = 1:calciumToSpikeParams.numLayers
        
    load(analyzedFiles(layerIndex).name)
    
    spikeData(layerIndex).layer = populationSpikeMatrix;

    clearvars -except spikeData calciumToSpikeParams analyzedFiles layerIndex
    
end


cd(calciumToSpikeParams.saveAnalyzedData)
allSpikeMatrix = vertcat(spikeData(:).layer);
save('layerWiseSpikeData.mat','spikeData')
save('allLayerSpikesPooled.mat','allSpikeMatrix')
cd(calciumToSpikeParams.originalCodePath)