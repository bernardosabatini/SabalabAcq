function varargout = scope(varargin)
global scopeInput
% SCOPE Application M-file for scope.fig
%    FIG = SCOPE launch scope GUI.
%    SCOPE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 25-Feb-2014 11:39:40

if nargin == 0  % LAUNCH GUI
	
	fig = openfig(mfilename,'reuse');
	
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
function varargout = generic_Callback(h, eventdata, handles, varargin)
	genericCallback(h);

function varargout = fit_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
    global state

    if ~state.phys.scope.calcSeries 
        setWave('scopeInputFit0', 'data', []);
        setWave('scopeInputFit1', 'data', []);
    end
    
% --------------------------------------------------------------------
function varargout = changeOutput_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	state.phys.internal.needNewScopeOutput=1;

% --------------------------------------------------------------------
function varargout = changeDAQ_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
    global state
    state.phys.internal.needNewScopeOutput=1;
	state.phys.internal.needNewScopeDAQ=1;

% --------------------------------------------------------------------
function varargout = expand_Callback(h, eventdata, handles, varargin)
	global state gh
	if ~state.phys.scope.autoScale
		currentYlims=get(state.phys.internal.scopeAxisHandle,'YLim');
		range=currentYlims(2)-currentYlims(1);
		set(state.phys.internal.scopeAxisHandle,'YLim',[currentYlims(1)-.1*(range) currentYlims(2)+.1*(range)]);
	else
		autotog_Callback(gh.scope.autotog);
	end

% --------------------------------------------------------------------
function varargout = autotog_Callback(h, eventdata, handles, varargin)
	global state
	%control axis limits....
	if state.phys.scope.autoScale	%rescale axis and save old limits...
		set(h, 'String', 'Auto');
		state.phys.scope.autoScale=0;
		freeze(state.phys.internal.scopeAxisHandle);
	else
		set(h, 'String', 'Freeze');
		state.phys.scope.autoScale=1;
		release(state.phys.internal.scopeAxisHandle);
	end
	
	

% --------------------------------------------------------------------
function varargout = start_Callback(h, eventdata, handles, varargin)
    phScope_startButtonPressed

% --------------------------------------------------------------------
function varargout = range_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	set(state.phys.internal.scopeAxisHandle, 'YLim', [state.phys.scope.lowRange state.phys.scope.highRange]);


% --------------------------------------------------------------------
function varargout = noteR_Callback(h, eventdata, handles, varargin)
	global state
        
    chStr= num2str(state.phys.scope.channelsUsed(1));
    if state.phys.settings.(['currentClamp' chStr])
        str='Current clamp';
    else
        str='Voltage clamp';
    end

    addEntryToNotebook(1, [datestr(clock,13) '   ' str ' parameters for Channel ' chStr], 0);
    addEntryToNotebook(1, ['     RIn = ' num2str(state.phys.scope.RIn) ' MOhm;  Rs = ' ...
            num2str(state.phys.scope.Rs) ' MOhm;  Cm = ' num2str(state.phys.scope.Cm) ' pF'], 0);
    addEntryToNotebook(1, ['     <RIn> = ' num2str(state.phys.scope.RInAvg) ' MOhm;  <Rs> = ' ...
            num2str(state.phys.scope.RsAvg) ' MOhm;  <Cm> = ' num2str(state.phys.scope.CmAvg) ' pF'], 1);
    addEntryToNotebook(1, ['     Vm = ' num2str(getfield(state.phys.cellParams, ['vm' chStr])) ...
            ' mV;   Im = ' num2str(getfield(state.phys.cellParams, ['im' chStr])) ' pA']);
	
% --------------------------------------------------------------------
function varargout = inCell_Callback(h, eventdata, handles, varargin)
	global state
	
	hitclock=clock;

    chStr= num2str(state.phys.scope.channelsUsed(1));
    state.phys.cellParams.(['breakInClock' chStr])=hitclock;
	timeString=datestr(hitclock, 13);
	state.phys.cellParams.(['breakInTime' chStr])=timeString;
	updateGuiByGlobal(['state.phys.cellParams.breakInTime' chStr]);
	updateMinInCell;
	addEntryToNotebook(1, [datestr(hitclock,0) ': Broke into cell on channel #' chStr]);
	addEntryToNotebook(2, [datestr(hitclock,0) ': Broke into cell on channel #' chStr]);

function varargout = currentClamp0_Callback(h, eventdata, handles, varargin)
	genericCallback(h);
	global state
	if state.phys.settings.currentClamp0
		phClamp_setCurrentClamp(0);
	else
		phClamp_setVoltageClamp(0);
	end

% --- Executes during object creation, after setting all properties.
function channel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
