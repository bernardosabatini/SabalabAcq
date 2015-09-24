function phScope_stop
	global state gh

	if nargin<1
		update=1;
	end

    state.phys.daq.scopeSession.stop;
	state.phys.daq.scopeSession.release;
    
	if update
		set(gh.scope.start, 'String', 'Start');
		set(gh.scope.start, 'Enable', 'on');
		
		if ~state.cycle.loopingStatus
			set(gh.physControls.startButton, 'Enable', 'on');
			set(gh.physControls.liveModeButton, 'Enable', 'on');			
		end
		setPhysStatusString('Ready');	
	end
	timerReleasePause('Physiology')