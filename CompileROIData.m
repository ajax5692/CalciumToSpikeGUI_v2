function CompileROIData(calciumToSpikeParams)

%This function creates a matrix containing all the ROI coordinate
%information across the different layers.

cd(calciumToSpikeParams.saveAnalyzedData)

analyzedFiles = dir('*.mat');

for layerIndex = 1:calciumToSpikeParams.numLayers
    
    load(analyzedFiles(layerIndex).name)
    
    roiCoordData(layerIndex,1).layer = xCoord;
    roiCoordData(layerIndex,2).layer = yCoord;

    clearvars -except roiCoordData calciumToSpikeParams analyzedFiles layerIndex
    
end

cd(calciumToSpikeParams.saveAnalyzedData)
allROIMatrix = [horzcat(roiCoordData(:,1).layer); horzcat(roiCoordData(:,2).layer);];
save('layerWiseRoiCoordData.mat','roiCoordData')
save('allLayerROIsPooled.mat','allROIMatrix')
cd(calciumToSpikeParams.originalCodePath)