function varargout = timerMainControls(varargin)
% TIMERMAINCONTROLS M-file for timerMainControls.fig
%      TIMERMAINCONTROLS, by itself, creates a new TIMERMAINCONTROLS or raises the existing
%      singleton*.
%
%      H = TIMERMAINCONTROLS returns the handle to a new TIMERMAINCONTROLS or the handle to
%      the existing singleton*.
%
%      TIMERMAINCONTROLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMERMAINCONTROLS.M with the given input arguments.
%
%      TIMERMAINCONTROLS('Property','Value',...) creates a new TIMERMAINCONTROLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before timerMainControls_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to timerMainControls_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help timerMainControls

% Last Modified by GUIDE v2.5 30-Mar-2018 08:29:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @timerMainControls_OpeningFcn, ...
                   'gui_OutputFcn',  @timerMainControls_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before timerMainControls is made visible.
function timerMainControls_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to timerMainControls (see VARARGIN)

% Choose default command line output for timerMainControls
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes timerMainControls wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = timerMainControls_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in doOne.
function doOne_Callback(hObject, eventdata, handles)
	timerDoOne

function loop_Callback(hObject, eventdata, handles)
	timerLoop

function baseName_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
	global state
	if ~isempty(state.internal.excelChannel)
		try
			ddepoke(state.internal.excelChannel, 'r4c2', state.files.baseName);
		catch
			disp('baseName_Callback : Unable to link to excel');
		end
	end

function fileCounter_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function autoSave_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function cyclePosition_Callback(h, eventdata, handles)
	genericCallback(h);
	timerCycle_setPosition;
	set(h, 'Enable', 'on');

function repeatsDone_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
function repeatsDoneSlider_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
function cycleName_CreateFcn(hObject, eventdata, handles)
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));

function cycleName_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

function reviewCounter_Callback(hObject, eventdata, handles)
	genericCallback(hObject);
    timerCallPackageFunctions('Review');

function epoch_Callback(hObject, eventdata, handles)
    str=get(hObject, 'String');
    
    global state
    if(size(str,2)==0 || size(str2num(str),1))
        genericCallback(hObject);
        hitclock=clock;
    	addEntryToNotebook(1, [datestr(hitclock,0) ': Changed epoch to ' num2str(state.epoch)]);
    	addEntryToNotebook(2, [datestr(hitclock,0) ': Changed epoch to ' num2str(state.epoch)]);
    else
        state.epoch=state.epoch+1;
        try
        state.epochName=str;
        catch
        end
        setGUIValue(hObject, state.epoch);
        
        genericCallback(hObject);
    	hitclock=clock;
    	addEntryToNotebook(1, [datestr(hitclock,0) ': Changed epoch to ' num2str(state.epoch) ' - ' str]);
    	addEntryToNotebook(2, [datestr(hitclock,0) ': Changed epoch to ' num2str(state.epoch) ' - ' str]);
    end
    if length(state.internal.epochsUsed)<state.epoch
        state.internal.epochsUsed(end+1:state.epoch)=0;
    end
    timerCallPackageFunctions('ChangedEpoch');
    


% --------------------------------------------------------------------
function Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function user_Callback(hObject, eventdata, handles)
	genericCallback(hObject);

% --- Executes during object creation, after setting all properties.
function user_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
