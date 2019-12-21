function varargout = advancedCycleGui(varargin)
% ADVANCEDCYCLEGUI_1 M-file for advancedCycleGuiTimer.fig
%      ADVANCEDCYCLEGUI_1, by itself, creates a new ADVANCEDCYCLEGUI_1 or raises the existing
%      singleton*.
%
%      H = ADVANCEDCYCLEGUI_1 returns the handle to a new ADVANCEDCYCLEGUI_1 or the handle to
%      the existing singleton*.
%
%      ADVANCEDCYCLEGUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADVANCEDCYCLEGUI_1.M with the given input arguments.
%
%      ADVANCEDCYCLEGUI_1('Property','Value',...) creates a new ADVANCEDCYCLEGUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before advancedCycleGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to advancedCycleGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help advancedCycleGui

% Last Modified by GUIDE v2.5 08-Feb-2011 15:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @advancedCycleGui_OpeningFcn, ...
                   'gui_OutputFcn',  @advancedCycleGui_OutputFcn, ...
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


% --- Executes just before advancedCycleGUI is made visible.
function advancedCycleGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to advancedCycleGUI (see VARARGIN)

% Choose default command line output for advancedCycleGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes advancedCycleGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = advancedCycleGui_OutputFcn(hObject, eventdata, handles)
	varargout{1} = handles.output;

function deleteCyclePos_Callback(h, eventdata, handles)
	timerCycle_deletePosition

function insertCyclePos_Callback(h, eventdata, handles)
	timerCycle_insertPosition
	
function generic_Callback(h, eventdata, handles)
	genericCallback(h);
	
function repeatsDone_Callback(h, eventdata, handles)
	genericCallback(h);

function displayCyclePosition_Callback(h, eventdata, handles)
	genericCallback(h);
	global state
	timerCycle_setDisplayPosition(state.cycle.displayCyclePosition);

function redefineCycle_Callback(h, eventdata, handles)
	genericCallback(h);

    try
		global state
        
        callingPackage=getUserDataField(h, 'Package');
        
		
		state.internal.cycleChanged=1;
		tag=get(h, 'Tag');
		if ~isempty(findstr(tag, 'Slider'))
			tag=tag(1:end-6);
        end
	
        state.cycle.callingTag=tag;
        isCommon=any(cellfun(@(x) strcmp(tag, x), state.cycle.isCommonToAllPositions));
		if ~isCommon
            if isnumeric(state.cycle.(tag))
                state.cycle.([tag 'List'])(state.cycle.displayCyclePosition)=state.cycle.(tag);
            else
                state.cycle.([tag 'List']){state.cycle.displayCyclePosition}=state.cycle.(tag);
            end
        end
        
        if ~isempty(callingPackage)
            if isfield(state.internal, ['guiOrder' callingPackage])
                guiOrder=state.internal.(['guiOrder' callingPackage]);
                
           		p=strcmp(guiOrder, tag);
                if isempty(p)
                    guiOrder=state.cycle.guiOrder;
            		p=strcmp(guiOrder, tag);
                end
        		if any(p) 
                    global gh
                    p=mod(find(p)+1, length(guiOrder));
                    if p==0 
                        p=length(guiOrder);
                    end
                    eval(['uicontrol(gh.advancedCycleGui.' guiOrder{p} ');']);
                end
            end
        end
	catch
		disp(lasterr);
    end
    
    if ~isempty(callingPackage)
        timerCallPackageFunctions('CycleChanged', callingPackage, 1);
    end
    
    if state.cycle.displayCyclePosition==state.cycle.currentCyclePosition 
        if state.cycle.holdDAQUpdates
            setStatusString('UPDATES HELD');
        else
            timerCycle_applyPosition;
        end
    end
    
% --- Executes on button press in writeProtect.
function writeProtect_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

% --- Executes on button press in randomize.
function randomize_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	setupCycleRandomList;

% --- Executes on button press in useCyclePos.
function useCyclePos_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

% --- Executes on button press in loadCurrentButton.
function loadCurrentButton_Callback(hObject, eventdata, handles)
	putCurrentInCyclePos;
