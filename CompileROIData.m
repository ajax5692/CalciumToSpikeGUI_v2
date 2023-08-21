function CompileROIData(calciumToSpikeParams)

%This function creates a matrix containing all the ROI coordinate
%information across the different layers.

for layerIndex = 1:calciumToSpikeParams.numLayers
    
    [fileName filePath] = uigetfile('',strcat('Open the layer', " ", num2str(layerIndex)," ",'data that was obtained using the CalciumToSpike GUI'));
    cd(filePath)
    load(fileName)
    
    roiCoordData(layerIndex,1).layer = xCoord;
    roiCoordData(layerIndex,2).layer = yCoord;

    clearvars -except roiCoordData calciumToSpikeParams
    
end

cd(calciumToSpikeParams.saveAnalyzedData)
allROIMatrix = [horzcat(roiCoordData(:,1).layer); horzcat(roiCoordData(:,2).layer);];
save('layerWiseRoiCoordData.mat','roiCoordData')
save('allLayerROIsPooled.mat','allROIMatrix')
cd(calciumToSpikeParams.originalCodePath)