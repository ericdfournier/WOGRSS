function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 21-May-2015 10:36:18


%--------------------------------------------------------------------------
%                   GUI INITIALIZATION - DO NOT EDIT
%--------------------------------------------------------------------------


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%--------------------------------------------------------------------------
%                   PART 1: GENERATE REFERENCE GRID
%--------------------------------------------------------------------------


% --- Executes on button press in browseReferenceShapefilePath.
function browseReferenceShapefilePath_Callback(hObject, eventdata, handles)

% Get button status
browseReferenceShapefilePath = get(hObject,'Value');

% Prompt user to select boundary shapefile
if browseReferenceShapefilePath == 1
    [filename, pathname] = uigetfile('*.shp',...
        'Edit Reference Shapefile Path');
    referenceShapefileFilepath = [pathname,filename];
    handles.referenceShapeStruct = shaperead(referenceShapefileFilepath,...
        'UseGeoCoords',true);  
end

% Update text string
set(handles.editReferenceShapefilePath,'String',...
    referenceShapefileFilepath);

% Update handles structure
guidata(hObject,handles);

function editReferenceShapefilePath_Callback(hObject, eventdata, handles)

% Extract user input text for filepath
referenceShapefileFilepath = get(hObject,'String');

% Update text string
set(handles.editReferenceShapefilePath,'String',referenceShapefileFilepath);

% Update handles structure
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editReferenceShapefilePath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in browseOverlayShapefilePath.
function browseOverlayShapefilePath_Callback(hObject, eventdata, handles)

% Get button status
browseOverlayShapefilePath = get(hObject,'Value');

% Prompt user to select boundary shapefile
if browseOverlayShapefilePath == 1
    [filename, pathname] = uigetfile('*.shp',...
        'Edit Reference Shapefile Path');
    overlayFilepath = [pathname,filename];
    handles.overlayShapeStruct = shaperead(overlayFilepath,...
        'UseGeoCoords',true);  
end

% Update text string
set(handles.editOverlayShapefilePath,'String',overlayFilepath);

% Update handles structure
guidata(hObject,handles);

function editOverlayShapefilePath_Callback(hObject, eventdata, handles)

% Extract user input text for filepath
overlayShapefileFilepath = get(hObject,'String');

% Update text string
set(handles.editOverlayShapefilePath,'String',overlayShapefileFilepath);

% Update handles structure
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editOverlayShapefilePath_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editReferenceShapefileAttributeField_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editReferenceShapefileAttributeField_Callback(hObject, eventdata, handles)

% Extract User input hucCode string
handles.referenceAttributeFieldName = get(hObject,'String');

% Update handles structure
guidata(hObject,handles);

% Find the matching hucIndex
handles.referenceAttributeField = extractfield(handles.referenceShapeStruct,handles.referenceAttributeFieldName);

% Update handles structure
guidata(hObject,handles);


function editGridCellDensity_Callback(hObject, eventdata, handles)
% hObject    handle to editGridCellDensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Extract user input text for filepath
handles.gridCellDensity = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editGridCellDensity_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectReferenceBoundary.
function selectReferenceBoundary_Callback(hObject, eventdata, handles)

% Write default parameters
handles.gridDensity = 1116.99;

% Update handles structure
guidata(hObject,handles);

% Get button status
selectReferenceBoundaryStatus = get(hObject,'Value');

% Plug in parameter values and extract the grid mask
if selectReferenceBoundaryStatus == 1
    
    [handles.attributeCode, handles.attributeIndex ] = getHucCodeFnc( ...
        handles.referenceShapeStruct, ...
        handles.referenceAttributeFieldName, ...
        handles.overlayShapeStruct );
    
    [handles.gridMask, ...
        handles.gridMaskGeoRasterRef ] = hucCode2GridMaskFnc( ...
        handles.referenceShapeStruct, ...
        handles.attributeIndex, ...
        handles.gridCellDensity );
    
end

% Display Success message
set(handles.selectReferenceBoundary,'ForegroundColor',[0 0.498 0]);

% Update handles structure
guidata(hObject,handles);



%--------------------------------------------------------------------------
%                   PART 2: EXTRACT DATA
%--------------------------------------------------------------------------



% --- Executes on button press in browseTopLevelRasterDirectoryPath.
function browseTopLevelRasterDirectoryPath_Callback(hObject, eventdata, handles)

% Get button status
browseTopLevelRasterDataDirectoryButtonStatus = get(hObject,'Value');

% Prompt user to select top level raster directory
if browseTopLevelRasterDataDirectoryButtonStatus == 1
        
    % Prompt user for top level raster directory location
    handles.topLevelRasterDataDirectoryPath = uigetdir('/', ...
        'Select Top Level Raster Data Direcotory');
    guidata(hObject,handles);
    
    % Get initial table data and overwrite with subdirectory names
    initialRasterTableData = get(handles.tableRasterDataInputs,'Data');
    initialRasterTableRow = initialRasterTableData(1,:);
    rasterTableData = topLevelDir2ListArrayFnc( ...
        handles.topLevelRasterDataDirectoryPath);
    rowCount = numel(rasterTableData);
    initialRasterTableData = repmat(initialRasterTableRow,rowCount,1);
    newRasterTableData = initialRasterTableData(1:rowCount,:);
    for i = 1:rowCount
        newRasterTableData{i,1} = rasterTableData{i,1};
    end
    set(handles.tableRasterDataInputs,'Data',newRasterTableData);
    
end

% Update Handles Structure
guidata(hObject,handles);

% Set Filepath String Name
set(handles.editTopLevelRasterDirectoryFilepath,'String',...
    handles.topLevelRasterDataDirectoryPath);

% Update handles structure
guidata(hObject,handles);



function editTopLevelRasterDirectoryFilepath_Callback(hObject, eventdata, handles)

% Extract User input hucCode string
handles.topLevelRasterDataDirectoryPath = get(hObject,'String');

% Get initial table data and overwrite with subdirectory names
initialRasterTableData = get(handles.tableRasterDataInputs,'Data');
initialRasterTableRow = initialRasterTableData(1,:);
rasterTableData = topLevelDir2ListArrayFnc( ...
    handles.topLevelRasterDataDirectoryPath);
rowCount = numel(rasterTableData);
initialRasterTableData = repmat(initialRasterTableRow,rowCount,1);
newRasterTableData = initialRasterTableData(1:rowCount,:);
for i = 1:rowCount
    newRasterTableData{i,1} = rasterTableData{i,1};
end
set(handles.tableRasterDataInputs,'Data',newRasterTableData);

% Update handles structure
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editTopLevelRasterDirectoryFilepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTopLevelRasterDirectoryFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseTopLevelVectorDirectoryFilepath.
function browseTopLevelVectorDirectoryFilepath_Callback(hObject, eventdata, handles)

% Get bu
browseTopLevelVectorDataDirectoryButtonStatus = get(hObject,'Value');

% Prompt to select top level vector data directory
if browseTopLevelVectorDataDirectoryButtonStatus == 1
    
    handles.topLevelVectorDataDirectoryPath = uigetdir('/', ...
        'Select Top Level Vector Data Direcotory');
    guidata(hObject,handles);
    
    % Get initial table data and overwrite with subdirectory names
    initialVectorTableData = get(handles.tableVectorDataInputs,'Data');
    initialVectorTableRow = initialVectorTableData(1,:);
    vectorTableData = topLevelDir2ListArrayFnc( ...
        handles.topLevelVectorDataDirectoryPath);
    rowCount = numel(vectorTableData);
    initialVectorTableData = repmat(initialVectorTableRow,rowCount,1);
    newVectorTableData = initialVectorTableData(1:rowCount,:);
    for i = 1:rowCount
        newVectorTableData{i,1} = vectorTableData{i,1};
    end
    set(handles.tableVectorDataInputs,'Data',newVectorTableData);
    
end

% Update Handles Structure
guidata(hObject,handles);

% Set Filepath String Name
set(handles.editTopLevelVectorDirectoryFilepath,'String',...
    handles.topLevelVectorDataDirectoryPath);

% Update handles structure
guidata(hObject,handles);


function editTopLevelVectorDirectoryFilepath_Callback(hObject, eventdata, handles)

% Extract User input hucCode string
handles.topLevelVectorDataDirectoryPath = get(hObject,'String');

% Get initial table data and overwrite with subdirectory names
initialVectorTableData = get(handles.tableVectorDataInputs,'Data');
initialVectorTableRow = initialVectorTableData(1,:);
vectorTableData = topLevelDir2ListArrayFnc( ...
    handles.topLevelVectorDataDirectoryPath);
rowCount = numel(vectorTableData);
initialVectorTableData = repmat(initialVectorTableRow,rowCount,1);
newVectorTableData = initialVectorTableData(1:rowCount,:);
for i = 1:rowCount
    newVectorTableData{i,1} = vectorTableData{i,1};
end
set(handles.tableVectorDataInputs,'Data',newVectorTableData);
    
% Update Handles Structure
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editTopLevelVectorDirectoryFilepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTopLevelVectorDirectoryFilepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
%                   PART 3: OUTPUT DATA
%--------------------------------------------------------------------------



% --- Executes on button press in saveDataToFile.
function saveDataToFile_Callback(hObject, eventdata, handles)

% Get button status
saveDataToFileButtonStatus = get(hObject,'Value');

% Request destination file location from user
if saveDataToFileButtonStatus == 1
    
    % Get raster NaN floor value array
    
    tmp = get(handles.tableRasterDataInputs,'Data');
    handles.rasterNanFloors = [tmp{:,2}]';
    
    % Get vector data attribute field array
    
    tmp = get(handles.tableVectorDataInputs,'Data');
    handles.attributeFieldCell = tmp(:,2);
    
    % Update handles structure
    guidata(hObject,handles);
    
    % Extract raw mosaic data

    handles.rawRasterMosaicData = extractRawRasterMosaicDataFnc( ...
        handles.topLevelRasterDataDirectoryPath, ...
        handles.topLevelVectorDataDirectoryPath, ...
        handles.rasterNanFloors, ...
        handles.gridDensity, ...
        handles.attributeFieldCell, ...
        handles.referenceShapeStruct, ...
        handles.attributeIndex, ...
        handles.gridMask, ...
        handles.gridMaskGeoRasterRef );
    
    % Prompt user for filepath
    outputData = handles.rawRasterMosaicData;
    destinDirectory = uigetdir;
    timeStampString = datestr(now,30);
    save([destinDirectory,'/WOSS_PARAMETERS_',timeStampString,'.mat'],...
        'outputData');
    
end

% Display success message
set(handles.saveDataToFile,'ForegroundColor',[0 0.498 0]);
set(handles.saveDataToFile,'FontWeight','bold');

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in saveDataToWorkspace.
function saveDataToWorkspace_Callback(hObject, eventdata, handles)

% Get button status
saveDataToWorkspaceButtonStatus = get(hObject,'Value');

% Request destination file location from user
if saveDataToWorkspaceButtonStatus == 1
    
    % Get raster NaN floor value array
    
    tmp = get(handles.tableRasterDataInputs,'Data');
    handles.rasterNanFloors = [tmp{:,2}]';
    
    % Get vector data attribute field array
    
    tmp = get(handles.tableVectorDataInputs,'Data');
    handles.attributeFieldCell = tmp(:,2);
    
    % Update handles structure
    guidata(hObject,handles);
    
    % Extract raw mosaic data

    handles.rawRasterMosaicData = extractRawRasterMosaicDataFnc( ...
        handles.topLevelRasterDataDirectoryPath, ...
        handles.topLevelVectorDataDirectoryPath, ...
        handles.rasterNanFloors, ...
        handles.gridDensity, ...
        handles.attributeFieldCell, ...
        handles.referenceShapeStruct, ...
        handles.attributeIndex, ...
        handles.gridMask, ...
        handles.gridMaskGeoRasterRef );
    
    % Prompt user for filepath
    outputData = handles.rawRasterMosaicData;
    assignin('base','result',outputData);
    
end

% Display success message
set(handles.saveDataToWorkspace,'ForegroundColor',[0 0.498 0]);
set(handles.saveDataToWorkspace,'FontWeight','bold');

% Update handles structure
guidata(hObject,handles);
