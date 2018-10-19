function varargout = notebook(varargin)
% NOTEBOOK Application M-file for notebook.fig
%    FIG = NOTEBOOK launch notebook GUI.
%    NOTEBOOK('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 19-Oct-2018 14:49:12

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = edit_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	tag=get(h, 'Tag');
	n=str2num(tag(5:end));
	global state gh
	eval(['state.notebook.notebookText' num2str(state.notebook.notebookNumber) ...
		'{n+state.notebook.linePosition-1} = ' ...
		'getfield(state.notebook, [''line'' num2str(n)]);']);
	if n<7
		eval(['setfocus(gh.notebook.edit' num2str(n+1) ');']);
	else
		state.notebook.linePositionFlip=state.notebook.linePositionFlip-1;
		updateGuiByGlobal('state.notebook.linePositionFlip');
		lineSlider_Callback(gh.notebook.lineSlider);
		eval(['setfocus(gh.notebook.edit' num2str(n) ');']);
	end
	if state.files.autoSave
		saveNotebooks(state.notebook.notebookNumber);
	end
		

	 
% --------------------------------------------------------------------
function varargout = lineSlider_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	state.notebook.linePosition=1001-state.notebook.linePositionFlip+1;
	updateNotebookDisplay(state.notebook.linePosition);

% --------------------------------------------------------------------
function varargout = notebookNumber_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	updateNotebookDisplay;

% --------------------------------------------------------------------
function varargout = clearButton_Callback(h, eventdata, handles, varargin)
	global state

%	button = questdlg('Do you really want to erase the notebook?','Clear notebook?','Yes','No','Cancel','Yes');
	if 1 % strcmp(button, 'Yes')
		eval(['state.notebook.notebookText' num2str(state.notebook.notebookNumber) '={};']);
		updateNotebookDisplay;
	end
	if state.files.autoSave
		saveNotebooks(state.notebook.notebookNumber);
	end
	

function newEntry_Callback(hObject, eventdata, handles)
% hObject    handle to newEntry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newEntry as text
%        str2double(get(hObject,'String')) returns contents of newEntry as a double
	global state gh
    genericCallback(hObject);

    state.notebook.newEntry=strrep(state.notebook.newEntry, '''', '');
	addEntryToNotebook(1, ...
		[datestr(clock,13) ', Epoch ' num2str(state.epoch) ', Acq ' num2str(state.files.lastAcquisition) ' : ' state.notebook.newEntry]);
	
	state.notebook.newEntry='';
	updateGuiByGlobal('state.notebook.newEntry');
    


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
