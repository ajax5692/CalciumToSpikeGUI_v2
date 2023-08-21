function varargout = CalciumToSpikeGUI(varargin)
% CALCIUMTOSPIKEGUI MATLAB code for CalciumToSpikeGUI.fig
%      CALCIUMTOSPIKEGUI, by itself, creates a new CALCIUMTOSPIKEGUI or raises the existing
%      singleton*.
%
%      H = CALCIUMTOSPIKEGUI returns the handle to a new CALCIUMTOSPIKEGUI or the handle to
%      the existing singleton*.
%
%      CALCIUMTOSPIKEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCIUMTOSPIKEGUI.M with the given input arguments.
%
%      CALCIUMTOSPIKEGUI('Property','Value',...) creates a new CALCIUMTOSPIKEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalciumToSpikeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalciumToSpikeGUI_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalciumToSpikeGUI

% Last Modified by GUIDE v2.5 21-Aug-2023 11:52:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalciumToSpikeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CalciumToSpikeGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CalciumToSpikeGUI is made visible.
function CalciumToSpikeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalciumToSpikeGUI (see VARARGIN)

% Choose default command line output for CalciumToSpikeGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
warning off
set(handles.saveAnalyzedDataLocationButton,'Enable','on','BackgroundColor',[0.94 0.94 0.94])
set(handles.calculateSpike,'Enable','off')
set(handles.roiExporter,'Enable','off')
set(handles.mescFileSelectionButton,'Enable','off')
set(handles.calculateDffButton,'Enable','off');
set(handles.FallFileSelectionButton,'Enable','off')
set(handles.isCellStatusBox,'String','isCell status:','ForegroundColor',[0.4 0.4 0.4])

set(handles.cellProbabilityThreshold,'Enable','off')
set(handles.text4,'Enable','off')

load('calciumToSpikeParams.mat')
calciumToSpikeParams.PSNR = 0;
calciumToSpikeParams.isSaveDataLocationSet = 0;
calciumToSpikeParams.saveAnalyzedData  = 0;
calciumToSpikeParams.isMescFileSelected = 0;
calciumToSpikeParams.mescDataLocation = 0;
calciumToSpikeParams.mescDataName = 0;
calciumToSpikeParams.frameRate = 0;
calciumToSpikeParams.isFallSelected = 0;
set(handles.cellProbabilityThreshold,'String',calciumToSpikeParams.cellClassifierThreshold);
set(handles.cellProbThres,'Value',calciumToSpikeParams.cellProbThres);
if calciumToSpikeParams.cellProbThres == 1
    set(handles.cellProbabilityThreshold,'Enable','on')
    set(handles.text4,'Enable','on')
elseif calciumToSpikeParams.cellProbThres == 0
    set(handles.cellProbabilityThreshold,'Enable','off')
    set(handles.text4,'Enable','off')
end

set(handles.numberOfLayers,'String',calciumToSpikeParams.numLayers)

calciumToSpikeParams.originalCodePath = uigetdir('','Define the code repository path first');
cd(calciumToSpikeParams.originalCodePath)
save('calciumToSpikeParams.mat','calciumToSpikeParams')



% UIWAIT makes CalciumToSpikeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalciumToSpikeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% cd('C:\Users\abhrajyoti.chakrabarti\Documents\GitHub\OASIS mods')
load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.originalCodePath)



function cellProbabilityThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to cellProbabilityThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cellProbabilityThreshold as text
%        str2double(get(hObject,'String')) returns contents of cellProbabilityThreshold as a double

load('calciumToSpikeParams.mat')
calciumToSpikeParams.cellClassifierThreshold = str2double(get(hObject,'String'));
save('calciumToSpikeParams.mat','calciumToSpikeParams')


% --- Executes during object creation, after setting all properties.
function cellProbabilityThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellProbabilityThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculateDffButton.
function calculateDffButton_Callback(hObject, eventdata, handles)
% hObject    handle to calculateDffButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('calciumToSpikeParams.mat')
try
    while calciumToSpikeParams.isDffDone == 0;
        set(handles.calculateDffButton,'String','dF/F Running','ForegroundColor','red')
        [deltaff,PSNR] = DffCalculationAfterPSNRfiltering(calciumToSpikeParams);
        calciumToSpikeParams.isDffDone = 1;
    end

    cd(calciumToSpikeParams.saveAnalyzedData)
    save('C2S_AnalyzedData.mat','PSNR','deltaff')

    calciumToSpikeParams.PSNR = PSNR;
    calciumToSpikeParams.totalCells = length(calciumToSpikeParams.PSNR);
    calciumToSpikeParams.cellsPassingPSNRfilter = size(deltaff,1);
    cd(calciumToSpikeParams.originalCodePath)
    calciumToSpikeParams.isDffDone = 0;
    save('calciumToSpikeParams.mat','calciumToSpikeParams')
    set(handles.calculateDffButton,'String','dF/F done','BackgroundColor','green','ForegroundColor','black')
    set(handles.calculateSpike,'Enable','on')
    set(handles.GUIstatusBox,'String','No issues','ForegroundColor',[0.64 0.08 0.18])
    
catch
    set(handles.GUIstatusBox,'String','dF/F calculation error','ForegroundColor',[0.64 0.08 0.18])
    set(handles.calculateDffButton,'String','Calculate dF/F','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
    set(handles.calculateSpike,'Enable','off')
    cd(calciumToSpikeParams.originalCodePath)
end



% --- Executes on button press in calculateSpike.
function calculateSpike_Callback(hObject, eventdata, handles)
% hObject    handle to calculateSpike (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('calciumToSpikeParams.mat')
try
    cd(calciumToSpikeParams.saveAnalyzedData)
    load('C2S_AnalyzedData.mat')
    while calciumToSpikeParams.isSpikeDone == 0
        set(handles.calculateSpike,'String','Spike Estimation Running','ForegroundColor','red')
        [populationSpikeMatrix, populationSpikeProbability] = GenerateSpikeProbabilityAndBinaryMatrixByOASIS(deltaff);
        calciumToSpikeParams.isSpikeDone = 1;
    end

    calciumToSpikeParams.numberOfUnitsForSpikeDetected = size(populationSpikeMatrix,1);
    calciumToSpikeParams.isSpikeDone = 0;
    save('C2S_AnalyzedData.mat','populationSpikeMatrix','populationSpikeProbability','-append')
    cd(calciumToSpikeParams.originalCodePath)

    set(handles.calculateSpike,'String','dF/F to Spike done','BackgroundColor','green','ForegroundColor','black')
    set(handles.GUIstatusBox,'String','No issues','ForegroundColor',[0.64 0.08 0.18])
    set(handles.roiExporter,'Enable','on')

 catch
    set(handles.GUIstatusBox,'String','Spike estimation error','ForegroundColor',[0.64 0.08 0.18])
    set(handles.calculateSpike,'String','Convert dF/F to Spike','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
    set(handles.calculateSpike,'Enable','off')
    cd(calciumToSpikeParams.originalCodePath)
end
  


% --- Executes on button press in roiExporter.
function roiExporter_Callback(hObject, eventdata, handles)
% hObject    handle to roiExporter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('calciumToSpikeParams.mat')

lastBackslashIndex = find(calciumToSpikeParams.FallDataPath == '\', 1, 'last');
% Crop the text until the last backslash, this changes the folder path containing the selected Fall.mat file
cd(calciumToSpikeParams.FallDataPath(1:lastBackslashIndex - 1))
% Crop the text after the last backslash, this loads the selected Fall.mat file
load(calciumToSpikeParams.FallDataPath(lastBackslashIndex + 1:end))

try
    while calciumToSpikeParams.isROIExportDone == 0
        set(handles.roiExporter,'String','ROIs Exporting','ForegroundColor','red')
        [xCoord,yCoord] = RoiCoordinateExporterFromSuite2p(stat,isCell,calciumToSpikeParams);
        calciumToSpikeParams.isROIExportDone = 1;
    end

    calciumToSpikeParams.unitsHavingCoordExported = size(xCoord,2);
    cd(calciumToSpikeParams.saveAnalyzedData)
    save('C2S_AnalyzedData.mat','xCoord','yCoord','-append')
    calciumToSpikeParams.isROIExportDone = 0;
    set(handles.roiExporter,'String','ROIs Exported','ForegroundColor','black','BackgroundColor','green')
    set(handles.GUIstatusBox,'String','No issues','ForegroundColor',[0.64 0.08 0.18])
        
    set(handles.totalCells,'String',num2str(calciumToSpikeParams.totalCells))
    set(handles.cellsAfterPSNR,'String',num2str(calciumToSpikeParams.cellsPassingPSNRfilter))
    set(handles.unitsWithROIexported,'String',num2str(calciumToSpikeParams.unitsHavingCoordExported))
    
    cd(calciumToSpikeParams.originalCodePath)

catch
    set(handles.GUIstatusBox,'String','ROI export error','ForegroundColor',[0.64 0.08 0.18])
    set(handles.roiExporter,'String','Export ROI','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
    cd(calciumToSpikeParams.originalCodePath)
end


    warning on


% --- Executes on button press in resetGUI.
function resetGUI_Callback(hObject, eventdata, handles)
% hObject    handle to resetGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.GUIstatusBox,'String','No issues','ForegroundColor','black')
set(handles.saveAnalyzedDataLocationButton,'String','Specify save location for analyzed data','Enable','on','BackgroundColor',[0.94 0.94 0.94])
set(handles.mescFileSelectionButton,'Enable','off','BackgroundColor',[0.94 0.94 0.94])
set(handles.calculateSpike,'String','Convert dF/F to Spike','Enable','off','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
set(handles.roiExporter,'Enable','off','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
set(handles.calculateDffButton,'Enable','off','String','Calculate dF/F','ForegroundColor','black','BackgroundColor',[0.94 0.94 0.94])
set(handles.FallFileSelectionButton,'Enable','off','BackgroundColor',[0.94 0.94 0.94])
set(handles.isCellStatusBox,'String','isCell status:','ForegroundColor',[0.4 0.4 0.4])

set(handles.totalCells,'String','')
set(handles.cellsAfterPSNR,'String','')
set(handles.unitsWithROIexported,'String','')





% --- Executes on button press in cellProbThres.
function cellProbThres_Callback(hObject, eventdata, handles)
% hObject    handle to cellProbThres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cellProbThres
load('calciumToSpikeParams.mat')
cd(calciumToSpikeParams.originalCodePath)

calciumToSpikeParams.cellProbThres = get(hObject,'Value');
save('calciumToSpikeParams.mat','calciumToSpikeParams')
if calciumToSpikeParams.cellProbThres == 1
    set(handles.cellProbabilityThreshold,'Enable','on')
    set(handles.text4,'Enable','on')
elseif calciumToSpikeParams.cellProbThres == 0
    set(handles.cellProbabilityThreshold,'Enable','off')
    set(handles.text4,'Enable','off')
end


% --- Executes on button press in spikePool.
function spikePool_Callback(hObject, eventdata, handles)
% hObject    handle to spikePool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    load('calciumToSpikeParams.mat')
    CompileSpikeData(calciumToSpikeParams.numLayers)
    set(handles.spikePool,'BackgroundColor',rand(1,3));
catch
    disp('Pooling spikedata inturrupted')
end


% --- Executes on button press in ROIPool.
function ROIPool_Callback(hObject, eventdata, handles)
% hObject    handle to ROIPool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    load('calciumToSpikeParams.mat')
    CompileROIData(calciumToSpikeParams.numLayers)
    set(handles.ROIPool,'BackgroundColor',rand(1,3));
catch
    disp('Pooling ROI coordinates inturrupted')
end


function numberOfLayers_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfLayers as text
%        str2double(get(hObject,'String')) returns contents of numberOfLayers as a double
load('calciumToSpikeParams.mat')
calciumToSpikeParams.numLayers = str2double(get(hObject,'String'));
save('calciumToSpikeParams.mat','calciumToSpikeParams')



% --- Executes during object creation, after setting all properties.
function numberOfLayers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfLayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveAnalyzedDataLocationButton.
function saveAnalyzedDataLocationButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveAnalyzedDataLocationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.saveAnalyzedDataLocationButton,'String','Specify save location for analyzed data','BackgroundColor',[0.94 0.94 0.94])
load('calciumToSpikeParams.mat')
while calciumToSpikeParams.isSaveDataLocationSet == 0
    calciumToSpikeParams.saveAnalyzedData = uigetdir('','Specify the location to save all analyzed data');
    if ischar(calciumToSpikeParams.saveAnalyzedData) == 1
        calciumToSpikeParams.isSaveDataLocationSet = 1;
        cd(calciumToSpikeParams.saveAnalyzedData)
        mkdir('AnalyzedCalciumToSpikeData')
        calciumToSpikeParams.saveAnalyzedData = strcat(calciumToSpikeParams.saveAnalyzedData,'\AnalyzedCalciumToSpikeData');
        cd(calciumToSpikeParams.originalCodePath)
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.saveAnalyzedDataLocationButton,'String','Save location specified','BackgroundColor','green')
        set(handles.mescFileSelectionButton,'Enable','on')
        set(handles.GUIstatusBox,'String','No issues','ForegroundColor','black')
    else
        calciumToSpikeParams.isSaveDataLocationSet = 1;
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.GUIstatusBox,'String','Analyzed data save location not specified','ForegroundColor',[0.64 0.08 0.18])
    end
end
cd(calciumToSpikeParams.originalCodePath)
calciumToSpikeParams.isSaveDataLocationSet = 0;
save('calciumToSpikeParams.mat','calciumToSpikeParams')


% --- Executes on button press in mescFileSelectionButton.
function mescFileSelectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to mescFileSelectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mescFileSelectionButton,'String','Select MESc file','BackgroundColor',[0.94 0.94 0.94])
load('calciumToSpikeParams.mat')
while calciumToSpikeParams.isMescFileSelected == 0
    [calciumToSpikeParams.mescDataName, calciumToSpikeParams.mescDataLocation] = uigetfile('*.mesc','Select the MESc data');
    if ischar(calciumToSpikeParams.mescDataLocation) == 1
        cd(calciumToSpikeParams.originalCodePath)
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.mescFileSelectionButton,'String','MESc file selected','BackgroundColor','green')
        set(handles.FallFileSelectionButton,'Enable','on')
        set(handles.GUIstatusBox,'String','No issues','ForegroundColor','black')
        cd(calciumToSpikeParams.mescDataLocation)
        tStepsInMs = h5readatt(strcat(calciumToSpikeParams.mescDataLocation,calciumToSpikeParams.mescDataName),'/MSession_0/MUnit_20/','TStepInMs');
        calciumToSpikeParams.frameRate = (1/tStepsInMs)*1000;
        calciumToSpikeParams.isMescFileSelected = 1;
    else
        calciumToSpikeParams.isMescFileSelected = 1;
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.GUIstatusBox,'String','MESc file selection interrupted','ForegroundColor',[0.64 0.08 0.18])
    end
end
cd(calciumToSpikeParams.originalCodePath)
calciumToSpikeParams.isMescFileSelected = 0;
save('calciumToSpikeParams.mat','calciumToSpikeParams')




% --- Executes on button press in FallFileSelectionButton.
function FallFileSelectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to FallFileSelectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.FallFileSelectionButton,'String','Select Fall.mat file','BackgroundColor',[0.94 0.94 0.94])
load('calciumToSpikeParams.mat')
while calciumToSpikeParams.isFallSelected == 0
    [fileName, filePath] = uigetfile('*.mat','Select the Fall.mat file');
    if ischar(filePath) == 1
        calciumToSpikeParams.FallDataPath = strcat(filePath,fileName);
        load(calciumToSpikeParams.FallDataPath)
        if exist('isCell') == 1
            set(handles.isCellStatusBox,'String','isCell status: Good','ForegroundColor',[0.64 0.08 0.18])
        else
            set(handles.isCellStatusBox,'String','isCell status: Renamed to isCell','ForegroundColor',[0.64 0.08 0.18])
            RENAMEiscellTOisCell(calciumToSpikeParams)
        end
        cd(calciumToSpikeParams.originalCodePath)
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.FallFileSelectionButton,'String','Fall.mat selected','BackgroundColor','green')
        set(handles.calculateDffButton,'Enable','on')
        set(handles.GUIstatusBox,'String','No issues','ForegroundColor','black')
        calciumToSpikeParams.isFallSelected = 1;
    else
        calciumToSpikeParams.isFallSelected = 1;
        save('calciumToSpikeParams.mat','calciumToSpikeParams')
        set(handles.FallFileSelectionButton,'Enable','on','BackgroundColor',[0.94 0.94 0.94])
        set(handles.isCellStatusBox,'String','isCell status:','ForegroundColor',[0.4 0.4 0.4])
        set(handles.GUIstatusBox,'String','Fall.mat file selection interrupted','ForegroundColor',[0.64 0.08 0.18])
    end
end
cd(calciumToSpikeParams.originalCodePath)
calciumToSpikeParams.isFallSelected = 0;
save('calciumToSpikeParams.mat','calciumToSpikeParams')


% --- Executes on button press in resetDffSpikeROI.
function resetDffSpikeROI_Callback(hObject, eventdata, handles)
% hObject    handle to resetDffSpikeROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.GUIstatusBox,'String','No issues','ForegroundColor','black')
set(handles.calculateSpike,'String','Convert dF/F to Spike','Enable','off','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')
set(handles.roiExporter,'Enable','off','BackgroundColor',[0.94 0.94 0.94])
set(handles.calculateDffButton,'Enable','on','String','Calculate dF/F','ForegroundColor','black','BackgroundColor',[0.94 0.94 0.94])
set(handles.roiExporter,'Enable','off','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor','black')

set(handles.totalCells,'String','')
set(handles.cellsAfterPSNR,'String','')
set(handles.unitsWithROIexported,'String','')
