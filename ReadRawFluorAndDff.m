function [deltaff,PSNR] = ReadRawFluorAndDff_original(calciumToSpikeParams)

%ReadRawFluorAndDff_MOD
%This function reads the raw cell fluorescence data (neuropil subtracted)
%from the Fall.mat file generated by Suite2p and then creates a matrix
%containing all the df/f data by 

%The Fall.mat file from Suite2p has the variable F and Fneu corresponding to
%the raw fluorescence and the neuropil fluorescence data respectively.


[matFilename matFilepath] = uigetfile('','Open the fluorescence data from Suite2p');
cd(matFilepath)
load(matFilename);


[mescFilename mescFilepath] = uigetfile('*.mesc','Select the original Mesc file to obtain frame rate data');
cd(mescFilepath)
tStepsInMs = h5readatt(strcat(mescFilepath,mescFilename),'/MSession_0/MUnit_20/','TStepInMs');
warning off

frameRate = (1/tStepsInMs)*1000;
timeStamp = (1:numel(F(1,:))).*(1/frameRate); %This is in seconds

% %Sanity check of the fluorescence trace
% figure
% plot(timeStamp,F(1,:))
% xlabel('Time(s)')
% ylabel('Raw fluorescence (AU)')
% xlim([0 timeStamp(end)])


%This section now evaluates the df/f by the (F-Fneu)/Fneu method
%There are several conditions, which if met, would lead to df/f
%calculation: (1)It has to be a cell, (2)It has to have values of cell
%probability higher than the threshold value what was set in the suite2p
%classifier(generally 0.5)


f = waitbar(0, 'Starting');
n = sum(isCell(:,1));
counter = 0;
cellCounter = 1;
newCounter = 0;

%Calculating PSNR values for all cells. This is done to remove cells having
%PSNR values > 4SD of all the PSNR values
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

   


for cellIndex = 1:size(F,1)
    
    switch calciumToSpikeParams.cellProbThres
        
        case 1
            
            waitbar(cellCounter/n, f, sprintf('Progress', floor(cellCounter/n*100)));
            
            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold
                
                counter = counter + 1;
                
                %Applying PSNR filter. PSNR minimum value sould be 18dB and
                %maximum value should not exceed 4 SD value
                
                if 4*std(PSNR) > min(PSNR)
                    
                    if PSNR(counter) > 18 & PSNR(counter) < 4*std(PSNR)

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;

                    elseif PSNR(counter) > 18

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;
                        
                    else
                        continue
                    end
                    
                else
                    
                    if PSNR(counter) > 18

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;

                    else
                        continue
                    end
                end

            else
                continue
            end

            
             case 0
                 
                 if isCell(cellIndex,1) == 1
                     
                     newCounter = newCounter + 1;
                     
                     waitbar(newCounter/n, f, sprintf('Progress', floor(cellCounter/n*100)));

                     %Applying PSNR filter. PSNR minimum value sould be 18dB and
                     %maximum value should not exceed 4 SD value
                     
                     if 4*std(PSNR) > min(PSNR)
                         
                         if PSNR(newCounter) > 18 & PSNR(newCounter) < 4*std(PSNR)

                             neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                             [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                             deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                         elseif PSNR(newCounter) > 18

                             neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                             [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                             deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                          else
                            continue
                         end
                         
                     else
                         
                         if PSNR(newCounter) > 18

                             neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                             [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                             deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                         else
                            continue
                         end
                         
                     end

                else
                    continue
                end

    end
                 
                 
end

close(f)

%This deletes the zero vectors that can originate due to PSNR filtering.
deltaff(any(isnan(deltaff), 2), :) = [];
deltaff( all(~deltaff,2), : ) = [];



deltaff = double(deltaff);



warning on

% %Sanity check of the interpolated fluorescence trace
% figure
% for ii = 1:size(dffByMedian,1)
%     plot(timeStamp,dffByMedian(ii,:))
%     xlabel('Time(s)')
%     ylabel('Raw fluorescence (AU)')
%     xlim([0 timeStamp(end)])
%     pause
% end



    