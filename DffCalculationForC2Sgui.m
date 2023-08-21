function deltaff = DffCalculationForC2Sgui(F,calciumToSpikeParams,isCell,Fneu,PSNR)

%This function evaluates the dF/F values for only those cells whose
%criteria are defined by the user.


frameRate = calciumToSpikeParams.frameRate;
timeStamp = (1:numel(F(1,:))).*(1/calciumToSpikeParams.frameRate); %This is in seconds

w = waitbar(0, 'Starting');
n = sum(isCell(:,1));
counter = 0;
cellCounter = 1;
newCounter = 0;


for cellIndex = 1:size(F,1)

    switch calciumToSpikeParams.cellProbThres

        case 1 %If both cell detection and cell probability values are the criteria

            waitbar(cellCounter/n, w, sprintf('Progress', floor(cellCounter/n*100)));

            if isCell(cellIndex,1) == 1 & isCell(cellIndex,2) >= calciumToSpikeParams.cellClassifierThreshold

                counter = counter + 1;

                %Applying PSNR filter. PSNR minimum value sould be 18dB and maximum value should not exceed 4 SD value

                if 4*std(PSNR) > min(PSNR) %This is to prevent the code from crasing if the 4SD value is smaller than the min(PSNR) value

                    if PSNR(counter) > 18 & PSNR(counter) < 4*std(PSNR) %Here the actual PSNR range bound filtering takes place

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,calciumToSpikeParams.frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;

                    elseif PSNR(counter) > 18 %This happens if the upper limit of 4SD PSNR cannot be applied

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;

                    else %This step means no cell fulfilled the PSNR criteria and hence needs to be omitted for analysis
                        continue
                    end

                else %This step means the 4SD value is smaller than the min(PSNR) value

                    if PSNR(counter) > 18 %This happens if the upper limit of 4SD PSNR cannot be applied

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(cellCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                        cellCounter = cellCounter + 1;

                    else %This step means no cell fulfilled the PSNR criteria and hence needs to be omitted from analysis
                        continue
                    end
                end

            else %If both cell detection and cell probability values are the criteria and neither criteria is met, the cell is omitted from analysis
                continue
            end


        case 0 %If just cell detection is the criteria

            if isCell(cellIndex,1) == 1

                newCounter = newCounter + 1;

                waitbar(newCounter/n, w, sprintf('Progress', floor(cellCounter/n*100)));


                %Applying PSNR filter. PSNR minimum value sould be 18dB and maximum value should not exceed 4 SD value

                if 4*std(PSNR) > min(PSNR) %This is to prevent the code from crasing if the 4SD value is smaller than the min(PSNR) value

                    if PSNR(newCounter) > 18 & PSNR(newCounter) < 4*std(PSNR) %Here the actual PSNR range bound filtering takes place

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                    elseif PSNR(newCounter) > 18 %This happens if the upper limit of 4SD PSNR cannot be applied

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                    else %This step means no cell fulfilled the PSNR criteria and hence needs to be omitted for analysis
                        continue
                    end

                else %This step means the 4SD value is smaller than the min(PSNR) value

                    if PSNR(newCounter) > 18 %This happens if the upper limit of 4SD PSNR cannot be applied

                        neuropilSubtractedFluor = F(cellIndex,:) - 0.7*Fneu(cellIndex,:); %70 percent of neuropil subtracted
                        [LONG_KERNEL_COEFF, SHORT_KERNEL_COEFF] = CalculateKernelCoefficientsForDffCalculation(neuropilSubtractedFluor,frameRate);
                        deltaff(newCounter,:) = CalculateDff(timeStamp,neuropilSubtractedFluor,'median',LONG_KERNEL_COEFF,SHORT_KERNEL_COEFF);

                    else %This step means no cell fulfilled the PSNR criteria and hence needs to be omitted from analysis
                        continue
                    end

                end

            else %If cell detection criteria is not met, the cell is omitted from analysis
                continue
            end

    end %This ends the switching criterial from enabling or disabling cell probability threshold


end

close(w)

%This deletes the zero vectors that can originate due to PSNR filtering.
deltaff(any(isnan(deltaff), 2), :) = [];
deltaff( all(~deltaff,2), : ) = [];



deltaff = double(deltaff);