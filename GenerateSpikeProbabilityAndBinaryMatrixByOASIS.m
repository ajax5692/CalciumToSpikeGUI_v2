function [populationSpikeMatrix, populationSpikeProbability, w] = GenerateSpikeProbabilityAndBinaryMatrixByOASIS(deltaff,w)

%GenerateSpikeProbabilityAndBinaryMatrixByOASIS
%This function takes in the df/f values and evaluates the spike
%probabilities based on the OASIS module and the generates a binary 1/0
%matrix corresponding to the spikes.


w = multiWaitbar('OASIS',0,'Color','b');

totalCells = size(deltaff,1);
oasis_setup

for cellIndex = 1:size(deltaff,1)
    
    w = multiWaitbar('OASIS', (cellIndex/totalCells));
    
    [c, s, options] = deconvolveCa(deltaff(cellIndex,:), 'thresholded', 'ar1', 'smin', -3, 'optimize_pars', true, 'optimize_b', true);
    
    populationSpikeProbability(cellIndex,:) = s;
    
    clear c s options
                
end


%Generate 1/0 spike matrix for the population

for cellIndex = 1:size(populationSpikeProbability,1)
    
    for frameIndex = 1:size(populationSpikeProbability,2)
        
        if populationSpikeProbability(cellIndex,frameIndex) > 0
            
            populationSpikeMatrix(cellIndex,frameIndex) = 1;
                
        else
                
            populationSpikeMatrix(cellIndex,frameIndex) = 0;
                
        end
    end
end

w = multiWaitbar('OASIS','Reset','Close');