function phScope_StartButtonPressed
%phScope_StartButtonPressed Handles the request to start or stop the scope
	
    global state gh

	persistent multipleAbortAttempts
	
	if (exist('multipleAbortAttempts', 'var')~=1)
		multipleAbortAttempts=0;
	end
	
	if strcmp(get(gh.scope.start, 'String'), 'Start')
		if ~ishandle(state.phys.internal.scopeHandle)
			error('Scope window has been destroyed');
		end
        state.phys.scope.needToStop=0;
		multipleAbortAttempts=0;
		timerRequestPause('Physiology');
		
		set(state.phys.internal.scopeHandle, 'Visible', 'on');	
		setPhysStatusString('Running Scope...');
		set(gh.physControls.startButton, 'Enable', 'off');
		set(gh.physControls.liveModeButton, 'Enable', 'off');
		
		set(gh.scope.start, 'String', 'Stop');

		phScope_run;
	else
		state.phys.scope.needToStop=1;
		setPhysStatusString('Stopping Scope...');
 
        multipleAbortAttempts=multipleAbortAttempts+1;
 		if multipleAbortAttempts>1;
 			phScope_stop;
 		end
	end

end

