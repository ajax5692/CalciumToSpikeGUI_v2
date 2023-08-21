function [PSNR] = PSNRcalculation(F,Fneu,isCell,calciumToSpikeParams)

%This is done to remove cells having PSNR values > 4SD or <18 dB.
%PSNR value is calculated using the formula:
%PSNR = 20*log10max(F-Fneu/std(Fneu));

PSNRcounter = 1;

for cellIndex = 1:size(F,1)
    
    switch calciumToSpikeParams.cellProbThres
        
        case 1
            
            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold
                
                PSNR(PSNRcounter) = 20 * log10(max(F(cellIndex,:)-Fneu(cellIndex,:))/std(Fneu(cellIndex,:)));
                PSNRcounter = PSNRcounter + 1;
                
            else
                continue
            end
            
        case 0
            
            if isCell(cellIndex,1) == 1
                
                PSNR(PSNRcounter) = 20 * log10(max(F(cellIndex,:)-Fneu(cellIndex,:))/std(Fneu(cellIndex,:)));
                PSNRcounter = PSNRcounter + 1;
                
            else
                continue
            end
    end
end